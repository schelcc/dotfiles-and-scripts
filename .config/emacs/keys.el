(defun open-config () (interactive)
       (switch-to-buffer (find-file "~/.config/emacs/init.el")))

;; Custom prefixes for various things
(defvar-keymap file-io-map
  :doc "Keybind map for file io tasks"
  "r" #'recentf-open-files
  "P" #'open-config 
  "f" #'find-file)

(defvar-keymap org-io-map
  :doc "Keybind map for org stuff when not in org-mode"
  "a" 'org-agenda
  "c" 'org-capture
  "n" 'org-roam-capture
  "l" 'org-store-link
  "p" 'org-latex-preview)

(defvar-keymap global-prefix-map
  :doc "Global custom prefix map"
  "o" org-io-map
  "f" file-io-map)

;;(which-key-add-keymap-based-replacements file-io-map
;;  "r" `("Recent files")
;;  "P" `("Open init.el")
;;  "f" `("Find file"))
;;
;;(which-key-add-key-based-replacements org-io-map
;;  "a" `("org-agenda" . ,'org-agenda)
;;  "c" `("org-capture" . ,'org-capture)
;;  "n" `("org-roam-capture" . ,'org-roam-capture)
;;  "l" `("org-capture-link" . ,'org-capture-link)
;;  "p" `("org-latex-preview" . ,'org-latex-preview))
;;
;;(which-key-add-key-based-replacements global-prefix-map
;;  "o" `("ORG". ,org-io-map)
;;  "f" `("FILE" . ,file-io-map))
;;

(keymap-set global-map "C-SPC" global-prefix-map)

;;(keymap-set global-map "SPC" orgmode-prefix-map)
