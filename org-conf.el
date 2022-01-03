;;在org中运行elisp时不弹窗确认 注意 [elisp:(shell-command "rm -rf ~/*")]
(setq org-link-elisp-confirm-function nil)
;; ---- 代码块相关的设置
(setq org-src-fontify-natively 1);代码块语法高亮
(setq org-src-tab-acts-natively 1);开启代码块语法缩进
(setq org-edit-src-content-indentation 0);代码块初始缩进范围
;; ---- 渲染相关设置
(setq org-pretty-entities t);某些数学公式按urt8符号形式显示
(setq org-pretty-entities-include-sub-superscripts t);上一设置中包含上标和下标
;(setq org-export-with-sub-superscripts '{});上标用原先的
(setq org-use-sub-superscripts '{});下标不能用_与php js函数命名冲突
(setq org-startup-folded 'content);;org文件打开即展开所有标题 

(add-hook 
 'org-mode-hook 
 (lambda ()
   (setq truncate-lines nil);自动换行
   ))
