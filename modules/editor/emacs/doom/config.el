;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(load! "private" doom-user-dir t)
(load! "nix" doom-user-dir t)
(setq doom-theme 'doom-city-lights
      doom-font (font-spec :family "VictorMono NFP" :size 20 :weight 'medium)
      doom-variable-pitch-font (font-spec :family "Work Sans" :size 20 :weight 'light)
      doom-symbol-font (font-spec :family "Symbols Nerd Font Mono")
      doom-big-font (font-spec :family "VictorMono NPF" :size 24))

(setq evil-emacs-state-cursor   `("white" bar)
      evil-insert-state-cursor  `("Cyan" bar)
      evil-normal-state-cursor  `("white" box)
      evil-visual-state-cursor  `("PaleGoldenrod" box))

(custom-theme-set-faces! 'doom-city-lights
  `(mode-line-inactive :background "#00051a")
  `(mode-line-active :background "#081028")
  `(header-line :background "#081028")
  `(org-modern-tag :foreground "color-246" :background "black" :height 0.6)
  )

(if (display-graphic-p)
    (custom-theme-set-faces! 'doom-city-lights
      `(default :background "#00051a")
      )
  (custom-theme-set-faces! 'doom-city-lights
    `(default :background nil)
    )
  )

(load! "configs/init.el")

(setq shell-file-name (executable-find "bash"))
(setq display-line-numbers-type 'relative)
(setq doom-scratch-initial-major-mode 'lisp-interaction-mode)
(global-subword-mode 1)                           ; Iterate through CamelCase words
(pixel-scroll-precision-mode t)
(plist-put +popup-defaults :quit t)

(pushnew! vc-directory-exclusion-list
          "node_modules"
          "cdk.out"
          "target"
          ".direnv")

(pushnew! completion-ignored-extensions
          ".DS_Store"
          ".eln"
          ".drv"
          ".direnv/"
          ".git/")
