;; 初始化设置
(setq command-line-default-directory "~/")

(set-terminal-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)
(setq default-process-coding-system '(utf-8 . utf-8))

(prefer-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(set-face-attribute 'default nil :family "Consolas" :height 110)
;; Setting Chinese Font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
            charset
            (font-spec :family "Microsoft Yahei" :height 110)))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(global-set-key (kbd "C-q") 'other-frame)

;;(setq visible-bell 0)
(setq ring-bell-function 'ignore)

(xterm-mouse-mode 1)
;; 终端下的鼠标滚轮支持
(global-set-key [mouse-4] 'scroll-down-line)
(global-set-key [mouse-5] 'scroll-up-line)

(require 'display-line-numbers)
(defcustom display-line-numbers-exempt-modes
  '(vterm-mode eshell-mode shell-mode term-mode ansi-term-mode gud-mode neotree-mode)
  "Major modes on which to disable line numbers."
  :group 'display-line-numbers
  :type 'list
  :version "green")
(defun display-line-numbers--turn-on ()
  "Turn on line numbers except for certain major modes.
Exempt major modes are defined in `display-line-numbers-exempt-modes'."
  (unless (or (minibufferp)
              (member major-mode display-line-numbers-exempt-modes))
    (display-line-numbers-mode)))
(global-display-line-numbers-mode)

;;(setq display-line-numbers-type 'relative)
;;(global-display-line-numbers-mode t)

(setq compilation-scroll-output t)

(defun eshell-new()
  "Open a new instance of eshell."
  (interactive)
  (eshell 'N))

(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)))

(setq scroll-step 1)
(setq scroll-conservatively 10000)
(setq auto-window-vscroll nil)
(setq mouse-wheel-scroll-amount '(3))
(setq mouse-wheel-progressive-speed nil)
;;(setq scroll-margin 5)

;; 将默认shell改为cmd
;;(setq shell-file-name "cmd")

(setq
 backup-by-copying t ; 自动备份
 backup-directory-alist
 '(("." . "~/.emacs.d/backup")) ; 自动备份在目录"~/.emacs.d/backup"下
 delete-old-versions t ; 自动删除旧的备份文件
 kept-new-versions 3 ; 保留最近的3个备份文件
 kept-old-versions 1 ; 保留最早的1个备份文件
 version-control t) ; 多次备份

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default standard-indent 4)
;;linux kernel style
;;(defun c-lineup-arglist-tabs-only (ignored)
;;  "Line up argument lists by tabs, not spaces"
;;  (let* ((anchor (c-langelem-pos c-syntactic-element))
;;         (column (c-langelem-2nd-pos c-syntactic-element))
;;         (offset (- (1+ column) anchor))
;;         (steps (floor offset c-basic-offset)))
;;    (* (max steps 1)
;;       c-basic-offset)))
;;
;;(add-hook 'c-mode-common-hook
;;          (lambda ()
;;            ;; Add kernel style
;;            (c-add-style
;;             "linux-tabs-only"
;;             '("linux" (c-offsets-alist
;;                        (arglist-cont-nonempty
;;                         c-lineup-gcc-asm-reg
;;                         c-lineup-arglist-tabs-only))))))
;;
;;(add-hook 'c-mode-hook
;;          (lambda ()
;;            (let ((filename (buffer-file-name)))
;;              ;; Enable kernel mode for the appropriate files
;;              (when (and filename
;;                         (string-match (expand-file-name "~/src/linux-trees")
;;                                       filename))
;;                (setq indent-tabs-mode t)
;;                (setq show-trailing-whitespace t)
;;                (c-set-style "linux-tabs-only")))))

(with-eval-after-load 'org
  (add-to-list 'org-export-backends 'md))

(server-start)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 包管理器设置
(setq package-archives '(("gnu"   . "https://elpa.gnu.org/packages/")
                           ("melpa" . "https://melpa.org/packages/")))

(setq package-check-signature nil) ;个别时候会出现签名校验失败

(require 'package)

;; 初始化包管理器
(unless (bound-and-true-p package--initialized)
  (package-initialize))

;; 刷新软件源索引
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-and-compile
  (setq use-package-always-ensure t) ;不用每个包都手动添加:ensure t关键字
  (setq use-package-always-defer t) ;默认都是延迟加载，不用每个包都手动添加:defer t
  (setq use-package-always-demand nil)
  (setq use-package-expand-minimally t)
  (setq use-package-verbose t))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 加载插件
(require 'use-package)

(use-package evil
  :init
  (evil-mode 1)
  ;;修正:q :wq :x的行为
  ;;(global-set-key [remap evil-quit] 'kill-buffer-and-window)
  (defun save-and-kill-buffer ()
    (interactive)
    (save-buffer)
    (kill-buffer-and-window))
  (global-set-key [remap evil-save-and-close] 'save-and-kill-buffer)
  ;;(global-set-key [remap evil-save-modified-and-close] 'save-and-kill-buffer)
  )

(use-package zenburn-theme
  :init
  (setq zenburn-override-colors-alist
      '(("zenburn-bg" . "#2B2B2B")
  	("zenburn-bg-1" . "#3F3F3F")))
  (load-theme 'zenburn t))

;;(use-package spaceline
;;  :init
;;  ;;(setq powerline-default-separator 'arrow)
;;  (spaceline-spacemacs-theme))

(use-package undo-tree
  :init
  (global-undo-tree-mode)
  (evil-set-undo-system 'undo-tree)
  (setq evil-want-fine-undo t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo-tree-history")))
  (make-directory "~/.emacs.d/undo-tree-history" t))

(use-package neotree
  :init
  (global-set-key [f5] 'neotree-toggle)
  (global-set-key [f8] 'neotree-refresh))

;;(use-package treemacs
;;  :bind
;;  (:map global-map
;;        ([f5]   . treemacs)
;;        ([f8]   . treemacs-select-directory)))

(use-package pyim
  :init
  (setq default-input-method "pyim")
  (global-set-key (kbd "C-\\") 'toggle-input-method))

(use-package winner
  :ensure nil
  ;;:after evil
  :init
  (winner-mode 1)
  :bind (:map evil-window-map
	      ("u" . winner-undo)
	      ("U" . winner-redo))
  :config
  (winner-mode))

(use-package projectile
  :init
  (projectile-global-mode 1)
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t))

(use-package helm-projectile
  :init
  (helm-projectile-on)
  (define-key helm-map (kbd "TAB") 'helm-next-line)
  (define-key helm-map (kbd "<backtab>") 'helm-previous-line)
  (define-key helm-map (kbd "<escape>") 'helm-keyboard-quit)
  (global-set-key (kbd "C-c C-f") 'helm-projectile-find-file))

;;(use-package cuda-mode)
;;(use-package glsl-mode)

;;(use-package vterm
;;  :init
;;  (evil-define-key 'normal vterm-mode-map (kbd "C-q") 'other-frame)
;;  (evil-define-key 'normal vterm-mode-map "h" 'vterm-send-left)
;;  (evil-define-key 'normal vterm-mode-map "l" 'vterm-send-right)
;;  (evil-define-key 'normal vterm-mode-map "b" 'vterm-send-M-b)
;;  (evil-define-key 'normal vterm-mode-map "e" 'vterm-send-M-f)
;;  (evil-define-key 'normal vterm-mode-map "db" 'vterm-send-C-w)
;;  (evil-define-key 'normal vterm-mode-map "de" 'vterm-send-M-d)
;;  (evil-define-key 'normal vterm-mode-map "p" 'vterm-yank)
;;  (evil-define-key 'normal vterm-mode-map "P" '(lambda ()
;;						 (interactive)
;;						 (vterm-send-C-b)
;;						 (vterm-yank))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; lsp-mode
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp lsp-deferred)

;; optionally
;;(use-package lsp-ui :commands lsp-ui-mode)
;; if you are helm user
(use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;;(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;;(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
(use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (which-key-mode))

(use-package yasnippet
  :init
  (yas-global-mode))

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 1
	company-idle-delay 0.0) ;; default is 0.2
  (with-eval-after-load 'company
    (define-key company-active-map [tab] 'company-select-next)
    (define-key company-active-map [backtab] 'company-select-previous))
  ;; shell和eshell中禁止补全
  (defun my-shell-mode-setup-function () 
    (when (fboundp 'company-mode))
    (company-mode -1))
  (add-hook 'shell-mode-hook 'my-shell-mode-setup-function)
  (add-hook 'eshell-mode-hook 'my-shell-mode-setup-function)
  (add-hook 'gud-mode-hook 'my-shell-mode-setup-function))

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      ;;company-idle-delay 0.0
      ;;company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
