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

;; Move the annoying custom snippets out to custom.el
(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

;; Display settings
(load-theme 'gruvbox-dark-medium t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 10)
(global-display-line-numbers-mode t)

(setq inhibit-startup-message t)

(setq scroll-step 1
      scroll-conservatively 1000) ; scroll-conservatively > 100 will make it scroll only enough to keep the cursor on screen

(set-frame-font "Droid Sans Mono 9" nil t)

;; Add recently edited files minor-mode
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(setq recentf-max-saved-items 25)
;;(keymap-global-set "C-x C-r" 'recentf-open-files)

;; evil-mode configuration
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

;; Neotree configuration
(use-package neotree)
(setq neo-theme (if (display-graphic-p) 'nerd 'arrow))

;; ivy configuration
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

(use-package company)
;;(keymap-global-set "C-SPC" 'company-complete)
(add-hook 'after-init-hook 'global-company-mode)

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
  (setq which-key-idle-delay 1)) ;; delay before showing key guide 

;; "helpful" configuration
(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap descripe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;; LSP / Progrmaming utility configuration section
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook (
	 ;;; (XXX-mode. lsp)
	 (python-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

;; ORG CONFIGURATION

(setq org-agenda-files '("~/org"))
(setq org-log-done 'time)
(setq org-return-follows-link t)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'org-indent-mode)

;;(define-key global-map "\C-cl" 'org-store-link)
;;(define-key global-map "\C-ca" 'org-agenda)
;;(define-key global-map "\C-cc" 'org-capture)
;;
;;(define-key global-map "\C-cp" 'org-latex-preview)

(setq org-hide-emphasis-markers t)
(add-hook 'org-mode-hook 'visual-line-mode)

(setq org-capture-templates
      '(
	("j" "Work log entry"
	 entry (file+datetree "~/org/work-log.org")
	 "* %?"
	 :empty-lines 0)
	("t" "General To-Do"
	 entry (file+headline "~/org/todos.org" "General Tasks")
	 "* TODO [#B] %?\n:Created: %T\n "
	 :empty-lines 0)
	("m" "Meeting"
	 entry (file+datetree "~/org/meetings.org")
	 "* %? :meeting:%^g \n:Created: %T\n** Attendees\n*** \n** Action Items\n*** TODO [#A] "
	 :tree-type week
	 :empty-lines 0)
	))

(setq org-todo-keywords
      '((sequence
	 "TODO(t)"
	 "DOING(d)"
	 "BLOCKED(b@)"
	 "|"
	 "COMPLETE(c!)"
	))
      )

(setq org-todo-keyword-faces
      '(
	("TODO" . (:foreground "GoldenRod" :weight bold))
	("DOING" . (:foreground "DeepPink" :weight bold))
	("BLOCKED" . (:foreground "Red" :weight bold))
	("COMPLETE" . (:foreground "LimeGreen" :weight bold))
	))

;; ORG-ROAM
(setq org-roam-directory (file-truename "~/org/roam"))
(org-roam-db-autosync-mode)
(setq org-format-latex-options
      '(:foreground default :background default :scale 1.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers ("begin" "$1" "$" "$$" "\\(" "\\[" )))

;; Convenience keybinds
;;(keymap-global-set "C-c P" (lambda () (interactive) (switch-to-buffer (find-file "~/.config/emacs/init.el")))) ; Open config on C-c P

(load "~/.config/emacs/keys.el")
