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

(defun my-org-insert-pre-dated-task ()
  (interactive)
  (save-excursion
    (setq heading (org-get-heading))
    (when (string-match "\\(<.*>\\)" heading)
      (when-let (deadline (match-string 0 heading))
	(move-end-of-line 1)
	(org-insert-todo-subheading t)
	(org-todo "TODO")
	(insert (read-string "Title: "))
	(org-set-tags-command)
	(cl-letf (((symbol-function #'called-interactively-p) (cl-constantly nil)))
	  (org-deadline nil deadline))))))

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

(define-key org-mode-map (kbd "C-c D") 'my-org-insert-pre-dated-task)
(define-key org-mode-map (kbd "C-c k") 'org-move-item-up)
(define-key org-mode-map (kbd "C-c j") 'org-move-item-down)
(define-key org-mode-map (kbd "C-c K") 'org-move-subtree-up)
(define-key org-mode-map (kbd "C-c J") 'org-move-subtree-down)

;;(setq vterm-mode-map "C-c <escape>" #'evil-normal-state)

;; Bind RET to follow org links
(define-key evil-motion-state-map (kbd "RET") nil)


(setq org-return-follows-link t)

;; Custom prefixes for various things
(defvar-keymap file-io-map
  :doc "Keybind map for file io tasks"
  "r" #'recentf-open-files
  "P" #'open-config 
  "f" #'find-file
  "d" #'dired
  "K" #'open-key-config
  "O" #'open-org-config)

(defvar-keymap org-download-map
  :doc "Keybind map for org-download tools"
  "c" 'org-download-clipboard)

(defvar-keymap org-io-map
  :doc "Keybind map for org stuff when not in org-mode"
  "a" 'org-agenda
  "c" 'org-capture
  "n" 'org-roam-capture
  "f" 'org-roam-node-find
  "l" 'org-store-link
  "p" 'org-latex-preview
  "d" `("Org-download options" . ,org-download-map))

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
