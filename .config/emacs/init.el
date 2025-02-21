(setq custom-file "~/.config/emacs/custom.el")
(load custom-file)

(require `package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org"   . "https://orgmode.org/elpa/")
			 ("elpa"  . "https://elpa.gnu.org/packages")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(when (daemonp)
  (exec-path-from-shell-initialize))

(recentf-mode 1)
(setq recentf-max-menu-items 10
      recentf-max-saved-items 10)

(setq backup-directory-alist `(("~/.saves"))
      backup-by-copying t)

(setq auto-save-file-name-transforms `((".*" "~/.saves/" t)))

(setq inhibit-startup-message t
      initial-scratch-message "")

(global-hl-line-mode)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(set-fringe-mode 0)
(setq scroll-conservatively most-positive-fixnum)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setq global-fixed-pitch-font "Inconsolata Nerd Font Mono")
(setq global-variable-pitch-font "Liberation Sans")

(when (member global-fixed-pitch-font (font-family-list))
  (set-face-attribute 'default nil :font global-fixed-pitch-font :width 'normal :height 100)
  (set-face-attribute 'fixed-pitch nil :family "Droid Sans Mono"))

(when (member global-variable-pitch-font (font-family-list))
  (set-face-attribute 'variable-pitch nil :family global-variable-pitch-font :height 0.9))

(load-theme 'gruvbox-dark-medium t)

(defun reload-config ()
  (interactive)
  (load "~/.config/emacs/init.el"))

(defvar-keymap file-io-map
  :doc "Keybind map for basic file IO tasks"
  "r" #'recentf-open-files
  "f" #'find-file
  "d" #'dired)

(defvar-keymap buffer-menu-map
  :doc "Keybind map for buffer tasks"
  "s" #'scratch-buffer
  "m" #'buffer-menu
  "K" #'kill-buffer)

(defvar-keymap org-download-map
  :doc "Keybind for org-download tools")

(defvar-keymap org-io-map
  :doc "Keybind map for org stuff"
  "a" 'org-agenda
  "p" 'org-latex-preview
  "d" `("Org-download options" . ,org-download-map))

