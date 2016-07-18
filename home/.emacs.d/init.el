(package-initialize)

(load-theme 'whiteboard t)
;; Setup standard package archive sources
(setq package-archives
      '(("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("gnu"          . "https://elpa.gnu.org/packages/")))

;; Install use-package if not available
(unless (require 'use-package nil t)
  (package-refresh-contents)
  (package-install 'use-package)
  (require 'use-package))

(use-package evil :ensure t)  
(require 'evil)
(evil-mode t)

;; I have no idea WTF is this
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ac-php auto-complete flycheck flymake-php php-mode evil use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Start emacs more like VIM
(setq initial-scratch-message "")
(setq inhibit-startup-message t)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)

;; Syntax checking on the fly (need plugins)
(use-package flycheck :ensure t)
(require 'flycheck)
(global-flycheck-mode)

(use-package auto-complete :ensure t)
(require 'auto-complete)

;; PHP packages
(use-package php-mode :ensure t)
(require 'php-mode)

(use-package flymake-php :ensure t)
(require 'flymake-php)
(add-hook 'php-mode-hook 'flymake-php-load)

(use-package ac-php :ensure t)
(add-hook 'php-mode-hook
    '(lambda ()
	(auto-complete-mode t)
	(require 'ac-php)
	(setq ac-sources  '(ac-source-php ) )
	(yas-global-mode 1)
	(define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
	(define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
	))
;; ...
