(defun open-config () (interactive)
       (switch-to-buffer (find-file "~/.config/emacs/init.el")))

(defun open-key-config () (interactive)
       (switch-to-buffer (find-file "~/.config/emacs/keys.el")))

(defun scratch-org () (interactive)
       (switch-to-buffer (scratch-buffer))
       (org-mode))

(defun scratch-spice () (interactive)
       (switch-to-buffer (scratch-buffer))
       (spice-mode))

;; Custom prefixes for various things
(defvar-keymap file-io-map
  :doc "Keybind map for file io tasks"
  "r" #'recentf-open-files
  "P" #'open-config 
  "f" #'find-file
  "d" #'dired
  "K" #'open-key-config)

(defvar-keymap org-io-map
  :doc "Keybind map for org stuff when not in org-mode"
  "a" 'org-agenda
  "c" 'org-capture
  "n" 'org-roam-capture
  "l" 'org-store-link
  "p" 'org-latex-preview)

(defvar-keymap buffer-menu-map
  :doc "Keybind map for buffer tasks"
  "s" #'scratch-buffer
  "o" #'scratch-org
  "S" #'scratch-spice
  "m" #'buffer-menu)

(defvar-keymap global-prefix-map
  :doc "Global custom prefix map"
  "o" `("Org IO Keybinds" . ,org-io-map)
  "f" `("File IO keybinds" . ,file-io-map)
  "b" `("Buffer & Options" . ,buffer-menu-map)
  "l" #'company-complete)

(keymap-set global-map "C-SPC" global-prefix-map)
