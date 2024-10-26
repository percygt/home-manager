;;; +org.el -*- lexical-binding: t; -*-
(require 'org)

(setq org-directory orgDirectory
      org-archive-location (file-name-concat org-directory ".archive/%s::"))

(defun org-capture-inbox ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "i"))

(defun org-capture-mail ()
  (interactive)
  (call-interactively 'org-store-link)
  (org-capture nil "@"))

(map! :after org
      :leader
      :prefix ("o" . "Org")
      "c" #'org-capture
      "i" #'org-capture-inbox
      "@" #'org-capture-mail
      )

;; (use-package! mixed-pitch
;;   :hook
;;   (org-mode . mixed-pitch-mode))

(use-package! org-appear
  :hook
  (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t)
  (setq org-appear-autosubmarkers t)
  (setq org-appear-autolinks t))

(use-package! visual-fill-column
  :config
  (setq visual-fill-column-center-text t)
  (setq visual-fill-column-width 100)
  (setq visual-fill-column-center-text t))

(use-package! writeroom-mode
  :config
  (setq writeroom-maximize-window nil
        writeroom-mode-line nil
        writeroom-global-effects nil ;; No need to have Writeroom do any of that silly stuff
        writeroom-extra-line-spacing 3)
  (setq writeroom-width visual-fill-column-width))

(defun p67/org-mode-setup ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t
        display-fill-column-indicator nil
        display-line-numbers nil)
  (writeroom-mode t)
  (visual-line-mode +1)
  (auto-fill-mode 0)
  (variable-pitch-mode))

(defun p67/log-todo-next-creation-date (&rest ignore)
  "Log NEXT creation time in the property drawer under the key 'ACTIVATED'"
  (when (and (string= (org-get-todo-state) "NEXT")
             (not (org-entry-get nil "ACTIVATED")))
    (org-entry-put nil "ACTIVATED" (format-time-string "[%Y-%m-%d]"))))


(add-hook 'org-after-todo-state-change-hook #'p67/log-todo-next-creation-date)

(defun my/log-todo-creation-date (&rest ignore)
  "Log TODO creation time in the property drawer under the key 'CREATED'."
  (when (and (org-get-todo-state)
             (not (org-entry-get nil "CREATED")))
    (org-entry-put nil "CREATED" (format-time-string (cdr org-time-stamp-formats)))))

(advice-add 'org-insert-todo-heading :after #'my/log-todo-creation-date)
(advice-add 'org-insert-todo-heading-respect-content :after #'my/log-todo-creation-date)
(advice-add 'org-insert-todo-subheading :after #'my/log-todo-creation-date)

(add-hook 'org-capture-before-finalize-hook #'my/log-todo-creation-date)

;; Refile
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(setq org-refile-targets
      '(("projects.org" :regexp . "\\(?:\\(?:Note\\|Task\\)s\\)")))

(add-hook 'org-mode-hook #'p67/org-mode-setup)

(custom-set-faces!
  '(org-document-title :height 1.5)
  '(org-level-1 :inherit (variable-pitch outline-1) :weight extra-bold :height 1.5)
  '(org-level-2 :inherit (variable-pitch outline-2) :weight bold :height 1.3)
  '(org-level-3 :inherit (variable-pitch outline-3) :weight bold :height 1.2)
  '(org-level-4 :inherit (variable-pitch outline-4) :weight bold :height 1.1)
  '(org-level-5 :inherit (variable-pitch outline-5) :weight semi-bold :height 1.1)
  '(org-level-6 :inherit (variable-pitch outline-6) :weight semi-bold :height 1.05)
  '(org-level-7 :inherit (variable-pitch outline-7) :weight semi-bold)
  '(org-level-8 :inherit (variable-pitch outline-8) :weight semi-bold)
  '(org-block-begin-line :inherit fixed-pitch :height 0.8 :slant italic :background "unspecified")
  ;; Ensure that anything that should be fixed-pitch in org buffers appears that
  ;; way
  '(org-block :inherit fixed-pitch)
  '(org-code :inherit (shadow fixed-pitch))
  )


(add-hook! 'org-after-todo-statistics-hook
  (fn! (let (org-log-done) ; turn off logging
         (org-todo (if (zerop %2) "DONE" "TODO")))))

;;; Visual settings
(setq org-link-frame-setup '((file . find-file)));; Opens links to other org file in same frame (rather than splitting)
(setq org-startup-folded 'show2levels)
(setq org-list-indent-offset 1)
(setq org-cycle-separator-lines 1)
(setq org-indent-indentation-per-level 2)
(setq org-ellipsis " ")
(setq org-hide-emphasis-markers t)
(setq org-indent-mode-turns-on-hiding-stars t)
(setq org-pretty-entities t)
(setq org-startup-indented t)
(setq org-startup-shrink-all-tables t)
(setq org-startup-with-inline-images t)
(setq org-startup-with-latex-preview nil)
;;; TODOs, checkboxes, stats, properties.
(setq org-hierarchical-todo-statistics nil)
(setq org-use-property-inheritance t)
(setq org-enforce-todo-dependencies t)

  ;;; Interactive behaviour

(setq org-bookmark-names-plist nil)
(setq org-M-RET-may-split-line nil)
;; (setq org-adapt-indentation nil)
(setq org-blank-before-new-entry '((heading . t) (plain-list-item . auto)))
(setq org-fold-catch-invisible-edits 'smart)
(setq org-footnote-auto-adjust t)
(setq org-insert-heading-respect-content t)
;; (setq org-loop-over-headlines-in-active-region 'start-level)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

(setq org-todo-keywords
      '(
        (sequence
         "TODO(t)" ; doing later
         "NEXT(n)" ; doing now or soon
         "|"
         "DONE(d)" ; done
         )
        (sequence
         "WAIT(w@/!)" ; waiting for some external change (event)
         "HOLD(h@/!)" ; waiting for some internal change (of mind)
         "|"
         "KILL(C@/!)"
         )
        (type
         "IDEA(i)" ; maybe someday
         "NOTE(N)"
         "STUDY(s)"
         "READ(r)"
         "WORK(w)"
         "PROJECT(p)"
         "PEOPLE(h)"
         "|"
         )
        )
      )
