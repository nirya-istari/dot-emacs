;; Emacs Package dependencies
;; cargo
;; company
;; flycheck
;; go-mode
;; irony
;; nasm-mode
;; racer
;; rust-mode
;; toml
;; web-mode
;; haskell-mode (on Arch this installed by pacman)
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

;; Set path variables.
;; Obviously I should use a list or something. But I'm shit at lisp
(setenv "PATH" (concat (getenv "PATH") ":/home/chuck/.cabal/bin"))
(setq exec-path (append exec-path '("/home/chuck/.cabal/bin")))
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

(scroll-bar-mode -1)		; Don't show the scroll bar
(menu-bar-mode -1)		; Don't show menu bar
(tool-bar-mode -1)		; Don't show tool bar

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

(setq-default c-basic-offset 4
	      indent-tabs-mode nil)

;; Set up package
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; You may now set package related things

;; ;; Irony
;; (add-hook 'c++-mode-hook  'irony-mode)
;; (add-hook 'c-mode-hook    'irony-mode)
;; (add-hook 'objc-mode-hook 'irony-mode)

;; ;; Irony stuff
;; (defun my-irony-mode-hook ()
;;   (define-key irony-mode-map [remap completion-at-point]
;;     'irony-completion-at-point-async)
;;   (define-key irony-mode-map [remap complete-symbol]
;;     'irony-completion-at-point-async))
;; (add-hook 'irony-mode-hook 'my-irony-mode-hook)
;; (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
;; (add-hook 'irony-mode-hook 'irony-eldoc)
;; (eval-after-load 'company
;;   '(add-to-list 'company-backends 'company-irony))

;; Haskell mode
(require 'haskell-mode-autoloads)

;; Haskell mode indenet needs to be defined or it doesn't work at all.
;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(eval-after-load "haskell-mode"
  '(progn
     (define-key haskell-mode-map (kbd "C-c i") 'haskell-navigate-imports)
     (define-key haskell-mode-map (kbd "C-,") 'haskell-move-nested-left)
     (define-key haskell-mode-map (kbd "C-.") 'haskell-move-nested-right)))

;; Rust things
(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'rust-mode-hook
          (lambda ()
            ; (setenv "CARGO_HOME" "~/.cargo")
            (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)))
;(add-hook 'rust-mode-hook #'flycheck-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

;; Racer
(setq racer-cmd "~/.cargo/bin/racer")
(setq racer-rust-src-path "~/opt/rust/src")
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)


;; Markdown mode
(add-to-list 'load-path "~/.emacs.d/markdown-mode")
(autoload 'markdown-mode "markdown-mode")
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Go mode
(add-to-list 'load-path "~/.emacs.d/go-mode.el/")
(require 'go-mode-autoloads)

;; AGDA
(load-file (let ((coding-system-for-read 'utf-8))
                (shell-command-to-string "agda-mode locate")))

;; React (JSX)
;; Change js to web-mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
;; Change .js files to "jsx" 
(setq web-mode-content-types-alist
  '(("jsx" . "\\.js[x]?\\'")))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("f1ee3126c1aba9f3ba35bb6f17cb2190557f2223646fd6796a1eb30a9d93e850" default)))
 '(haskell-interactive-popup-errors nil)
 '(safe-local-variable-values
   (quote
    ((eval setq comment-start "//" comment-end "")
     (eval setq comment-start "//" commend-end ""))))
 '(web-mode-enable-auto-pairing nil)
 '(web-mode-enable-auto-quoting nil)
 '(web-mode-markup-indent-offset 2))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(italic ((t (:underline t :slant normal))))
 '(region ((t (:background "deep sky blue")))))
(put 'downcase-region 'disabled nil)
