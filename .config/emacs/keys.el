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

(defun open-config () (interactive)
       (switch-to-buffer (find-file "~/.config/emacs/init.el")))

(defun open-key-config () (interactive)
       (switch-to-buffer (find-file "~/.config/emacs/keys.el")))

(defun open-org-config () (interactive)
       (switch-to-buffer (find-file "~/.config/emacs/org.el")))

(defun scratch-org () (interactive)
       (switch-to-buffer (scratch-buffer))
       (org-mode))

(defun scratch-spice () (interactive)
       (switch-to-buffer (scratch-buffer))
       (spice-mode))

(setq currently-dark nil)
(defun theme-swap ()
    (interactive)
    (if currently-dark
	(progn
	    (load-theme 'gruvbox-light-soft t)
	    (setq currently-dark nil))
	(progn
	    (load-theme 'gruvbox-dark-medium t)
	    (setq currently-dark t))))

;;(setq vterm-mode-map "C-c <escape>" #'evil-normal-state)

;; Custom prefixes for various things
(defvar-keymap file-io-map
  :doc "Keybind map for file io tasks"
  "r" #'recentf-open-files
  "P" #'open-config 
  "f" #'find-file
  "d" #'dired
  "K" #'open-key-config
  "O" #'open-org-config)

(defvar-keymap org-io-map
  :doc "Keybind map for org stuff when not in org-mode"
  "a" 'org-agenda
  "c" 'org-capture
  "n" 'org-roam-capture
  "f" 'org-roam-node-find
  "l" 'org-store-link
  "p" 'org-latex-preview)

(defvar-keymap buffer-menu-map
  :doc "Keybind map for buffer tasks"
  "s" #'scratch-buffer
  "o" #'scratch-org
  "S" #'scratch-spice
  "m" #'buffer-menu
  "%" #'split-window-right
  "\"" #'split-window-below
  "K" #'kill-buffer)

(defvar-keymap global-prefix-map
  :doc "Global custom prefix map"
  "o" `("Org IO Keybinds" . ,org-io-map)
  "f" `("File IO keybinds" . ,file-io-map)
  "b" `("Buffer & Options" . ,buffer-menu-map)
  "e" #'elfeed
  "l" #'company-complete
  "t" #'neotree-toggle
  "T" 'theme-swap)

(keymap-set global-map "C-SPC" global-prefix-map)

(setq text-scale-mode-step 1.2)
(keymap-set global-map "C-=" 'text-scale-increase)
(keymap-set global-map "C--" 'text-scale-decrease)
