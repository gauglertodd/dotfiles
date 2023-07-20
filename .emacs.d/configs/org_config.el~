;; For the purpose of org-mode level abbreviations.
(setq org-link-abbrev-alist '(("b" . "https://internalfb.com/intern/bunny/?q=")
			      ("d" . "https://internalfb.com/intern/diff/")
			      ("t" . "https://internalfb.com/intern/tasks/?t=")
			      ("s" . "https://internalfb.com/intern/sevmanager/view/s/")))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords
   'org-mode
   '(("^ *\\([-]\\) " (0 (prog1 ()
			   (compose-region (match-beginning 1)
					   (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil
			:font "Montserrat"
			:weight 'regular
			:height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil
		      :foreground nil
		      :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil
		      :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil
		      :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil
		      :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil
		      :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil
		      :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil
		      :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package
  org
  :hook (org-mode . efs/org-mode-setup)
  :config (setq org-ellipsis " ▾")
  (efs/org-font-setup))

(use-package
  org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

;; (defun efs/org-mode-visual-fill ()
;;   (setq visual-fill-column-width 300 visual-fill-column-center-text t)
;;   (visual-fill-column-mode 1))

;; (use-package
;;   visual-fill-column
;;   :hook (org-mode . efs/org-mode-visual-fill))

(add-hook 'org-mode-hook #'toggle-word-wrap)

;; (add-hook 'org-mode-hook #'(lambda ()
;;                              ;; make the lines in the buffer wrap around the edges of the screen.
;;                              ;; to press C-c q  or fill-paragraph ever again!
;;                              (visual-line-mode)
;; 			     (org-indent-mode)))

(setq org-hide-emphasis-markers t)

;; (setq org-todo-keyword-faces
;;       '(
;;         ("WISH" . (:foreground "orange" :weight bold))
;;         ("BLOCKED" . (:foreground "yellow" :weight bold))
;;         ))

;; ;; (setq org-todo-keywords
;; ;;       '((sequence "TODO" "BLOCKED" "DONE" "WISH")))

;; (setq org-todo-keyword-faces
;;       '(("TODO" . org-warning) ("STARTED" . "yellow")
;;         ("CANCELED" . (:foreground "blue" :weight bold))))

;; Theoretically, this should add a weekly review option to org-agenda mode
;; (add-to-list 'org-agenda-custom-commands
;;              '("W" "Weekly review"
;;                agenda ""
;;                ((org-agenda-start-day "-14d")
;;                 (org-agenda-span 14)
;;                 (org-agenda-start-on-weekday org)
;;                 (1-agenda-start-with-log-mode '(closed))
;;                 (org-agenda-skip-function '(org-agenda-skip-entry-if 'notregexp "^\\*\\* DONE ")))))

(setq org-agenda-custom-commands '(("W" "Weekly review" agenda "" ((org-agenda-start-day "-14d")
								   (org-agenda-span 14)
								   (org-agenda-start-on-weekday 1)
								   (org-agenda-start-with-log-mode
								    '(closed))
								   (org-agenda-archives-mode t)
								   (org-agenda-skip-function
								    '(org-agenda-skip-entry-if
								      'notregexp ".* DONE "))))
				   ("n" "Agenda and all TODOs" agenda "" ((alltodo "")))))

(use-package
  org-fancy-priorities
  :ensure t
  :hook (org-mode . org-fancy-priorities-mode)
  :config (setq org-fancy-priorities-list
		'((?A . "HIGH")
		  (?B . "MEDIUM")
		  (?C . "LOW"))))


;; ;; (setq debug-on-error '(wrong-type-argument))
;; (setq org-src-preserve-indentation nil
;;       org-edit-src-content-indentation 0)

(require 'org-download)

;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(setq org-adapt-indentation t
      org-hide-leading-stars t
      org-odd-levels-only t)
