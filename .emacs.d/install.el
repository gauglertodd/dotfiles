;; run with emacs --script install.el
(require 'package)

; find package information from following archives
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

(package-initialize)

(mapcar (lambda (package)
          ; install package if not already installed
          (unless (package-installed-p package)
            (package-install package)))
        ; list of packages to be installed
        '(yasnippet
          async
          auctex
          auto-complete
          concurrent
          ctable
          dash
          epc
          epl
          format-sql
          git-commit
          jedi
          jedi-core
          js-auto-beautify
          js2-mode
          latex-preview-pane
          magit
          magit-popup
          pkg-info
          popup
          projectile
          py-yapf
          python-environment
          web-beautify
          web-mode
          with-editor
          yapfify
          color-theme))
