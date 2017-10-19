;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
;; (global-set-key (kbd "M-v") 'yank-pop)            ; paste previous

;; Navigation, press [f1] to mark a point, and then M-f1 to jump back to it
(global-set-key [f1] (lambda ()(interactive) (point-to-register 1)))
(global-set-key [(super f1)] (lambda ()(interactive) (jump-to-register 1)))
(global-set-key [f2] (lambda ()(interactive) (point-to-register 2)))
(global-set-key [(super f2)] (lambda ()(interactive) (jump-to-register 2)))

;; Shift+Arrow to move between buffers
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; --------------------------------------------;; ------------------ Smooth-Scroll
(defun smooth-scroll (increment)
 ;; scroll smoothly by intercepting the mouse wheel and
 ;; turning its signal into a signal which
 ;; moves the window one line at a time, and waits for
 ;; a period of time between each move
  (scroll-up increment) (sit-for 0.05)
  (scroll-up increment) (sit-for 0.02)
  (scroll-up increment) (sit-for 0.02)
  (scroll-up increment) (sit-for 0.05)
  (scroll-up increment) (sit-for 0.06)
  (scroll-up increment))
(global-set-key [(mouse-5)] '(lambda () (interactive) (smooth-scroll 1)))
(global-set-key [(mouse-4)] '(lambda () (interactive) (smooth-scroll -1)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages
   (quote
    (magit format-sql js-auto-beautify js-format projectile jedi package-lint yasnippet yapfify py-yapf)))
 '(show-paren-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(term-color-black ((t (:foreground "#3F3F3F" :background "#2B2B2B"))))
 '(term-color-blue ((t (:foreground "#7CB8BB" :background "#4C7073"))))
 '(term-color-cyan ((t (:foreground "#93E0E3" :background "#8CD0D3"))))
 '(term-color-green ((t (:foreground "#7F9F7F" :background "#9FC59F"))))
 '(term-color-magenta ((t (:foreground "#DC8CC3" :background "#CC9393"))))
 '(term-color-red ((t (:foreground "#DB3030" :background "#DB3030"))))
 '(term-color-white ((t (:foreground "#DCDCCC" :background "#656555"))))
 '(term-color-yellow ((t (:foreground "#DFAF8F" :background "#9FC59F"))))
 '(term-default-bg-color ((t (:inherit term-color-black))))
 '(term-default-fg-color ((t (:inherit term-color-white)))))


;; https://stackoverflow.com/questions/1231188/emacs-list-buffers-behavior
(global-set-key (kbd "C-x C-b") 'my-list-buffers)
(defun my-list-buffers (&optional files-only)
 "Display a list of names of existing buffers.
The list is displayed in a buffer named `*Buffer List*'.
Note that buffers with names starting with spaces are omitted.
Non-null optional arg FILES-ONLY means mention only file buffers.
For more information, see the function `buffer-menu'."
  (interactive "P")
  (switch-to-buffer (list-buffers-noselect files-only)))


;; (define-key evil-normal-state-map "vv" 'split-window-horizontally)
;; (define-key evil-normal-state-map "ss" 'split-window-vertically)

;; theme realted info
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
;; (load "~/.emacs.d/color-theme-molokai.
(load-theme 'zenburn t)


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

(with-eval-after-load 'yasnippet)
(setq-default yas-snippet-dirs '("~/.emacs.d/snippets"))

(setq x-select-enable-clipboard t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;(key-chord-define-global "JJ" 'switch-to-previous-buffer)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))


; an alternative way to adding melpa packages, from
; https://magit.vc/manual/magit/Installing-from-an-Elpa-Archive.html#Installing-from-an-Elpa-Archive
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'load-path "/home/todd/.emacs.d/elpa")

(defvar jedi:goto-stack '())
(defun jedi:jump-to-definition ()
  (interactive)
  (add-to-list 'jedi:goto-stack
               (list (buffer-name) (point)))
  (jedi:goto-definition))
(defun jedi:jump-back ()
  (interactive)
  (let ((p (pop jedi:goto-stack)))
    (if p (progn
            (switch-to-buffer (nth 0 p))
            (goto-char (nth 1 p))))))

(add-hook 'python-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-.") 'jedi:jump-to-definition)
             (local-set-key (kbd "C-,") 'jedi:jump-back)
             (local-set-key (kbd "C-c d") 'jedi:show-doc)
             (local-set-key (kbd "C-<tab>") 'jedi:complete)))

(add-hook 'python-mode-hook 'jedi:setup)
;;enable jedi autocompletion in python
(add-hook 'python-mode-hook 'auto-complete-mode)
(add-hook 'python-mode-hook 'jedi:ac-setup)

(global-set-key (kbd "C-d") 'kill-whole-line)
(global-set-key (kbd "C-:") 'goto-line)
(global-set-key (kbd "M-C-f") 'find-file)
(global-set-key (kbd "<f8>") (lambda() (interactive)(find-file "~/Desktop/projects")))
(global-set-key (kbd "C-<") 'split-window-horizontally)
(global-set-key (kbd "C->") 'split-window-vertically)
(global-set-key (kbd "<f5>") 'yapfify-buffer)
(global-set-key (kbd "<f1>") 'new-frame)


;; adding some project-level searching.
(global-set-key (kbd "C-S-F") 'projectile-grep)

;; adding quick frame navigation
(defun prev-window ()
   (interactive)
   (other-frame -1))

(define-key global-map (kbd "C-x p") 'prev-window)
(global-set-key [M-right] 'other-frame )
(global-set-key [M-left] 'prev-window)

;; sometimes flycheck has path issues, not sure if this actually helps.
(setq-default flycheck-emacs-lisp-load-path 'inherit)

;; disable the menu/toolbar.
(menu-bar-mode -1)
(tool-bar-mode -1)

; allowing for projectile globally.
(projectile-global-mode)
(require 'cl-lib)

;; global auto-revert mode.
(global-auto-revert-mode 1)

;; for web formatting
(require 'web-beautify) ;; Not necessary if using ELPA package
(eval-after-load 'js2-mode
  '(define-key js2-mode-map (kbd "<f5>") 'web-beautify-js))
;; Or if you're using 'js-mode' (a.k.a 'javascript-mode')
(eval-after-load 'js
  '(define-key js-mode-map (kbd "<f5>") 'web-beautify-js))

(eval-after-load 'json-mode
  '(define-key json-mode-map (kbd "<f5>") 'web-beautify-js))

(eval-after-load 'sgml-mode
  '(define-key html-mode-map (kbd "<f5>") 'web-beautify-html))

(eval-after-load 'web-mode
  '(define-key web-mode-map (kbd "<f5>") 'web-beautify-html))

(eval-after-load 'css-mode
  '(define-key css-mode-map (kbd "<f5>") 'web-beautify-css))

(defun point-in-comment ()
  (let ((syn (syntax-ppss)))
    (and (nth 8 syn)
         (not (nth 3 syn)))))

(defun capitalize-all-mysql-keywords ()
  (interactive)
  (require 'sql)
  (save-excursion
    (dolist (keywords sql-mode-mysql-font-lock-keywords)
      (goto-char (point-min))
      (while (re-search-forward (car keywords) nil t)
        (unless (point-in-comment)
          (goto-char (match-beginning 0))
          (upcase-word 1))))))
