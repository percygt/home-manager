;;; general-cfg.el ---  General.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package general
  :demand t
  :preface
  (defun switch-to-recent-buffer ()
    (interactive)
    (switch-to-buffer (other-buffer (current-buffer))))
  :config
  (general-override-mode)
  (general-auto-unbind-keys)
  (general-create-definer global-definer
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")
  (general-create-definer local-definer
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator emacs)
    :prefix ","
    :global-prefix "C-,")
  (general-create-definer normal-definer
    :keymaps 'override
    :states '(normal))
  (global-definer
    "!" 'shell-command
    ":" 'eval-expression
    "." 'repeat
    "f" 'find-file
    "l" 'load-file
    "d" 'dired
    "p" 'switch-to-recent-buffer)

  (general-create-definer global-leader
    :keymaps 'override
    :states '(insert normal hybrid motion visual operator)
    :prefix "SPC m"
    :non-normal-prefix "C-SPC m"
    "" '( :ignore t
  	      :which-key
  	      (lambda (arg)
  	        (cons (cadr (split-string (car arg) " "))
  		          (replace-regexp-in-string "-mode$" "" (symbol-name major-mode))))))
  )

(provide 'general-cfg)
;;; general-cfg.el ends here
