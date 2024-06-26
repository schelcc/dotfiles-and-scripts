;; Move the annoying custom snippets out to custom.el
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)
;; Package management
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Make backup files write to ~/.saves/
(setq backup-directory-alist `(("~/.saves")))
(setq backup-by-copying t)
(setq auto-save-file-name-transforms `((".*" "~/.saves/" t)))

;; Add recently edited files minor-mode
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
;;(keymap-global-set "C-x C-r" 'recentf-open-files)

;; Use .bashrc for envvars (necessary for anything node/npm)
(when (daemonp)
  (exec-path-from-shell-initialize))

(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq inhibit-startup-message t)
(setq initial-scratch-message "") ;; Make scratch buffer blank

(setq scroll-step 1
      scroll-conservatively 1000) ; scroll-conservatively > 100 will make it scroll only enough to keep the cursor on screen

;; Highlight currently horizontal line
(global-hl-line-mode)

;; Display settings
(load-theme 'gruvbox-dark-medium t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 0)
(global-display-line-numbers-mode t)

(add-to-list 'default-frame-alist '(font . "Droid Sans Mono 9"))

;; Neotree configuration
(use-package neotree
  :config
  (setq neo-theme (if (display-graphic-p) 'nerd 'arrow)))

(use-package mood-line
  :config
  (mood-line-mode)

  :custom
  (mood-line-glyph-alist mood-line-glyphs-ascii)
  (setq mood-line-format mood-line-format-default-extended))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package windresize)

(use-package docker-compose-mode)
(use-package dockerfile-mode)
(use-package mermaid-mode)
(use-package spice-mode)
(use-package python-mode)

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line))
  :config
  (ivy-mode 1))

(use-package ivy-rich
  :after ivy
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :config
  (counsel-mode 1))

(use-package company
  :config
  (setq company-idle-delay 0)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-limit 4)
  (setq company-dabbrev-minimum-length 4)
  (setq company-dabbrev-other-buffers t)
  
  (setq company-backends '((company-capf company-dabbrev company-ispell)))
  (setq company-transformers '(company-sort-by-occurrence company-sort-by-backend-importance))
  (global-company-mode))

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (ivy-prescient-mode 1))

;; Which-key configuration
(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0)) ;; delay before showing key guide 

;; LSP / Progrmaming utility configuration section
(use-package flycheck)

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-update-mode "line")
  (setq lsp-ui-sideline-delay 0))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  ;;(setq lsp-signature-render-documentation nil)
  :hook (
	 ;;; (XXX-mode. lsp)
	 (python-mode . lsp)
	 (sh-mode . lsp) ; Requires shellcheck, shfmt
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :config
  (setq lsp-pylsp-plugins-jedi-completion-enabled t)
  (setq lsp-pylsp-plugins-jedi-completion-fuzzy t)
  (setq lsp-pylsp-plugins-jedi-environment "/usr/bin/python3")
  (setq lsp-inlay-hint-enable t))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package elfeed
  :config
  (setq elfeed-feeds
	'(("https://ludic.mataroa.blog/rss/" blog)))

  (defface important-elfeed-entry
    '((t :forefround "#f77"))
    "Import Elfeed entries.")
  (push '(important important-elfeed-entry)
	elfeed-search-face-alist)

  (add-hook 'elfeed-new-entry-hook
	    (elfeed-make-tagger :before "1 month ago" :remove 'unread)))

;; Org
(load "~/.config/emacs/org.el")

;; Keys
(load "~/.config/emacs/keys.el")
