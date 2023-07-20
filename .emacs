;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;; (package-initialize)
(require 'use-package)

;; (require 'package)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; ;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; ;; and `package-pinned-packages`. Most users will not need or want to do this.
;; ;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (package-initialize)

(require 'exec-path-from-shell) ;; if not using the ELPA package
    (exec-path-from-shell-initialize)

(add-to-list 'load-path "~/.emacs.d/configs")
(load "~/.emacs.d/configs/clang_format_config.el")
(load "~/.emacs.d/configs/flymake_config.el")
(load "~/.emacs.d/configs/general_purpose_config.el")
(load "~/.emacs.d/configs/ibuffer_config.el")
(load "~/.emacs.d/configs/jedi_config.el")
(load "~/.emacs.d/configs/org_config.el")
(load "~/.emacs.d/configs/tramp_config.el")
(load "~/.emacs.d/configs/autoformat_config.el")
(load "~/.emacs.d/configs/org_config.el")
(load "~/.emacs.d/configs/python_config.el")

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(connection-local-criteria-alist
   '(((:application tramp :machine "localhost")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp :machine "MacBook-Pro")
      tramp-connection-local-darwin-ps-profile)
     ((:application tramp)
      tramp-connection-local-default-system-profile tramp-connection-local-default-shell-profile)))
 '(connection-local-profile-alist
   '((tramp-connection-local-darwin-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,uid,user,gid,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state=abcde" "-o" "ppid,pgid,sess,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etime,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . tramp-ps-time)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-busybox-ps-profile
      (tramp-process-attributes-ps-args "-o" "pid,user,group,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "stat=abcde" "-o" "ppid,pgid,tty,time,nice,etime,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (user . string)
       (group . string)
       (comm . 52)
       (state . 5)
       (ppid . number)
       (pgrp . number)
       (ttname . string)
       (time . tramp-ps-time)
       (nice . number)
       (etime . tramp-ps-time)
       (args)))
     (tramp-connection-local-bsd-ps-profile
      (tramp-process-attributes-ps-args "-acxww" "-o" "pid,euid,user,egid,egroup,comm=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" "-o" "state,ppid,pgid,sid,tty,tpgid,minflt,majflt,time,pri,nice,vsz,rss,etimes,pcpu,pmem,args")
      (tramp-process-attributes-ps-format
       (pid . number)
       (euid . number)
       (user . string)
       (egid . number)
       (group . string)
       (comm . 52)
       (state . string)
       (ppid . number)
       (pgrp . number)
       (sess . number)
       (ttname . string)
       (tpgid . number)
       (minflt . number)
       (majflt . number)
       (time . tramp-ps-time)
       (pri . number)
       (nice . number)
       (vsize . number)
       (rss . number)
       (etime . number)
       (pcpu . number)
       (pmem . number)
       (args)))
     (tramp-connection-local-default-shell-profile
      (shell-file-name . "/bin/sh")
      (shell-command-switch . "-c"))
     (tramp-connection-local-default-system-profile
      (path-separator . ":")
      (null-device . "/dev/null"))))
 '(electric-indent-mode nil)
 '(explicit-shell-file-name "/bin/bash")
 '(hh-client-www-root (expand-file-name "/ssh:s:~/www"))
 '(package-selected-packages
   '(rmsbolt exec-path-from-shell js-format rjsx-mode phps-mode tramp projectile wgrep-ag yasnippet yapfify use-package template sphinx-doc quelpa python-black py-yapf project-explorer powerline php-mode pdf-tools monky moe-theme material-theme magit lua-mode lsp-ui latex-preview-pane json-mode js-auto-beautify jedi highlight-escap... helm-swoop helm-gtags helm-ag helm hack-mode gruvbox-theme format-sql flymake-json flymake-cursor exec-path-from-... ess cquery company-lsp color-theme clang-format android-mode ag auto-complete auctex async))
 '(process-connection-type t t)
 '(server-port "1492")
 '(server-use-tcp t)
 '(show-paren-mode t)
 '(tramp-completion-reread-directory-timeout nil)
 '(tramp-default-method "ssh")
 '(tramp-default-remote-shell "/bin/bash" t)
 '(tramp-encoding-shell "/bin/bash")
 '(tramp-remote-path
   (cons 'tramp-own-remote-path
	 (cons "/usr/local/bin" tramp-remote-path)))
 '(tramp-use-ssh-controlmaster-options nil)
 '(tramp-verbose 1)
 '(xbgX-exec-dir "/ssh:s:"))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
