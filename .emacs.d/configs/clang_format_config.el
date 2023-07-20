;; Todd, I virtually guarantee you will forget how to do this.
;; Step 1: read through: https://github.com/kljohann/clang-format.el/issues/5
;; Step 2: evaluate your clang-format.el, and change your package code to always look in ~/.
;; You do so by changes like this:

;; ;; (unless style
;; ;;   (setq style clang-format-style))
;; (setq style "file")

;; ;; (unless assume-file-name
;; ;; (setq assume-file-name buffer-file-name))
;; (setq assume-file-name "~")

(require 'clang-format)
(load "~/.emacs.d/elpa/clang-format-20191106.950/clang-format.el")
(setq clang-format-style-option "file")
(add-hook 'before-save-hook 'delete-trailing-whitespace)
