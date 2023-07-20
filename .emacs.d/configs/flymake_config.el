;; Setup for Flymake code checking.
(require 'flymake)
;; (load-library "flymake-cursor")

;; By default Flymake creates a temporary copy of the file being inspected in the same directory as the original file. This is helpful if you're using relative pathnames for
;; includes, but not so helpful if you have something in your environment that's triggered by file changes in your project directory (continuous integration, webserver restarts, etc).
;; Now you can toggle between the two behaviours with the 'flymake-run-in-place' variable.
;; (setq flymake-run-in-place nil)
(setq flymake-run-in-place t)

;; I don't want no steekin' limits.
(setq flymake-max-parallel-syntax-checks nil)

;; This lets me say where my temp dir is.
(setq temporary-file-directory "~/.emacs.d/tmp/")

(setq pycodechecker "python-flake8")
;; Yes, I want my copies in the same dir as the original.
;; (setq flymake-run-in-place t)

;; Script that flymake uses to check code. This script must be
;; present in the system path.
;; (setq pycodechecker "flake8")

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

;; (add-hook 'python-mode-hook 'flymake-mode)
