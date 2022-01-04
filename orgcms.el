
;; ---- ---- ---- ---- orgcms的异步http版本
(defvar orgcms-buffer-name ""
  "debug时保存当前buffer-name的位置输出" )
(defvar orgcms-user "游客" "用户名" )
(defvar orgcms-pw "" "密码" );;(setq orgcms-pw "-")
(defvar orgcms-cookieId "" "sessionId" );;
;;;###autoload  
(defun orgcms-load(url &optional org-text args)
  "post形式发送"
  (setq orgcms-buffer-name (buffer-name));;不发送到web后端的 debug时用
  (setq args 
        (format
         "buffer=%s&user=%s&pw=%s&cookieId=%s" 
         (url-hexify-string orgcms-buffer-name)
         (url-hexify-string orgcms-user) (url-hexify-string orgcms-pw)
         orgcms-cookieId
        ))
  (if (equal org-text 1)
      ;;(plist-put args 'org (buffer-string))
      (setq args (concat args (format "&org=%s" (orgcms-get-text))))
    )
  (message "%s" args)
  (let ((url-request-method "POST")
	    (url-request-extra-headers `(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data args)
        )
    (url-retrieve 
     url ;;"http://l/t/测试.php" 回调是在一个buffer中
     (lambda (status)
       ;(user-error "123")
       (orgcms-http-parse)
       ))
    )
  )
;;;###autoload 
(defun orgcms-http-parse()
  "解析服务器端返回的"
  ;(set-buffer-multibyte t);这个无法消除
  ;;(re-search-forward "^$")(delete-region (+ (point) 1)(point-min));原办法
  ;;(let (my-pos (point))) my-pos 页面刷新后保持原位置可能实现
  (forward-line 1);;第一行http状态码用不到
  (let ( org-buf (ready '("2" "table") ) body msg-con save-silently)
    (setq save-silently t);save-buffer执行时不出现提示
    (while (re-search-forward "^\\([^:]*\\): \\(.+\\)"
                              url-http-end-of-headers t)
      (cond ((equal "Buffer" (match-string 1))
             (setq org-buf (match-string 2)))
            ((equal "Message" (match-string 1))
             (setq msg-con (match-string 2)))
            ((equal "CookieId" (match-string 1))
             (setq orgcms-cookieId (match-string 2)))
            ((equal "Ready" (match-string 1))
             (progn (setq ready (split-string (match-string 2) " ")) ))
            ) )
    ;;(message (buffer-substring (point)(+ (point) 12)))确定循环结束后的位置
    ;;(goto-char (1+ url-http-end-of-headers))应该直接delete
    (delete-region (+ (point) 2)(point-min));+1才把第二个回车符删掉
    (setq body (decode-coding-string (buffer-string) 'utf-8-auto-dos))
    (if (equal org-buf nil);;未定义要跳转的buf就将其显示在message
        (message (decode-coding-string (buffer-string) 'utf-8-auto-dos))
      (with-current-buffer org-buf
          (erase-buffer) (save-excursion (insert body))
          ;;(eval (car (read-from-string (format "(progn %s)" ready))))
          (save-buffer);;有revert存在必须先save在执行
          (orgcms-load-end (string-to-number (car ready)) (nth 1 ready))
          (message (decode-coding-string msg-con 'utf-8-auto-dos))
        )
      ))
  )
;;;###autoload 
(defun orgcms-load-end(row &optional type )
  "org文件加载完成后的位置调整 ";;传入行号与操作类型
  (or type (setq type ""))
  (next-line row)(org-end-of-line)
  (cond 
   ((equal type "table")
    (progn (org-cycle)))
   ((equal type "revert");;目的是org文件的展开折叠回到默认值
    (progn (revert-buffer nil t)
           ;;(goto-char my-pos)
           ))
   ;;(t (message "type ???"))
  )
)
;;;###autoload 
(defun orgcms-get-text()
  "获取buffer中的org文本"
  (let (position body)
    (setq position (point));;保存当前位置
    (goto-char (point-min))
    (forward-line 1)
    (setq body (buffer-substring (point) (point-max)))
    (goto-char position)
    (url-hexify-string body)
    ))
;;;###autoload 
(defun orgcms-link-open-other-window(&optional move-cursor)
  "orgcms中打开链接时选择在当前窗口还是在其它窗口"
  ;;因为有save-buffer必须是实际org文件,不能只是buffer
  (let (body p1) ;因为有空格必须用[]包住否则不识别链接
    (re-search-backward "\\[\\[elisp:")
    (setq p1 (point))
    (re-search-forward "]\\[")
    (setq body ;链接中如果不带-,org会不渲染成链接
          (format "%s-]]" (buffer-substring p1 (point))))
    (find-file-other-window "~/.emacs.d/orgcms.org")
    (erase-buffer)(insert body)
    (backward-char 1);;后退才到到链接上打开
    (org-open-at-point)
    (when (equal move-cursor 1);;是否还保留在原窗口
      (other-window -1))
    )
  )

;; ---- ---- ---- ---- 按键设置
;;使org中的链接可以回车打开,在表格无效,改成用自定义链接
;;(setq org-return-follows-link nil);
(with-eval-after-load 'org
  (org-link-set-parameters
   "elisp"
   :keymap (let ((map (copy-keymap org-mouse-map)))
             (define-key map (kbd "<return>") 'org-open-at-point)
             (define-key map (kbd "<kp-enter>") 'org-open-at-point)
             ;;(define-key map (kbd "<mouse-3>");光标不在当前buffer点时会错乱 不能用
             ;;(lambda () (interactive) (orgcms-link-open-other-window) ))
             ;;(define-key map (kbd "O")
             ;;(lambda () (interactive) (orgcms-link-open-other-window) ))
             (define-key map (kbd "M-o")
               (lambda () (interactive) (orgcms-link-open-other-window 1) ))
             (define-key map (kbd "W")
               (lambda () (interactive)
                 (let* ((context (org-element-context))
                        (type (org-element-type context))
                        (beg (org-element-property :begin context))
                        (end (org-element-property :end context)))
                   (kill-region beg end)  )))
             
             map)
   :follow (lambda (path) ;;防止elisp链接点击时弹出的消息把minibuf加得太大
             (interactive);;max-mini-window-height
             (let (message-truncate-lines)
               (setq message-truncate-lines t)
               ;;(setq max-mini-window-height 1)
               (org-link--open-elisp path nil)
                                        ;(message "")
               )))
  )
(provide 'orgcms)
