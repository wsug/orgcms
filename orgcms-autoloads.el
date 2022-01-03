;;; orgcms-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "orgcms" "orgcms.el" (25042 34149 0 0))
;;; Generated autoloads from orgcms.el

(autoload 'orgcms-load "orgcms" "\
post形式发送

\(fn URL &optional ORG-TEXT ARGS)" nil nil)

(autoload 'orgcms-http-parse "orgcms" "\
解析服务器端返回的" nil nil)

(autoload 'orgcms-load-end "orgcms" "\
org文件加载完成后的位置调整 

\(fn ROW &optional TYPE)" nil nil)

(autoload 'orgcms-get-text "orgcms" "\
获取buffer中的org文本" nil nil)

(autoload 'orgcms-link-open-other-window "orgcms" "\
orgcms中打开链接时选择在当前窗口还是在其它窗口

\(fn &optional MOVE-CURSOR)" nil nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "orgcms" '("orgcms-buffer-name")))

;;;***

(provide 'orgcms-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; orgcms-autoloads.el ends here
