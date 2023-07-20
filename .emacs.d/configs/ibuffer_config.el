;; imma try out this ibuffer thing for a bit.
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; setting up ibuffer for per-frame buffer lists
(require 'ibuffer)

;; https://www.emacswiki.org/emacs/IbufferMode
(setq ibuffer-saved-filter-groups '(("default"
				     ("*Internal*" (name . "\*"))
				     ("Temp Buffers" (filename . "~"))
				     ("FastTransforms" (filename . "/pvd/fast_transforms/"))
				     ("ECG" (filename . "/fluent2/domains/integrity/"))
				     ("Config Files" (filename . "/configerator/source/eau/modeling/"))
)))


(add-hook 'ibuffer-mode-hook
  (lambda ()
    (ibuffer-switch-to-saved-filter-groups "default")
    (setq ibuffer-hidden-filter-groups (list "Temp Buffers" "*Internal*"))
    (ibuffer-update nil t)
  )
)

;; nearly all of this is the default layout
; change: 50s were originally 18s
;; (size 9 -1 :right)
;; " "
;; (mode 16 16 :left :elide)
;; " "
(setq ibuffer-formats '((mark modified read-only " " (name 45 45 :left :elide)
			      "" filename-and-process)
			(mark " " (name 16 -1)
			      " " filename)))
