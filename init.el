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
(global-auto-revert-mode t) ;; reverts buffer automatically when the associated file in changed on disk

;; Setting the default font

(set-face-attribute 'default nil :family "JetBrains Mono" :height 120)

;; Configuring the packaging system
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

;; Modus Vivendi more like Everforest
;; The modus themes are really configurable and I really like how the Everforest theme looks like...
;; - [[https://github.com/sainnhe/everforest]]
;; - [[https://protesilaos.com/emacs/modus-themes]]

;; Modus themes are really configurable

(use-package modus-themes
  :custom
  (modus-vivendi-palette-overrides ;;changing default modus vivendi palette
   '(
     ;; Main colors
     (bg-dim "#1E2326") ;; bg_dim
     (bg-main "#272E33") ;; bg0
     (bg1 "#2E383C") ;; bg1
     (bg2 "#374145") ;; bg2
     (bg3 "#414B50") ;; bg3
     (bg4 "#495156") ;; bg4
     (bg5 "#4F5B58") ;; bg5
     (fg-main "#D3C6AA") ;; fg
     (red "#E67E80") ;; red
     (bg-red "#4C3743") ;; bg_red
     (orange "#E69875") ;; orange
     (bg-orange"#493B40") ;; bg_visual
     (yellow "#DBBC7F") ;; yellow
     (bg-yellow "#45443C") ;; bg_yellow
     (green "#A7C080") ;; green
     (bg-green "#3C4841") ;; bg_green
     (blue "#7FBBB3") ;; blue
     (bg-blue "#384B55") ;; bg_blue
     (aqua "#83C092") ;; aqua
     (pink "#D699B6") ;; purple
     (gray0 "#7A8478") ;; gray0
     (gray1 "#859289") ;; gray1
     (gray2 "#9DA9A0") ;; gray2
     ;; Semantic colors
     (cursor red) ;; cursor
     ;; Programming set
     (keyword pink)
     (type pink)
     (builtin pink) ;; so python type names are pink
     (fnname red)
     (variable blue)
     (string orange)
     (comment gray0)
     (constant yellow)
     (preprocessor green)
     ;; parentheses matching
     (bg-paren-match gray1)
     ;; modeline
     (bg-mode-line-active bg1)
     (fg-mode-line-active fg)
     (bg-mode-line-inactive bg-dim)
     (fg-mode-line-inactive fg)
     ;; active region
     (bg-region bg-main)
     (fg-region green)
     ;; links
     (fg-link blue)
     (underline-link blue)
     ;; headings
     (fg-heading-0 fg)
     (fg-heading-1 fg)
     (fg-heading-2 aqua)
     (fg-heading-3 blue)
     (fg-heading-4 green)
     ;; completions
     (fg-completion-match-0 blue)
     (bg-completion bg3)
     () 
     () 
     )
   ) ;; purple
  (modus-themes-bold-constructs t) ;; bold keywords
  (modus-themes-italic-constructs t) ;; italic comments
  (modus-themes-org-blocks t) ;; spicier org source blocks
  :config
  (load-theme 'modus-vivendi t)) ;; loading theme without asking for confirmation

;; doom-modeline
;; To correctly display the icons in the modeline you also need to install the fonts, which can be done by typing:
;; #+begin_center
;; M-x all-the-icons-install-usonts
;; #+end_center

(use-package doom-modeline
  :config
  (setq doom-modeline-height 15) ;; settings the modeline bar height
  (doom-modeline-mode 1)) ;; activate doom-modeline
(use-package all-the-icons) ;; so that icons can be displayed in doom-modeline

;; ivy/counsel
;; Ivy - a generic completion frontend for Emacs, Swiper - isearch with an overview, and more. Oh, man!
;; [[https://github.com/abo-abo/swiper]]

(use-package counsel ;; counsel is packaged with ivy and replaces some of the default commands with ivy enhanced ones
             :diminish ;; hides ivy from the modes list in the Emacs mode line
             :config ;; executes code after the package is loaded
             (setq ivy-wrap t)
             (global-set-key (kbd "C-x b") 'counsel-switch-buffer)
             (counsel-mode 1)) ;; activates counsel and ivy

;; ivy-rich
;; Sweet M-x functions comments and keybindings
;; [[https://github.com/Yevgnen/ivy-rich]]

(use-package ivy-rich
             :after counsel ;; waits until ivy has been loaded
             :diminish ;; hides ivy from the modes list in the Emacs mode line
             :config ;; executes code after the package is loaded
             (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line)
             (ivy-rich-mode 1)) ;; enables ivy-mode

;; which-key
;; Emacs package that displays available keybindings in popup
;; [[https://github.com/justbur/emacs-which-key]].

(use-package which-key
  :diminish ;; hides which-key from the modes list in the Emacs mode line
  :config ;; executes code after the package is loaded
  (which-key-mode 1)
  (setq which-key-idle-delay 0.2)) ;; waits a little before showing the suggestions

;; helpful
;; A better Emacs *help* buffer
;; +Does this count as completion? The help buffers are more complete I guess...+
;; [[https://github.com/Wilfred/helpful]]

(use-package helpful
  :config
  (setq counsel-describe-function-function #'helpful-callable) ;; adding helpful to the counsel help commands
  (setq counsel-describe-variable-function #'helpful-variable)) ;; adding helpful to the counsel help commands

;; evil-mode
;; Vim keybindings are great, so let's use them and configure them accross Emacs.
;; - [[https://evil.readthedocs.io/en/latest/overview.html#installation-via-package-el]]
;; - [[https://github.com/emacs-evil/evil-collection]]

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

;; projectile
;; Project Interaction Library for Emacs
;; [[https://github.com/bbatsov/projectile]]

(use-package projectile
  :diminish
  :custom
  (projectile-completion-system 'ivy)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (projectile-mode 1))

;; magit
;; Magit is a complete text-based user interface to Git
;; [[https://magit.vc/]]

(use-package magit)

;; General configuration

(use-package org ;; emacs already comes with orgmode, but let's make sure its up to date.
  :custom
  (org-ellipsis " ▾") ;; uses this character instead of ... when hiding information under a heading
  (org-hide-emphasis-markers nil) ;; shows the markup characters when rich text editing
  (org-confirm-babel-evaluate nil) ;; disables confirmation when running source blocks
  (org-agenda-files '("~/agenda/")) ;; org-agenda captures all org files in the agenda home folder directory
  (org-startup-folded 'content) ;; shows only the headings when entering a .org
  (org-capture-templates ;; defining some capture templates for fast content insertion to org agenda
   '(("t" "Task") ;; task category
     ("tg" "Gtel" entry (file "~/agenda/gtel.org") "* PLAN %?\n")
     ("tp" "Pers" entry (file "~/agenda/pers.org") "* PLAN %?\n")
     ("tu" "UFC" entry (file "~/agenda/ufc.org") "* PLAN %?\n")
     ("ti" "IC" entry (file "~/agenda/ic.org") "* PLAN %?\n")
     ("n" "Note") ;; note category
     ("ng" "Gtel" entry (file+headline "~/agenda/gtel.org" "Notes") "* TO BE SEEN %?\n[[%F]] %t")
     ("np" "Pers" entry (file+headline "~/agenda/pers.org" "Notes") "* TO BE SEEN %?\n[[%F]] %t")
     ("nu" "UFC" entry (file+headline "~/agenda/ufc.org" "Notes") "* TO BE SEEN %?\n[[%F]] %t")
     ("ni" "IC" entry (file+headline "~/agenda/ic.org" "Notes") "* TO BE SEEN %?\n[[%F]] %t")))
  :bind
  ("C-c a" . org-agenda) ;; fast access to org-agenda
  ("C-c c" . org-capture) ;; fast access to org-capture
  :config
  (org-babel-do-load-languages  ;; defines the languages which can be ran by org-babel
   'org-babel-load-languages
   '((emacs-lisp . t) ;; enables emacs-lisp
     (python . t) ;; enables python
     (shell . t) ;; enables shell
     (C . t))) ;; enables C, C++ and D
  (setq org-todo-keywords ;; defining more todo keyword sequences
	'((sequence "BACKLOG(b)" "PLAN(p)" "WORK(w!)" "REVIEW(r)" "HOLD(h@)" "|" "DONE(d!)" "CANCELED(c@)") ;; scrum methodology
	  (sequence "TO BE SEEN(t)" "|" "SEEN(s)")))) ;; for note taking

(require 'ox-latex) ;; so we can change the org-latex-classes variable
  (add-to-list 'org-latex-classes ;; adds sbrt class
	       '("sbrt" "\\documentclass[11pt]{sbrt}"
		("\\section{%s}" . "\\section*{%s}")
		("\\subsection{%s}" . "\\subsection*{%s}")
		("\\subsubsection{%s}" . "\\subsubsection*{%s}")
		("\\paragraph{%s}" . "\\paragraph*{%s}")
		("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; org-reveal
;; Adding reveal.js presentation framework export backend for nice presentations.
;; - org-reveal documentation https://github.com/yjwen/org-reveal.
;; - reveal.js documentation https://github.com/hakimel/reveal.js/.
;; - *To use org-reveal you have to load it:*
;;   : M-x loadlibrary ox-reveal

(use-package ox-reveal
  :custom org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js") ;; get reveal.js from a cdn instead of a local copy

;; org-bullets
;; keeping the * characters in each heading can become cumbersome, so let's use utf-8
;; characters instead.
;; [[https://github.com/sabof/org-bullets]]

(use-package org-bullets
  :after org ;; waits until org-mode has been loaded
  :hook (org-mode . org-bullets-mode) ;; activates this mode whenever org is activated
  :custom
    (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●"))) ;; setting the heading marks

;; lsp-mode
;; Client for Language Server Protocol (v3.14). lsp-mode aims to provide IDE-like experience
;; by providing optional integration with the most popular Emacs packages like company, flycheck and projectile.
;; [[https://emacs-lsp.github.io/lsp-mode/]]

(use-package lsp-mode
  :custom
  (lsp-keymap-prefix "C-c l") ;; setting a keybing for the lsp menu
  (lsp-headerline-breadcrumb-segments '(project file symbols)) ;; nicer breadcrumbs
  :hook ((c++-mode . lsp-deferred) ;; activates lsp when c++ mode buffer shows up
	 (latex-mode . lsp-deferred) ;; activates lsp when latex mode buffer shows up
	 (python-mode . lsp-deferred) ;; activates lsp when python mode buffer shows up
	 (lsp-mode . lsp-enable-which-key-integration)) ;; sweet which-key integration
  :commands lsp lsp-deferred)

(use-package lsp-ui ;; for fancy sideline, popup documentation, VScode-like peek UI, etc.
  :commands lsp-ui-mode)

(use-package lsp-ivy ;; to search for symbols in a workspace
  :bind ("C-c l s" . lsp-ivy-workspace-symbol))

;; auctex

(use-package tex
  :ensure auctex)

;; company
;; Company is a text completion framework for Emacs. The name stands for "complete anything".
;; It uses pluggable back-ends and front-ends to retrieve and display completion candidates.
;; [[https://company-mode.github.io/]]

(use-package company ;; complete anything
  :hook ((lsp-mode . company-mode) ;; auto-stats it after lsp-mode
	 (org-mode . company-mode)) ;; auto-stats it after org-mode 
  :custom
  (company-minimum-prefix-length 1) ;; suggestions starts after 1 character is typed
  (company-idle-delay 0.0)) ;; suggestions without delay

;; flycheck
;; Flycheck is a modern on-the-fly syntax checking extension for GNU Emacs, intended as
;; replacement for the older Flymake extension which is part of GNU Emacs.
;; [[https://www.flycheck.org/en/latest/]]

(use-package flycheck ;; syntax checking with flycheck
  :init (global-flycheck-mode))

;; yasnippet
;; YASnippet is a template system for Emacs. It allows you to type an abbreviation and
;; automatically expand it into function templates.
;; [[https://github.com/joaotavora/yasnippet]]

(use-package yasnippet ;; yet another templates system
  :config (yas-global-mode 1))

(use-package yasnippet-snippets ;; populate yasnippet
  :after yasnippet)

;; smartparens
;; Smartparens is a minor mode for dealing with pairs in Emacs and evil smartparens is a
;; minor mode which makes evil play nice with smartparens.
;; - [[https://github.com/Fuco1/smartparens]]
;; - [[https://github.com/expez/evil-smartparens]]

(use-package smartparens
  :bind (:map smartparens-mode-map
	      ("C-c s ("  . sp-wrap-round) ;; wrap around sexp with round parentheses
	      ("C-c s ["  . sp-wrap-square) ;; wrap around sexp with square brackets
	      ("C-c s {"  . sp-wrap-curly) ;; wrap around sexp with curly braces
	      ("C-c s \""  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\""))) ;; wrap around sexp with double quotes
	      ("C-c s '"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "'"))) ;; wrap around sexp with orgmode single quotes
	      ;; "orgmode"
	      ("C-c s o *"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "*"))) ;; wrap around sexp with orgmode bold marker
	      ("C-c s o /"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "/"))) ;; wrap around sexp with orgmode italic marker
	      ("C-c s o _"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "_"))) ;; wrap around sexp with orgmode underline marker
	      ("C-c s o ="  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "="))) ;; wrap around sexp with orgmode verbatim marker
	      ("C-c s o ~"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "~"))) ;; wrap around sexp with orgmode code marker
	      ("C-c s o +"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "+"))) ;; wrap around sexp with orgmode strike-through marker
	      ("C-c s o ["  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "[["))) ;; wrap around sexp with orgmode link marker
	      ;; latex
	      ("C-c s l *"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\\textbf{"))) ;; wrap around sexp with latex bold marker
	      ("C-c s l /"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\\emph{"))) ;; wrap around sexp with latex italic marker
	      ("C-c s l _"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\\underline{"))) ;; wrap around sexp with latex underline marker
	      ("C-c s l m ("  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\\("))) ;; wrap around sexp with latex underline marker
	      ("C-c s l m ["  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "\\["))) ;; wrap around sexp with latex underline marker
	      ("C-c s l m $"  . (lambda (&optional arg) (interactive "P") (sp-wrap-with-pair "$"))) ;; wrap around sexp with latex underline marker
	      ;; barfing
	      ("C-c s b f"  . sp-forward-barf-sexp) ;; barfs sexp forward
	      ("C-c s b b"  . sp-backward-barf-sexp) ;; barfs sexp backwards
	      ;; slurping
	      ("C-c s s f"  . sp-forward-slurp-sexp) ;; slurps sexp forward
	      ("C-c s s b"  . sp-backward-slurp-sexp) ;; slurps sexp backwards
	      ;; unwrapping and rewrapping
	      ("C-c s u"  . sp-unwrap-sexp) ;; unwraps sexp
	      ("C-c s r"  . sp-rewrap-sexp)) ;; rewraps sexp 
  :config
  ;; Removing pair '' insertion when cursor before symbol for elisp programming
  (sp-local-pair '(org-mode emacs-lisp-mode) "'" "'" :unless '(sp-point-before-symbol-p))
  ;; orgmode
  (sp-local-pair 'org-mode "*" "*" :actions '(:rem insert)) ;; bold
  (sp-local-pair 'org-mode "/" "/" :actions '(:rem insert)) ;; italic
  (sp-local-pair 'org-mode "_" "_" :actions '(:rem insert)) ;; underline
  (sp-local-pair 'org-mode "=" "=" :actions '(:rem insert)) ;; verbatim
  (sp-local-pair 'org-mode "~" "~") ;; code
  (sp-local-pair 'org-mode "+" "+" :actions '(:rem insert)) ;; strike-through
  (sp-local-pair 'org-mode "[[" "]]") ;; link
  ;; latex pairs
  (sp-local-pair '(org-mode latex-mode) "\\textbf{" "}") ;; bold
  (sp-local-pair '(org-mode latex-mode) "\\emph{" "}") ;; italic
  (sp-local-pair '(org-mode latex-mode) "\\underline{" "}") ;; underline
  (sp-local-pair '(org-mode latex-mode) "$" "$") ;; math delimiter
  (sp-local-pair '(org-mode latex-mode) "\\[" "\\]") ;; math delimiter
  (smartparens-global-strict-mode)) ;; activates the package globally

(use-package evil-smartparens
  :hook
  (org-mode . evil-smartparens-mode) ;; auto loads evil-smartparens in orgmode
  (latex-mode . evil-smartparens-mode) ;; auto loads evil-smartparens in latex-mode
  (python-mode . evil-smartparens-mode) ;; auto loads evil-smartparens in python-mode
  (C++-mode . evil-smartparens-mode)) ;; auto loads evil-smartparens in C++-mode

;; Setting python environment locally for org mode source blocks
;; This function automatizes the process of setting the python environment in a file
;; locally, by setting the python executable.

(defun set-local-org-babel-python-command (path) ;; path to the enviroment interpreter
  "Sets the python enviroment in a local file through the interpreter path."
  (interactive ;; enables an interactive call to the function (M-x)
   "sinterpreter path: ") ;; and also gets a string and saves it to the path variable
  (add-file-local-variable ;; sets a local variable in file locally
   'org-babel-python-command path) ;; sets python environment to org babel
  (save-buffer) ;; saves the changes
  (revert-buffer-quick)) ;; updates buffer to load the variable

;; Getting rid of annoying backup files

(setq backup-directory-alist '(("." . "~/.config/backup-files"))
 backup-by-copying t    ; Don't delink hardlinks
 version-control t      ; Use version numbers on backups
 delete-old-versions t  ; Automatically delete excess backups
 kept-new-versions 20   ; how many of the newest versions to keep
 kept-old-versions 5    ; and how many of the old
 )
