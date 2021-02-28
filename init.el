;; Emacs Package dependencies
;; 
;; External Dependencies
;; 
;; * Cabal (with .cabal/bin)
;; ** Agda
;; * Cargo (with .cargo/bin).
;; * A copy of rust's source tree in ~/opt/rust

;; Add extra themes to load-theme list
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

;; Disable debugging for emacs
(setq debug-on-error nil)

;; Change propts that require "Y-E-S" to just "Y"
(defun yes-or-no-p (PROMPT)
  (beep)
  (y-or-n-p PROMPT))

(setenv "PATH" (concat (getenv "PATH") ":/home/chuck/.cargo/bin"))
(setq exec-path (append exec-path '("/home/chuck/.cargo/bin")))

;; Global keybindings
(global-set-key (kbd "C-c g") 'goto-line) ; Goto a given line number

;; Global settings
(setq ring-bell-function 'ignore)	; Don't bell
(setq inhibit-startup-screen t)		; Disable startup screen
(setq display-time-day-and-date nil)	; Don't show date
(setq display-time-mode t)		; But show the time in modeline
(setq indicate-empty-lines t)		; Put little ripples to show where the file ends.

(setq transient-mark-mode t)		; Where's the selection.
(setq line-number-mode t)		; Show line and column numbers 
(setq column-number-mode t)		;
(setq linum-mode t)                     ; Show linenumber on the left

;; Don't show the scroll bar
(if (boundp 'scroll-bar-mode) (scroll-bar-mode -1))
;; Don't show menu bar
(if (boundp 'menu-bar-mode) (menu-bar-mode -1))
;; Don't show tool bar
(if (boundp 'tool-bar-mode) (tool-bar-mode -1))

;; Print the current file name
(defun show-file-name ()
  "Show the full path name in the minibuffer"
  (interactive)
  (message (buffer-file-name)))

(defun kill-file-name ()
  "Put the file name of the current buffer to the front on the kill ring"
  (interactive)
  (kill-new (buffer-file-name)))

;; C et al
(setq c-default-style "cc-mode")

(setq-default c-basic-offset 4 indent-tabs-mode nil)

;; Set up package
(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(use-package ace-window
  :ensure
  :bind (("M-o" . ace-window)))

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status))
  :config
  ;; uncomment for less flashiness
  ; (setq lsp-eldoc-hook nil)
  ; (setq lsp-enable-symbol-highlighting nil)
  ; (setq lsp-signature-auto-activate nil)

  ;; comment to disable rustfmt on save
  (setq rustic-format-on-save t)
  (add-hook 'rustic-mode-hook 'rk/rustic-mode-hook))

(defun rk/rustic-mode-hook ()
  ;; so that run C-c C-c C-r works without having to confirm
  (setq-local buffer-save-without-query t))

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  ;; what to use when checking on-save. "check" is default.
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package company
  :ensure
  :custom
  (company-idle-delay 0.5) ;; how long to wait until popup
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
        ("C-n". company-select-next)
        ("C-p". company-select-previous)
        ("M-<". company-select-first)
        ("M->". company-select-last)))

(use-package flycheck :ensure)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#3F3F3F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#DCDCCC"])
 '(column-number-mode t)
 '(custom-safe-themes
   '("bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "f1ee3126c1aba9f3ba35bb6f17cb2190557f2223646fd6796a1eb30a9d93e850" default))
 '(display-time-mode t)
 '(fci-rule-color "#383838")
 '(flyspell-default-dictionary nil)
 '(haskell-interactive-popup-errors nil)
 '(ispell-dictionary "en_GB")
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#7F9F7F" "#BFEBBF" "#93E0E3" "#94BFF3" "#DC8CC3"))
 '(package-selected-packages
   '(magit rustic yasnippet spacemacs-theme use-package dap-mode lsp-treemacs lsp-ui lsp-mode projectile projectile-codesearch projectile-git-autofetch projectile-ripgrep projectile-speedbar projectile-variable treemacs treemacs-projectile toml-mode toml nasm-mode glsl-mode))
 '(safe-local-variable-values
   '((eval setq comment-start "//" comment-end "")
     (eval setq comment-start "//" commend-end "")))
 '(tool-bar-mode nil)
 '(vc-annotate-background "#2B2B2B")
 '(vc-annotate-color-map
   '((20 . "#BC8383")
     (40 . "#CC9393")
     (60 . "#DFAF8F")
     (80 . "#D0BF8F")
     (100 . "#E0CF9F")
     (120 . "#F0DFAF")
     (140 . "#5F7F5F")
     (160 . "#7F9F7F")
     (180 . "#8FB28F")
     (200 . "#9FC59F")
     (220 . "#AFD8AF")
     (240 . "#BFEBBF")
     (260 . "#93E0E3")
     (280 . "#6CA0A3")
     (300 . "#7CB8BB")
     (320 . "#8CD0D3")
     (340 . "#94BFF3")
     (360 . "#DC8CC3")))
 '(vc-annotate-very-old-color "#DC8CC3")
 '(warning-suppress-log-types '((use-package)))
 '(web-mode-enable-auto-pairing nil)
 '(web-mode-enable-auto-quoting nil)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Cascadia Code" :foundry "SAJA" :slant normal :weight light :height 120 :width normal))))
 '(italic ((t (:underline t :slant normal))))
 '(region ((t (:background "deep sky blue")))))
(put 'downcase-region 'disabled nil)
