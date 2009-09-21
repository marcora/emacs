;; Add home emacs dir to load path
(add-to-list 'load-path "~/.emacs.d")

;; Match bash shell paths when launched from Finder
(setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin:/usr/local/bin:/usr/texbin"))
(setq exec-path (append exec-path '("/opt/local/bin"
                                    "/usr/local/bin"
                                    "/usr/texbin")))

;; User info and prefs
(setq user-full-name "Edoardo \"Dado\" Marcora")
(setq user-mail-address "edoardo.marcora@gmail.com")
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Colors and appearance
(scroll-bar-mode 'right)
(tool-bar-mode 0)
(show-paren-mode t)
(setq show-paren-style 'mixed)
(column-number-mode t)
(global-font-lock-mode t t)
(setq font-lock-maximum-decoration t)
(setq query-replace-highlight t)
(setq search-highlight t)
;;(set-background-color "black")
;;(set-foreground-color "white")
(add-to-list 'load-path "~/.emacs.d/color-theme")
(require 'color-theme)        ; sudo aptitude install emacs-goodies-el
(color-theme-initialize)
(color-theme-arjen)

;; Carbon emacs config
(setq mac-command-modifier 'alt mac-option-modifier 'meta)
(require 'redo)
(global-set-key [(control z)] 'undo)
(global-set-key [(control shift z)] 'redo)
(require 'mac-key-mode)
(mac-key-mode 1)
(define-key mac-key-mode-map (kbd "A-1") 'delete-other-windows)
(define-key mac-key-mode-map (kbd "A-2") 'split-window-vertically)
(define-key mac-key-mode-map (kbd "A-3") 'split-window-horizontally)
(define-key mac-key-mode-map (kbd "A-/") 'comment-or-uncomment-region-or-line)

;; Other key bindings
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\M-s" 'isearch-forward-regexp)
(global-set-key "\M-r" 'isearch-backward-regexp)

;; Behavior
(recentf-mode t)
(ido-mode t)
(cua-mode t)
(transient-mark-mode t)
(setq cua-keep-region-after-copy t)
(setq-default indent-tabs-mode nil)
(setq default-truncate-lines t)
(setq save-abbrevs nil)
;;(setq find-file-run-dired t)
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
(setq scroll-preserve-screen-position t)
(setq frame-title-format "Emacs - %b")
(setq resize-minibuffer-mode t)
(delete-selection-mode t)
(setq default-major-mode 'text-mode)
(setq initial-major-mode 'text-mode)
;;(setq text-mode-hook 'turn-on-auto-fill)
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq require-final-newline t)
(fset 'yes-or-no-p 'y-or-n-p)
(setq next-line-add-newlines nil)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(mouse-wheel-mode t)
(xterm-mouse-mode t)
(setq scroll-step 1
      scroll-margin 3
      scroll-conservatively 10000)
(setq mouse-wheel-scroll-amount '(3 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)
(setq backup-inhibited t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq delete-auto-save-files t)
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers
;;(require 'find-recursive)
(require 'anything)
(require 'anything-config)
(require 'anything-show-completion)
(require 'anything-rcodetools)
(setq rct-get-all-methods-command "PAGER=cat qri -l")
(define-key anything-map "\C-z" 'anything-execute-persistent-action)
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-x a") 'anything)
(global-set-key (kbd "C-x f") 'ido-find-file)
(add-hook 'after-init-hook
          (lambda () (setq debug-on-error nil)))

;; Tramp
(setq tramp-default-method "ssh")
(setq tramp-default-user "marcorae"
      tramp-default-host "spurs.dreamhost.com")

;; Dired
(require 'dired-extension)
(require 'dired-single)
(defun my-dired-init ()
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map [backspace]
    (function
     (lambda nil (interactive) (dired-single-buffer "..")))))
(if (boundp 'dired-mode-map)
    (my-dired-init)
  (add-hook 'dired-load-hook 'my-dired-init))

;; Smart compile and drag-and-drop
(require 'smart-compile)
(global-set-key (kbd "C-c C-c") 'smart-compile)
(require 'smart-dnd)
(smart-dnd-setup
 '(
   ("\\.png\\'" . "image file: %f\n")
   ("\\.jpg\\'" . "image file: %f\n")
   (".exe\\'"   . (message (concat "executable: " f)))
   (".*"        . "any filename: %f\n")
   ))
(add-hook
 'html-mode-hook
 (lambda ()
   (smart-dnd-setup
    '(
      ("\\.gif\\'" . "<img src=\"%R\">\n")
      ("\\.jpg\\'" . "<img src=\"%R\">\n")
      ("\\.png\\'" . "<img src=\"%R\">\n")
      ("\\.css\\'" . "<link rel=\"stylesheet\" type=\"text/css\" href=\"%R\">\n" )
      ("\\.js\\'"  . "<script type=\"text/javascript\" src=\"%R\"></script>\n" )
      (".*" . "<a href=\"%R\">%f</a>\n")
      ))))
(add-hook
 'latex-mode-hook
 (lambda ()
   (smart-dnd-setup
    '(
      ("\\.tex\\'" . "\\input{%r}\n")
      ("\\.cls\\'" . "\\documentclass{%f}\n")
      ("\\.sty\\'" . "\\usepackage{%f}\n")
      ("\\.eps\\'" . "\\includegraphics[]{%r}\n")
      ("\\.ps\\'"  . "\\includegraphics[]{%r}\n")
      ("\\.pdf\\'" . "\\includegraphics[]{%r}\n")
      ("\\.jpg\\'" . "\\includegraphics[]{%r}\n")
      ("\\.png\\'" . "\\includegraphics[]{%r}\n")
      ))))
(add-hook 'c-mode-common-hook
          (lambda () (smart-dnd-setup '(("\\.h\\'" . "#include <%f>")))))

;; SVN
(require 'psvn)
(setq svn-status-track-user-input t)

;; Git
(require 'git)

;; Switch buffer
(require 'swbuff)
(global-set-key (kbd "<C-tab>") 'swbuff-switch-to-next-buffer)
(global-set-key (kbd "<C-S-tab>") 'swbuff-switch-to-previous-buffer)
;;(require 'tabbar)
;;(tabbar-mode)
;;(setq tabbar-buffer-groups-function (lambda () (list “All Buffers”)))
;;(setq tabbar-buffer-list-function (lambda () (remove-if (lambda(buffer) (find ;;(aref (buffer-name buffer) 0) “ *”)) (buffer-list))))
;;(defun-prefix-alt shk-tabbar-next (tabbar-forward-tab) (tabbar-forward-group) ;;(tabbar-mode 1))
;;(defun-prefix-alt shk-tabbar-prev (tabbar-backward-tab) (tabbar-backward-group) ;;(tabbar-mode 1))
;;(global-set-key [(control tab)] 'shk-tabbar-next)
;;(global-set-key [(control shift tab)] 'shk-tabbar-prev)

;; Org mode
;; already part of emacs 23, but oldish version
;; Org-mode settings
(setq load-path (cons "~/.emacs.d/org/lisp" load-path))
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-directory "~/.org")
(setq org-default-notes-file (concat org-directory "/notes.org"))
(setq org-hide-leading-stars t)
(setq org-completion-use-ido t)
(setq org-return-follows-link t)
(setq org-support-shift-select t)
                                        ; (setq org-replace-disputed-keys t)
(define-key global-map "\C-cr" 'org-remember)
(add-hook 'org-mode-hook                ; yasnippet compatibility
          (lambda ()
            (org-set-local 'yas/trigger-key [tab])
            (define-key yas/keymap [tab] 'yas/next-field-group)))

;; Dot mode
(load-file "~/.emacs.d/graphviz-dot-mode.el")

;; AUCTeX
;; (require 'tex-site)
;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)
;; (setq-default TeX-master nil)
;; (setq-default TeX-master "master")
;; (add-hook 'LaTeX-mode-hook '(lambda () (TeX-fold-mode 1)))
;; (add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
;;
(add-to-list 'load-path "~/.emacs.d/auctex")
(add-to-list 'load-path "~/.emacs.d/auctex/preview")
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)
(autoload 'turn-on-bib-cite "bib-cite")
(add-hook 'LaTeX-mode-hook 'turn-on-bib-cite)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
;; (add-hook 'LaTeX-mode-hook 'outline-minor-mode)
(setq TeX-auto-untabify t)
(setq bib-novice nil)
;; (setq outline-minor-mode-prefix "\C-c\C-o")
(setq LaTeX-command "latex -synctex=1")

;; RefTex
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq reftex-auto-recenter-toc t)
(setq reftex-cite-format 'natbib)
(setq reftex-use-multiple-selection-buffers t)
(setq bib-cite-use-reftex-view-crossref t)

;; BibTeX
(require 'bibtex)
(setq bibtex-autokey-name-case-convert 'identity)
(setq bibtex-autokey-titlewords 0)
(setq bibtex-autokey-year-length 4)
(setq bibtex-autokey-year-title-separator "")

;; Fetch article bibliographic information from PubMed when in BibTeX mode (pymacs function)
(add-hook 'bibtex-mode-hook
          (lambda ()
            (pymacs-load "bibtex")
            (local-set-key [(control c) (+)] 'bibtex-pmfetch)))

;; Python and Pymacs
;; sudo aptitude install python-mode pymacs
(autoload 'pymacs-load "pymacs" nil t)
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(eval-after-load "pymacs"
  '(add-to-list 'pymacs-load-path "~/.emacs.d/"))
(add-hook 'python-mode-hook
          (lambda ()
            (setq py-python-command "python")
            (require 'pycomplete)
            (require 'ipython)))

;; MATLAB mode
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)
(setq matlab-indent-function t) ; if you want function bodies indented
(setq matlab-verify-on-save-flag nil)   ; turn off auto-verify on save
(setq matlab-shell-command-switches '("-nojvm"))

;; Ruby mode
(defun ruby-eval-buffer () (interactive)
  "Evaluate the buffer with ruby."
  (shell-command-on-region (point-min) (point-max) "ruby"))

(require 'ruby-mode)
(setq rdebug-short-key-mode t)
(setq ri-ruby-script "/.emacs.d/ri-emacs.rb")
(autoload 'ri "~/.emacs.d/ri-ruby.el" nil t)
(add-to-list 'auto-mode-alist '("\\.thor$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rjs$" . ruby-mode))
(add-hook 'ruby-mode-hook
          (lambda ()
            (require 'ruby-electric)
            (require 'rcodetools)
            (require 'ruby-block)
            (require 'inf-ruby)
            (require 'rdebug)
            (local-set-key "\r" 'newline-and-indent)
            (local-set-key [(control return)] 'open-next-line)
            (local-set-key "\C-c\C-a" 'ruby-eval-buffer)
            (imenu-add-to-menubar "IMENU")
            (ruby-electric-mode t)
            (ruby-block-mode t)))
(add-to-list 'smart-compile-alist '("\\.rb$" . "ruby -w %f")) ;; redef smart-compile command for ruby

;; Rinari
(add-to-list 'load-path "~/.emacs.d/rinari")
(require 'rinari)
(setq rinari-tags-file-name "TAGS")

;; YAML mode
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
(add-hook 'yaml-mode-hook
          (lambda ()
            (define-key yaml-mode-map "\C-m" 'newline-and-indent)))

;; HAML/SASS mode
(require 'haml-mode nil 't)
(require 'sass-mode nil 't)
(add-to-list 'auto-mode-alist '("\\.haml$" . haml-mode))
(add-to-list 'auto-mode-alist '("\\.sass$" . sass-mode))

;; autotest
(require 'toggle)
(require 'autotest)

;; nxhtml
(add-to-list 'load-path "~/.emacs.d/nxhtml")
(load-library "autostart")
(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 1
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)
(add-to-list 'auto-mode-alist '("\\.html$" . nxhtml-mumamo-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.erb$" . eruby-nxhtml-mumamo-mode))
;;(add-hook 'nxhtml-mumamo-mode-hook 'tabkey2-mode)
;;(add-hook 'eruby-nxhtml-mumamo-mode-hook 'tabkey2-mode)

;; CSS
(setq cssm-indent-function 'cssm-c-style-indenter)

;; JavaScript

;; espresso
;; (autoload 'espresso-mode "espresso" nil t)
;; (add-to-list 'auto-mode-alist '("\\.js$" . espresso-mode))
;; (add-to-list 'auto-mode-alist '("\\.json$" . espresso-mode))

;; js2
(autoload 'js2-mode "js2" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
;; http://www.corybennett.org/projects/
(add-hook 'js2-mode-hook
          (lambda ()
            ;; make emacs recognize the error format produced by jslint
            (set (make-local-variable 'compilation-error-regexp-alist)
                 '(("^\\([a-zA-Z.0-9_/-]+\\):\\([0-9]+\\):\\([0-9]+\\)" 1 2 3)))
            (set (make-local-variable 'compile-command)
                 (let ((file (file-name-nondirectory buffer-file-name)))
                   (concat "~/.emacs.d/jslint/jslint " file)))))

(defun jsbeautify()
  "Beautify an entire javascript buffer"
  (interactive)
  (let ((old-point (point)))
    (save-excursion
      (shell-command-on-region (point-min) (point-max) "cd ~/.emacs.d && java org.mozilla.javascript.tools.shell.Main beautify-cl.js -n" t t))
    (goto-char old-point)))

(eval-after-load 'js2-mode
  '(progn
     (define-key js2-mode-map (kbd "\C-c \C-c") 'jsbeautify)))

(eval-after-load 'js2-mode
  '(progn
     (define-key js2-mode-map (kbd "TAB") (lambda()
                                            (interactive)
                                            (let ((yas/fallback-behavior 'return-nil))
                                              (unless (yas/expand)
                                                (indent-for-tab-command)
                                                (if (looking-back "^\s*")
                                                    (back-to-indentation))))))))

;; tabkey2
(require 'tabkey2)
(tabkey2-mode t)

;; yasnippet
(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/yasnippet/snippets")
(yas/load-directory "~/.emacs.d/yasnippets-rails/rails-snippets")

;; autocomplete
(add-to-list 'load-path "~/.emacs.d/auto-complete")
(require 'auto-complete)
(require 'auto-complete-yasnippet)
(require 'auto-complete-ruby)
(require 'auto-complete-css)
;;(require 'auto-complete-config)
(global-auto-complete-mode t)
(setq ac-auto-start t)
(setq ac-dwim t)
(setq ac-override-local-map nil)
(define-key ac-complete-mode-map "\t" 'ac-expand)
(define-key ac-complete-mode-map "\r" 'ac-complete)
(setq ac-modes (append ac-modes '(eshell-mode org-mode)))
(add-to-list 'ac-trigger-commands 'org-self-insert-command)
(ac-ruby-init)
(setq ac-sources (append ac-sources '(ac-source-yasnippet ac-source-imenu ac-source-abbrev ac-source-words-in-buffer)))
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq ac-sources (append ac-sources ac-source-symbols))))
(add-hook 'eshell-mode-hook
          (lambda ()
            (setq ac-sources (append ac-sources ac-source-files-in-current-dir))))
;; (add-hook 'ruby-mode-hook
;;           (lambda ()
;;             (setq ac-sources (append ac-sources ac-ruby-sources))))

;; Textmate-like behavior for Carbon emacs
(require 'textmate)
(textmate-mode t)

;; For more TextMate-like behavior
;; (setq skeleton-pair t)
;; (setq skeleton-pair-alist
;;       '((?\( _ ?\))
;;         (?[  _ ?])
;;         (?{  _ ?})
;;         (?\' _ ?\')
;;         (?\" _ ?\")))

;; (defun autopair-insert (arg)
;;   (interactive "P")
;;   (let (pair)
;;     (cond
;;      ((assq last-command-char skeleton-pair-alist)
;;       (autopair-open arg))
;;      (t
;;       (autopair-close arg)))))

;; (defun autopair-open (arg)
;;   (interactive "P")
;;   (let ((pair (assq last-command-char
;;                     skeleton-pair-alist)))
;;     (cond
;;      ((and (not mark-active)
;;            (eq (car pair) (car (last pair)))
;;            (eq (car pair) (char-after)))
;;       (autopair-close arg))
;;      (t
;;       (skeleton-pair-insert-maybe arg)))))

;; (defun autopair-close (arg)
;;   (interactive "P")
;;   (cond
;;    (mark-active
;;     (let (pair open)
;;       (dolist (pair skeleton-pair-alist)
;;         (when (eq last-command-char (car (last pair)))
;;           (setq open (car pair))))
;;       (setq last-command-char open)
;;       (skeleton-pair-insert-maybe arg)))
;;    ((looking-at
;;      (concat "[ \t\n]*"
;;              (regexp-quote (string last-command-char))))
;;     (replace-match (string last-command-char))
;;     (indent-according-to-mode))
;;    (t
;;     (self-insert-command (prefix-numeric-value arg))
;;     (indent-according-to-mode))))

;; (defun autopair-backspace (arg)
;;   (interactive "p")
;;   (if (eq (char-after)
;;           (car (last (assq (char-before) skeleton-pair-alist))))
;;       (and (char-after) (delete-char 1)))
;;   (if (and transient-mark-mode
;;            mark-active)
;;       (delete-region (region-beginning) (region-end))
;;     (delete-backward-char arg)))

;; (global-set-key [backspace] 'autopair-backspace)

;; (global-set-key "("  'autopair-insert)
;; (global-set-key ")"  'autopair-insert)
;; (global-set-key "["  'autopair-insert)
;; (global-set-key "]"  'autopair-insert)
;; (global-set-key "{"  'autopair-insert)
;; (global-set-key "}"  'autopair-insert)
;; (global-set-key "\'" 'autopair-insert)
;; (global-set-key "\"" 'autopair-insert)


;; Indent when pasting
;; (defadvice yank (after indent-region activate)
;;   (if (member major-mode
;;               '(emacs-lisp-mode scheme-mode lisp-mode
;;                                 c-mode c++-mode objc-mode
;;                                 latex-mode plain-tex-mode
;;                                 css-mode js2-mode ruby-mode
;;                                 python-mode yaml-mode))
;;       (let ((mark-even-if-inactive t))
;;         (indent-region (region-beginning) (region-end) nil))))

;; (defadvice yank-pop (after indent-region activate)
;;   (if (member major-mode
;;               '(emacs-lisp-mode scheme-mode lisp-mode
;;                                 c-mode c++-mode objc-mode
;;                                 latex-mode plain-tex-mode
;;                                 css-mode js2-mode ruby-mode
;;                                 python-mode yaml-mode))
;;       (let ((mark-even-if-inactive t))
;;         (indent-region (region-beginning) (region-end) nil))))

(defun kill-and-join-forward (&optional arg)
  "If at end of line, join with following; otherwise kill line. ;
    Deletes whitespace at join."
  (interactive "P")
  (if (and (eolp) (not (bolp)))
      (delete-indentation t)
    (kill-line arg)))

;; Count words in highlighted region (elisp function)
(defun count-words (start end)
  (interactive "r")
  (let ((words 0) (lines 0) (chars 0))
    (save-excursion
      (goto-char start)
      (while (< (point) end) (forward-word 1) (setq words (1+ words))))
    (setq lines (count-lines start end) chars (- end start))
    (message "Region has  %d lines;   %d words;   %d characters."
             lines words chars)))

;; Centering code stolen from somewhere and restolen from
;; http://www.chrislott.org/geek/emacs/dotemacs.html
;; centers the screen around a line...
(global-set-key [(control l)] 'centerer)
(defun centerer ()
  "Repositions current line: once middle, twice top, thrice bottom"
  (interactive)
  (cond ((eq last-command 'centerer2)   ; 3 times pressed = bottom
         (recenter -1))
        ((eq last-command 'centerer1)   ; 2 times pressed = top
         (recenter 0)
         (setq this-command 'centerer2))
        (t                              ; 1 time pressed = middle
         (recenter)
         (setq this-command 'centerer1))))


;; Kills live buffers
;; obtained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-some-buffers (&optional list)
  "For each buffer in LIST, kill it silently if unmodified. Otherwise ask.
LIST defaults to all existing live buffers."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
                                        ;(not (string-equal name "*Messages*"))
           ;; (not (string-equal name "*Buffer List*"))
                                        ;(not (string-equal name "*buffer-selection*"))
                                        ;(not (string-equal name "*Shell Command Output*"))
           (not (string-equal name "*scratch*"))
           (/= (aref name 0) ? )
           (if (buffer-modified-p buffer)
               (if (yes-or-no-p
                    (format "Buffer %s has been edited. Kill? " name))
                   (kill-buffer buffer))
             (kill-buffer buffer))))
    (setq list (cdr list))))

;; Kills all buffers except scratch
;; obtained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-all-buffers ()
  "kill all buffers, leaving *scratch* only"
  (interactive)
  (mapcar (lambda (x) (kill-buffer x))
          (buffer-list))
  (delete-other-windows))

;; Code cleanup
;; http://blog.modp.com/2008/11/handy-emacs-functions-for-code-cleanup.html
(defun buffer-untabify ()
  "Untabify an entire buffer"
  (interactive)
  (untabify (point-min) (point-max)))

(defun buffer-indent()
  "Reindent an entire buffer"
  (interactive)
  (indent-region (point-min) (point-max) nil))

(defun beautify()
  "Untabify and re-indent an entire buffer"
  (interactive)
  (if (equal buffer-file-coding-system 'undecided-unix )
      nil
    (set-buffer-file-coding-system 'undecided-unix))
  (setq c-basic-offset 4
        tab-width 4
        indent-tabs-mode nil)
  (buffer-untabify)
  (buffer-indent)
  (delete-trailing-whitespace))

;;
(defun generalized-shell-command (command arg)
  "Unifies `shell-command' and `shell-command-on-region'. If no region is
selected, run a shell command just like M-x shell-command (M-!).  If
no region is selected and an argument is a passed, run a shell command
and place its output after the mark as in C-u M-x `shell-command' (C-u
M-!).  If a region is selected pass the text of that region to the
shell and replace the text in that region with the output of the shell
command as in C-u M-x `shell-command-on-region' (C-u M-|). If a region
is selected AND an argument is passed (via C-u) send output to another
buffer instead of replacing the text in region."
  (interactive (list (read-from-minibuffer "Shell command: " nil nil nil 'shell-command-history)
                     current-prefix-arg))
  (let ((p (if mark-active (region-beginning) 0))
        (m (if mark-active (region-end) 0)))
    (if (= p m)
        ;; No active region
        (if (eq arg nil)
            (shell-command command)
          (shell-command command t))
      ;; Active region
      (if (eq arg nil)
          (shell-command-on-region p m command t t)
        (shell-command-on-region p m command)))))

;; show ascii table
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))
  (let ((i 0))
    (while (< i 254)
      (setq i (+ i 1))
      (insert (format "%4d %c\n" i i))))
  (beginning-of-buffer))

;; insert date into buffer at point
;; optained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%a %Y-%m-%d - %l:%M %p")))

;; Byte recompile the .emacs.d dir
(defun byte-recompile-emacsd ()
  "Byte recompile emacsd"
  (interactive)
  (byte-recompile-directory "~/.emacs.d" 1))

