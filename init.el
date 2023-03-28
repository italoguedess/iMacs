;; Let's start by setting/unsetting some basic things
;; don't forget to use C-M-x to apply the changes without having to restart emacs

;; disabling the default startup screen of Emacs
(setq inhibit-startup-message t
      visible-bell t)

;; Enabling/disabling some modes

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(global-display-line-numbers-mode 1)
(hl-line-mode 1)
(blink-cursor-mode 1)

;; Loading the theme (nothing too fancy yet)

(load-theme 'modus-vivendi t)

;; Setting the default font

(set-face-attribute 'default nil :font "monospace" :height 120)

;; Setting the packaging system
;; - adding melpa, org and elpa repositories
;; - use-package to keep things tidy
;; - and also set use-package automatically install our packages


;; Initialize package sources
;; brings into the environment all the packaging management functions
(require 'package)

;; sets the package reposities which to pull from
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                        ("org" . "https://orgmode.org/elpa/")
                        ("elpa" . "https://elpa.gnu.org/packages/")))

;; initializes the package system and prepares it to be used
(package-initialize)
;; if there aren't contents in the package archive
;; (like in the first time this config is run)
(unless package-archive-contents
  ;; refresh them
  (package-refresh-contents))

;; if the 'use-package' package isn't installed
(unless (package-installed-p 'use-package)
  ;; installs it
  (package-install 'use-package))

;; requires 'use-package' to manage configurations and load packages
(require 'use-package)
;; ensures that the packages used by 'use-package' are being installed
(setq use-package-always-ensure t)

;; Nice completion with Ivy/Counsel

(use-package counsel ;; counsel is packaged with ivy and replaces some of the default commands with ivy enhanced ones
             :diminish ;; hides ivy from the modes list in the Emacs mode line
             :config ;; executes code after the package is loaded
             (setq ivy-wrap t)
             (global-set-key (kbd "C-x b") 'counsel-switch-buffer)
             (counsel-mode 1)) ;; activates counsel and ivy

;; Even nicer completions (like M-x functions comments and keybindings) with ivy-rich

(use-package ivy-rich
             :after counsel ;; waits until ivy has been loaded
             :diminish ;; hides ivy from the modes list in the Emacs mode line
             :config ;; executes code after the package is loaded
             (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
             (ivy-rich-mode 1)) ;; enables ivy-mode

;; Even even nicer completions, but now for keybindings with which-key

(use-package which-key
  :diminish ;; hides which-key from the modes list in the Emacs mode line
  :config ;; executes code after the package is loaded
  (which-key-mode 1)
  (setq which-key-idle-delay 0.2)) ;; waits a little before showing the suggestions

;; More helpful help commands with the helpful package

(use-package helpful
  :config
  (setq counsel-describe-function-function #'helpful-callable) ;; adding helpful to the counsel help commands
  (setq counsel-describe-variable-function #'helpful-variable)) ;; adding helpful to the counsel help commands

;; Mode line bling with doom-modeline
;; To correctly display the icons in the modeline you also need to install the fonts, which can be done by typing:
;; #+begin_center
;; M-x all-the-icons-install-usonts
;; #+end_center

(use-package doom-modeline
  :config
  (setq doom-modeline-height 15) ;; settings the modeline bar height
  (doom-modeline-mode 1)) ;; activate doom-modeline
(use-package all-the-icons) ;; so that icons can be displayed in doom-modeline

;; Vim keybindings are great
;; So let's use them and make sure they are readilly available accross Emacs with evil-collection

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil ;; waits until evil has been loaded
  :config
  (evil-collection-init))

;; Project management with projectile

(use-package projectile
  :diminish
  :custom
  (projectile-completion-system 'ivy)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1))

;; Magit is a nice git porcelain

(use-package magit)

;; Orgmode!
;; - emacs already comes with orgmode, but let's make sure its up to date.
;; - keeping the * characters in each heading can become cumbersome, so let's put simpler ones instead

(use-package org
  :custom
  (org-ellipsis " ▾") ;; uses this character instead of ... when hiding information under a heading
  (org-hide-emphasis-markers t)) ;; hides the markup characters when rich text editing
(use-package org-bullets
  :after org ;; waits until org-mode has been loaded
  :hook (org-mode . org-bullets-mode) ;; activates this mode whenever org is activated
  :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))) ;; setting the heading marks

;; IDEmacs
;; - setting up lsp-mode
;; - using lsp-ui-mode for nice popups
;; - lsp-ivy for a fancy symbols search
;; - company-mode for a sweeter completion
;; - yasnippet for the template type completion

(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l") ;; setting a keybing for the lsp menu
  :hook (
         (c++-mode . lsp-deferred) ;; activates lsp when c++ mode buffer shows up
         (lsp-mode . lsp-enable-which-key-integration)) ;; sweet which-key integration
  :commands lsp lsp-deferred)

(use-package lsp-ui ;; for fancy sideline, popup documentation, VScode-like peek UI, etc.
  :commands lsp-ui-mode)

(use-package lsp-ivy ;; to search for symbols in a workspace
  :bind ("C-c l s" . lsp-ivy-workspace-symbol))

(use-package company ;; complete anything
  :after lsp-mode ;; waits until lsp-mode has been loaded
  :hook (lsp-mode . company-mode) ;; auto-stats it after lsp-mode
  :custom
  (company-minimum-prefix-length 1) ;; suggestions starts after 1 character is typed
  (company-idle-delay 0.0)) ;; suggestions without delay

(use-package flycheck ;; syntax checking with flycheck
  :init (global-flycheck-mode))

(use-package yasnippet ;; yet another templates system
  :config (yas-global-mode 1))

(use-package yasnippet-snippets ;; populate yasnippet
  :after yasnippet)