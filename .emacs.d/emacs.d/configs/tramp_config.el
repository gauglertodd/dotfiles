(require 'tramp)
;; Since we're going to be doing this a lot, the minibar message
;; tramp spits out for every file access is both spammy, distracting,
;; and often hides more relevant messages.
;; (setq tramp-message-show-message nil)
;; Let tramp search $PATH as given to the $USER on the remote machine
;; (necessary to find 'hphpd' for instance)

;; ;; This is advice from here: https://github.com/syl20bnr/spacemacs/issues/11381
;; ;; (defadvice projectile-project-root (around ignore-remote first activate)
;; ;;   (unless (file-remote-p default-directory) ad-do-it))
;; ;; (setq projectile-mode-line "Projectile")

;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;; (add-to-list 'tramp-remote-path "/bin/cquery")
;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;; (setq cquery-executable "/sshx:localhost#10022://bin/cquery")
;; (add-to-list 'tramp-remote-path "/bin")

;; (setq tramp-verbose 10)

;; (add-to-list 'tramp-connection-properties
;;              (list (regexp-quote "/ssh:devf:")
;;                    "remote-shell" "/usr/bin/zsh"))
;; ;; (customize-set-variable 'tramp-encoding-shell "/bin/zsh")

(custom-set-variables
 '(process-connection-type t)
 '(server-port "1492")
 '(server-use-tcp t)
 '(explicit-shell-file-name "/bin/bash")
 '(tramp-verbose 1)
 '(tramp-completion-reread-directory-timeout nil)
 '(tramp-use-ssh-controlmaster-options nil)
 '(tramp-default-method "ssh")
 '(tramp-default-remote-shell "/bin/bash")
 '(tramp-encoding-shell "/bin/bash")
 '(tramp-remote-path (cons 'tramp-own-remote-path (cons "/usr/local/bin" tramp-remote-path)))
 '(xbgX-exec-dir "/ssh:s:")
 '(hh-client-www-root (expand-file-name "/ssh:s:~/www")))

(add-to-list 'tramp-remote-path "/bin/cquery")
(add-to-list 'tramp-remote-path 'tramp-own-remote-path)
(setq  tramp-shell-prompt-pattern "$ *")
(setq tramp-message-show-message nil)

;; This ignores Tramps' version control checking.
(setq vc-ignore-dir-regexp
      (format "\\(%s\\)\\|\\(%s\\)"
              vc-ignore-dir-regexp
              tramp-file-name-regexp))
