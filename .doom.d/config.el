;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Lucas Ford"
      user-mail-address "lcford2@ncsu.edu")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
 (setq doom-font (font-spec :family "DejaVuSansMono Nerd Font" :size 32 :weight 'semi-light)
       doom-variable-pitch-font (font-spec :family "Ubuntu Nerd Font" :size 32))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-monokai-classic)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; update the font size depending on the screen resolution
(defun fontify-frame (frame)
  (interactive)
  (if window-system
    (progn
      (if (> (nth 3 (assq 'geometry (frame-monitor-attributes))) 3000)
        (set-frame-parameter frame 'font "DejaVuSansMono Nerd Font 32") ;; laptop screen
      (set-frame-parameter frame 'font "DejaVuSansMono Nerd Font 18"))))) ;

;; fontify current frame
(fontify-frame nil)

;; fontify any future frames
(push 'fontify-frame after-make-frame-functions)

(beacon-mode 1)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/org/*")

;; This allows org to find files in subdirectories of `org-directory`
(setq org-agenda-files (directory-files-recursively "~/Documents/org/" "\\.org$"))

;; This allows org to find files in subdirectories of `org-directory`
;; when exporting org stuff I want it to go to specific export directorys (e.g., export_tex, export_md)
;; this keeps my org directories from being cluttered
(defvar org-export-output-directory-prefix "export_" "prefix of directory used for org-mode export")

(defadvice org-export-output-file-name (before org-add-export-dir activate)
"Modifies org-export to place exported files in a different directory"
(when (not pub-dir)
        (setq pub-dir (concat org-export-output-directory-prefix (substring extension 1)))
        (when (not (file-directory-p pub-dir))
        (make-directory pub-dir))))

;; bullets for org mode
(require 'org-bullets)
;; make available "org-bullet-face" such that I can control the font size individually
(setq org-bullets-face-name (quote org-bullet-face))
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq org-bullets-bullet-list '("○" "☉" "◎" "◉" "○" "◌" "◎" "●" "◦" "◯" "⚪" "⚫" "⚬" "❍" "￮" "⊙" "⊚" "⊛" "∙" "∘"))

;; persist org clock over sessions
(setq org-clock-persist 'history)
(org-clock-persistence-insinuate)

;; org tree slie
(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

(use-package org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode))

(setq org-agenda-show-future-repeats 'next)

(use-package org-tempo)

;; (use-package org-gcal)
;; (setq org-gcal-client-id "819286579115-cb4skv3nvmh1p65k6dafpb5kg9uocice.apps.googleusercontent.com"
;;       org-gcal-client-secret "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"
;;       org-gcal-file-alist '(("lcford2@ncsu.edu" . "~/Documents/org/agenda/gcal/work.org")
;;                             ("as6njklct2jcku4fs3meqeli9c@group.calendar.google.com" . "~/Documents/org/agenda/finances.org")
;;                             ("lcford185@gmail.com" . "~/Documents/org/agenda/gcal/personal.org")
;;                             ("foreverford2020@gmail.com" . "~/Documents/org/agenda/gcal/joint.org")))

(use-package writeroom-mode
  :config
  (setq writeroom-width 120))

(define-minor-mode presentation-mode
  nil
  :lighter " presentation"

 (add-hook 'presentation-mode-on-hook 'writeroom-mode)
 (add-hook 'presentation-mode-on-hook 'org-tree-slide-mode)
 (add-hook 'presentation-mode-on-hook (lambda () (display-line-numbers-mode -1)))
 (add-hook 'presentation-mode-on-hook (lambda () (beacon-mode -1)))
 (add-hook 'presentation-mode-off-hook (lambda () (writeroom-mode -1)))
 (add-hook 'presentation-mode-off-hook (lambda () (org-tree-slide-mode nil)))
 (add-hook 'presentation-mode-off-hook 'display-line-numbers-mode)
 (add-hook 'presentation-mode-off-hook (lambda () (beacon-mode 1))))

;; add personal package directory
;; (add-load-path! "lisp")
;; (add-load-path! "/usr/share/emacs/site-lisp/mu4e")
;; (setq byte-compile-warnings '(cl-functions))

;; (require 'kivy-mode)
;; (add-to-list 'auto-mode-alist '("\\.kv" . kivy-mode))

(global-set-key (kbd "C-/") 'comment-line)

(global-set-key (kbd "M->") 'evil-window-increase-width)
(global-set-key (kbd "M-<") 'evil-window-decrease-width)

(map! :leader
       :desc "Open emacs dashboard"
       "o D" 'dashboard-refresh-buffer)

;; (setq company-backends
;;     '((company-capf company-dabbrev-code)))

;; (map! :desc "Completion with Company Backends"
;;       "M-TAB" '+company/complete)

(yas-global-mode 1)
(setq yas-snippet-dirs
      '("~/.doom.d/snippets"))

;; configure python development help
;;(use-package elpy
;;  :init
;;  (elpy-enable))

(use-package pyvenv
  :config
  (pyvenv-mode 1))

;;(add-hook 'elpy-mode-hook (lambda () (highlight-indentation-mode -1)))
;;(when (require 'flycheck nil t)
;;  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
;;  (add-hook 'elpy-mode-hook 'flycheck-mode))

;;(require 'conda)

;;(custom-set-variables
;; '(conda-anaconda-home "/home/lford/miniconda3"))

;;(setq conda-env-home-directory "/home/lford/miniconda3")
;;(setq-default mode-line-format (cons mode-line-format '(:exec conda-env-current-name)))


;;(defun my/python-mode-hook ()
;;  (ignore-errors
;;      (conda-env-activate-for-buffer)))

;;(add-hook 'python-mode-hook 'my/python-mode-hook)

;; (require 'lsp-python-ms)
(setq lsp-python-ms-auto-install-server t)
(add-hook 'python-mode-hook #'lsp)

(require 'pyenv-mode)

(defun projectile-pyenv-mode-set ()
  "Set pyenv version matching project name."
  (let ((project (projectile-project-name)))
    (if (member project (pyenv-mode-versions))
        (pyenv-mode-set project)
      (pyenv-mode-unset))))

(add-hook 'projectile-after-switch-project-hook 'projectile-pyenv-mode-set)

(use-package vertico
  :init
  (vertico-mode)
  )

;; director extension
(use-package vertico-directory
  :after vertico
  :ensure nil
  :bind (:map vertico-map
              ("RET" . vertico-directory-enter)
              ("DEL" . vertico-directory-delete-char)
              ("M-DEL" . vertico-directory-delete-word))
  ;; tidy shadowed file Names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

(setq completion-in-region-function
      (lambda (&rest args)
        (apply (if vertico-mode
                   #'consult-completion-in-region
                 #'completion--in-region)
               args)))

(use-package dashboard
  :load-path "/home/lford/cloned_repos/emacs-dashboard"
  :config
  (dashboard-setup-startup-hook))

(setq dashboard-startup-banner "/home/lford/.doom.d/200px-EmacsIcon.png")
(setq dashboard-center-content t)
(setq dashboard-set-heading-icons t)
(setq dashboard-set-file-icons t)

(setq dashboard-items '((projects . 5)
                        ;(recents . 5)
                        (agenda . 12)))

;; (setq dashboard-week-agenda t)

;; (setq dashboard-filter-agenda-entry 'dashboard-filter-agenda-by-todo)

;; (setq dashboard-match-agenda-entry
;;       "TODO=\"TODO\"")

(setq dashboard-agenda-sort-strategy '(time-up))