(defvar-keymap global-prefix-map
  :doc "Global custom prefix map"
  "o" `("Org IO Keybinds" . ,org-io-map)
  "f" `("File IO Keybinds" . ,file-io-map)
  "b" `("Buffer & Options" . ,buffer-menu-map)
  "r" 'reload-config)

(keymap-set global-map "C-SPC" global-prefix-map)

(use-package neotree
  :bind (:map global-prefix-map
	      ("t" . 'neotree-toggle))
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

(use-package ivy-prescient
  :after counsel
  :custom
  (ivy-prescient-enable-filtering nil)
  :config
  (ivy-prescient-mode 1))

(use-package counsel
  :config
  (counsel-mode 1))

(use-package company
  :config
  (setq company-idle-delay 0)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-limit 8)
  (setq company-dabbrev-minimum-length 4)
  (setq company-dabbrev-other-buffers t)
  
  (setq company-backends '((company-capf company-dabbrev company-ispell)))
  (setq company-transformers '(company-sort-by-occurrence company-sort-by-backend-importance))
  (global-company-mode))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0)) ;; delay before showing key guide

(use-package elfeed
  :config
  (setq elfeed-search-title-max-width 120)
  (setq elfeed-feeds
	'(("https://ludic.mataroa.blog/rss/" blog) 
	  ("https://racer.com/indycar/feed/" racing)))

  (defface important-elfeed-entry
    '((t :forefround "#f77"))
    "Import Elfeed entries.")
  (push '(important important-elfeed-entry)
	elfeed-search-face-alist)

  (add-hook 'elfeed-new-entry-hook
	    (elfeed-make-tagger :before "1 month ago" :remove 'unread)))

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  ;;(setq lsp-signature-render-documentation nil)
  :hook (
	 ;;; (XXX-mode. lsp)
	 (python-mode . lsp)
	 ;; (sh-mode . lsp) ; Requires shellcheck, shfmt ;; Something wrong, freezes client
	 (rust-mode . lsp)
	 (c-mode . lsp)
	 (c++-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration)
	 (lsp-mode . lsp-ui-mode))
  :commands lsp
  :config
  ;;(setq lsp-clangd-
  ;;(setq lsp-clients-clangd-args "-std=c++20")
  (setq lsp-pylsp-plugins-jedi-completion-enabled t)
  (setq lsp-pylsp-plugins-jedi-completion-fuzzy t)
  (setq lsp-pylsp-plugins-jedi-environment "/usr/bin/python3")
  (setq lsp-eldoc-render-all nil)
  (setq lsp-inlay-hint-enable nil)
  (setq lsp-eldoc-enable-hover t)
  (setq lsp-signature-doc-lines 5)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-signature-auto-activate nil))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (lsp-ui-peek-enable t)
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-show-with-cursor t)
  (setq lsp-ui-doc-side 'left)
  (setq lsp-ui-doc-delay 1)
  (setq lsp-ui-doc-position 'at-point))

(use-package lsp-ivy
  :commands lsp-ivy-workspace-symbol)

(use-package docker-compose-mode)
(use-package dockerfile-mode)
(use-package mermaid-mode)
(use-package spice-mode)
(use-package python-mode)
(use-package rust-mode)
(use-package flycheck-rust)
(use-package json-mode)
(use-package flycheck)

(use-package rustic
  :ensure
  :config
  (setq rustic-format-on-save t))

(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

(use-package org-roam
  :bind (:map org-io-map
	      ("c" . 'org-roam-capture)
	      ("f" . 'org-roam-node-find))
  :config
  (setq org-roam-completion-everywhere t
	org-roam-directory (file-truename "~/org/roam")))

(add-hook 'org-capture-after-finalize-hook 'my-org-exit-frame-if-fleeting)

(setq org-roam-capture-templates
      '(
        ("d" "default node" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                          "#+title: ${title}\n#+filetags: ${filetags}")
         :unnarrowed t)
        ("l" "lecture notes" plain
        "* Lecture Notes\n- %?"
        :target (file+head "lecture-notes/${title}.org"
                    "#+filetags: lecture-%^{prompt||iss308|ece366|mth425|cse331|ece309} \n#+title: ${title}\n")
        :unnarrowed t)
        ("t" "todo" entry
         "* TODO %?"
         :target (node "todos")
         :kill-buffer t)
        ))

(setq org-log-done 'time)
(setq org-agenda-skip-deadline-if-done t)

(setq org-todo-keywords
      '((sequence
	 "IDEA(i)"
	 "TODO(t)"
	 "INACTIVE(I)"
	 "DOING(d)"
	 "BLOCKED(b@)"
	 "|"
	 "COMPLETE(c!)"
	 "NOT DOING(n!)")))

(use-package org-roam-ql
  :after (org-roam)
  :bind ((:map org-roam-mode-map
	       ("v" . org-roam-ql-buffer-dispatch)
	       :map minibuffer-mode-map
	       ("C-c n i" . org-roam-ql-insert-node-title))))

(defun my-org-get-tags-at-point-safe ()
  (interactive)
  (or (split-string (or (org-entry-get (point) "TAGS") "nil") ":" t) "nil"))

(defun my-org-get-tags-list (point)
  (split-string (or (org-entry-get (point) "TAGS") "nil") ":" t))

(setq my-org-categories-alist
      '(("reading" . "READING")))

(defun my-org-categorize-by-tags ()
  (interactive)
  (org-map-entries (lambda ()
		     (let*
			 ((tags nil)
			  (targetcat nil))
		       (when-let
			   ;; (tags (split-string (or (org-entry-get (point) "TAGS") "nil") ":" t))
			   (tags (my-org-get-tags-at-point-safe))
			 (dolist (targetcat my-org-categories-alist)
			   (when (member (car targetcat) tags)
			     (org-entry-put (point) "CATEGORY" (cdr targetcat)))))))))

(setq my-org-refile-by-tag-alist
      '(("cse331" . "~/org/roam/cse331.org")))

(use-package org-super-agenda
  :hook (org-agenda-mode . org-super-agenda-mode)
  :config
  (setq org-super-agenda-groups
	'((:log t)
	    (:name "Today"
		:scheduled today))))

(setq org-agenda-files '("~/org/roam" "~/org/roam/daily"))

(setq org-agenda-prefix-format
      '((agenda . "%+12(my-org-category-prefix) [ %15(string-join (my-org-get-tags-at-point-safe) \":\") ] %5t %s")
	(todo . " %i %-12:c")
	(tags . " %i %-12:c")
	(search . "%i %-12:c")))

(set-face-foreground 'org-upcoming-deadline "goldenrod1")
(set-face-foreground 'org-imminent-deadline "tomato1")

(setq org-agenda-deadline-faces
      '((1.0 . org-imminent-deadline)
	(0.5 . org-upcoming-deadline)
	(0.0 . org-upcoming-distant-deadline)))

(setq org-agenda-window-setup "only-window")

(setq org-agenda-span 'week)

(setq org-agenda-skip-deadline-if-done nil)
(setq org-agenda-skip-function-global '(org-agenda-skip-entry-if 'todo 'done))

(setq org-deadline-warning-days 7)

(setq org-src-window-setup 'split-window-below
      org-babel-python-command "python3"
      org-confirm-babel-evaluate nil) ;; Don't ask to execute

(use-package ob-mermaid)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((mermaid . t)
   (python . t)
   (emacs-lisp . t)))

(font-lock-add-keywords 'org-mode
			'(("^ *\\([-]\\) "
			   (0 (prog1 ()
				(compose-region
				 (match-beginning 1)
				 (match-end 1)
				 "•" ))))))

(setq org-adapt-indentation t
      org-indent-indentation-per-level 4
      org-ellipsis " ... ")

(setq org-hide-leading-stars t
      org-pretty-entities t)

(setq org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

(setq org-todo-keyword-faces
      '(
	("IDEA" . (:foreground "dark khaki" :weight bold))
	("INACTIVE" . (:foreground "dim gray" :weight bold))
	("TODO" . (:foreground "cyan" :weight bold))
	("DOING" . (:foreground "tan" :weight bold))
	("BLOCKED" . (:foreground "tomato" :weight bold))
	("COMPLETE" . (:foreground "chartreuse" :weight bold))
	("NOT DOING" . (:foreground "dim gray" :weight bold))
	))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode))
;(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))

(setq org-hide-emphasis-markers t)

(use-package org-appear
  :commands (org-appear-mode)
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t)
  (setq org-appear-autoemphasis t
	org-appear-autolinks t
	org-appear-autosubmarkers t))

(use-package org-special-block-extras
  :ensure t
  :hook (org-mode . org-special-block-extras-mode))

(use-package olivetti
  :hook (org-mode . olivetti-mode)
  :config
  (setq olivetti-body-width 0.70))

(with-eval-after-load 'org-faces
  (progn
    (set-face-attribute 'org-block nil :inherit 'fixed-pitch :height 0.85)
    (set-face-attribute 'org-code nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
    (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
    (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)
    (set-face-attribute 'org-hide nil :inherit 'fixed-pitch)
    ;; (set-face-attribute 'org-block-begin-line nil :inherit '(org-hide))
    (set-face-attribute 'org-block-begin-line nil :extend t)
    ;; (set-face-attribute 'org-block nil :background "#282828"))
    (set-face-attribute 'org-block-end-line nil :extend t))
    (require 'org-indent)
    (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch) :height 0.85))

(add-hook 'org-mode-hook 'variable-pitch-mode)

(require 'ox-md)

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

(setq org-format-latex-options
      '(:foreground default
		    :background default
		    :scale 2.0
		    :html-foreground "Transparent"
		    :html-background "Transparent"
		    :html-scale 1.0
		    :matchers ("begin" "$1" "$" "$$" "\\(" "\\[" )))

(with-eval-after-load 'org 
     (add-to-list 'org-latex-packages-alist '("" "amsfonts" t))
     (add-to-list 'org-latex-packages-alist '("" "amsmath" t))
     (add-to-list 'org-latex-packages-alist '("" "amsthm" t))
     (add-to-list 'org-latex-packages-alist '("" "amssymb" t))
     (setq org-format-latex-options 
           (plist-put org-format-latex-options :scale 0.80)))

(setq org-startup-with-inline-images t
      org-startup-with-latex-preview t
      org-highlight-latex-and-related '(native))

(setq org-outline-path-complete-in-steps nil)

(defun my-org-category-prefix ()
  (interactive)
  (let*
      ((category (org-entry-get (point) "CATEGORY"))
       (fname (file-name-sans-extension (file-name-nondirectory (or (buffer-file-name) "nil")))))
    (if (string-equal category fname)
      "MISC"
      category)))
