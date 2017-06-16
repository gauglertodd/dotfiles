(put 'suspend-frame 'disabled t)
(global-linum-mode 1)
(setq show-paren-delay 0)
(show-paren-mode 1)

(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    )
  )

(global-set-key (kbd "C-;") 'comment-or-uncomment-line-or-region)
(global-set-key [(super w)] 'count-words)
(global-set-key [(super f)] 'flyspell-mode)
(global-set-key [(super k)] 'kill-this-buffer)
(global-set-key [(super K)] 'kill-some-buffers)
(global-set-key (kbd "C-+") 'text-scale-adjust)
(global-set-key (kbd "C--") 'text-scale-adjust)
(global-set-key (kbd "C-0") 'text-scale-adjust)
(global-set-key [(super l)] 'save-all)            ; save-all, (super s) not work
(global-set-key [(super z)] 'undo)                ; undo. Press C-r to make redo
(global-set-key [(super x)] 'kill-region)         ; cut
(global-set-key [(super c)] 'copy-region-as-kill) ; copy
(global-set-key [(super v)] 'yank)                ; paste
(global-set-key (kbd "M-v") 'yank-pop)            ; paste previous

;; Navigation, press [f1] to mark a point, and then M-f1 to jump back to it
(global-set-key [f1] (lambda ()(interactive) (point-to-register 1)))
(global-set-key [(super f1)] (lambda ()(interactive) (jump-to-register 1)))
(global-set-key [f2] (lambda ()(interactive) (point-to-register 2)))
(global-set-key [(super f2)] (lambda ()(interactive) (jump-to-register 2)))

;; Shift+Arrow to move between buffers
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;;; -------------------------------------------------------------- Smooth-Scroll
(defun smooth-scroll (increment)
 ;; scroll smoothly by intercepting the mouse wheel and 
 ;; turning its signal into a signal which
 ;; moves the window one line at a time, and waits for 
 ;; a period of time between each move
  (scroll-up increment) (sit-for 0.05)
  (scroll-up increment) (sit-for 0.02)
  (scroll-up increment) (sit-for 0.02)
  (scroll-up increment) (sit-for 0.05)AAAA
  (scroll-up increment) (sit-for 0.06)
  (scroll-up increment))
(global-set-key [(mouse-5)] '(lambda () (interactive) (smooth-scroll 1)))
(global-set-key [(mouse-4)] '(lambda () (interactive) (smooth-scroll -1)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (define-key evil-normal-state-map "vv" 'split-window-horizontally)
;; (define-key evil-normal-state-map "ss" 'split-window-vertically)

;; (load "~/.emacs.d/color-theme-molokai.el")

(custom-set-faces

 '(term-color-black ((t (:foreground "#3F3F3F" :background "#2B2B2B"))))
 ;; '(term-color-red ((t (:foreground "#AC7373" :background "#8C5353"))))
 '(term-color-red ((t (:foreground "#DB3030" :background "#DB3030"))))
 '(term-color-green ((t (:foreground "#7F9F7F" :background "#9FC59F"))))
 '(term-color-yellow ((t (:foreground "#DFAF8F" :background "#9FC59F"))))
 '(term-color-blue ((t (:foreground "#7CB8BB" :background "#4C7073"))))
 '(term-color-magenta ((t (:foreground "#DC8CC3" :background "#CC9393"))))
 '(term-color-cyan ((t (:foreground "#93E0E3" :background "#8CD0D3"))))
 '(term-color-white ((t (:foreground "#DCDCCC" :background "#656555"))))
 '(term-default-fg-color ((t (:inherit term-color-white))))
 '(term-default-bg-color ((t (:inherit term-color-black))))

 )

(require 'flymake)
     (global-set-key [f3] 'flymake-display-err-menu-for-current-line)
     (global-set-key [f4] 'flymake-goto-next-error)

;; Set the number to the number of columns to use.
(setq-default fill-column 100)

;; Add Autofill mode to mode hooks.
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Show line number in the mode line.
(line-number-mode 1)

;; Show column number in the mode line.
(column-number-mode 1)

;; Don't use TABS for indentations.
(setq-default indent-tabs-mode nil)

;; Setup for Flymake code checking.
(require 'flymake)
;; (load-library "flymake-cursor")

;; Script that flymake uses to check code. This script must be
;; present in the system path.
(setq pycodechecker "pychecker")

(when (load "flymake" t)
  (defun flymake-pycodecheck-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list pycodechecker (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pycodecheck-init)))

(add-hook 'python-mode-hook 'flymake-mode)

(add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
	      (require 'yasnippet)
	      (yas-global-mode 1)

(with-eval-after-load 'yasnippet
(setq-default yas-snippet-dirs '("~/.emacs.d/snippets"))

(setq x-select-enable-clipboard t)
