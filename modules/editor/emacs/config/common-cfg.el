;;; common-cfg.el --- Common Config -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(use-package multiple-cursors
  :after (evil)
  :evil-bind ((:map (leader-map)
		    ("nn" . mc/mark-next-like-this)
		    ("np" . mc/mark-previous-like-this)
		    ("na" . mc/mark-all-like-this))))

(use-package aggressive-indent
  :hook ((emacs-lisp-mode . aggressive-indent-mode)
         (cc-ts-mode . aggressive-indent-mode)))

(provide 'common-cfg)
;;; common-cfg.el ends here
