# 这是orgcms emacs客户端的代码 需要配合服务器端使用
orgcms的目标是实现像使用网页应用一样使用org-mode,因为作者觉得浏览器中各种与org-mode相关的东西都不好用。

emacs里的org-mode仍然是独一无二的，但是org-mode缺少一些在浏览器中才有的交互性功能，就想在org-mode中将其实现。

使用：
1，下载 orgcms.el文件放到emacs可找到的位置，如~/.emacs.d/lisp/orgcms.el

2，执行 (require 'orgcms) 或者 (require 'orgcms-autoloads) 

3，打开任意一个org文件(没有重要内容的)，输入 [[elisp:(orgcms-load "http://localhost/org")][首 页]]

4，点击这个首页按钮即进入orgcms的首页
# 注意事项
org-mode的配置文件参考 [org-conf.el](//github.com/wsug/orgcms/blob/main/org-conf.el) 这个文件

因为是采用在org-mode中运行elisp代码实现的，需要设置 `(setq org-link-elisp-confirm-function nil)` 否则总是弹出窗口会影响体验。

而这样设置可能会出现`[elisp:(shell-command "rm -rf ~/*")]`这样的情况，需要注意。

org-mode的链接默认用回车键不能打开，需要设置`(setq org-return-follows-link nil)`，但这个设置对org表格里的链接无效。

orgcms首页用的是表格，目前使用 [自定义链接](https://emacs-china.org/t/org-mode-org-mode/15847/18) 来解决这个问题

参考 https://emacs-china.org/t/org-mode-org-mode/15847
