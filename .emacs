(add-to-list 'load-path "~/.emacs.d/lisp/")
;;;;;;;;;;;;;; FOR ELPA ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
  (package-initialize))

(require 'package) ;; You might already have this line

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ENSURE FAVORITE PACKAGES ARE INSTALLED
(setq package-list '(iedit zenburn-theme helm helm-company  helm-swoop flycheck flycheck-color-mode-line p4 company  exec-path-from-shell popup  bookmark+ color-theme-solarized color-theme company-c-headers  company dynamic-fonts pcache persistent-soft list-utils pcache font-utils pcache persistent-soft list-utils pcache goto-chg exec-path-from-shell f dash s flycheck-color-mode-line dash flycheck pkg-info epl dash flymake-cursor font-utils pcache persistent-soft list-utils pcache google-this goto-chg company async  highlight-symbol iedit org  persistent-soft list-utils pcache pkg-info epl popup redo+ s stem yasnippet zenburn-theme highlight clang-format ycmd flycheck-ycmd company-ycmd whitespace))

; list the repositories containing them
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(setq package-enable-at-startup nil)
; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available 
(unless package-archive-contents
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(savehist-mode 1)
(require 'dired-x)
;; It's also worth pointing out that you can persist other variables across sessions by adding them to
;; savehist-additional-variables, like so:
(setq savehist-additional-variables '(kill-ring search-ring regexp-search-ring))
(desktop-save-mode 1)
;;(cua-mode 1) ;; cua mode redefines Cv, page - down - command
(show-paren-mode 1)
;; highlight current line
(global-hl-line-mode 1)
; Recentf is a minor mode that builds a list of recently opened files
(require 'recentf)
(recentf-mode 1)
(winner-mode 1)
(global-linum-mode)
(line-number-mode 1)

(defalias 'message-box 'message)
(setq-default ispell-program-name "/opt/local/bin/ispell")

;; ONLY FOR LINUX-ssh: (setq mac-option-modifier 'super)
;; ONLY FOR LINUX-ssh:  (setq mac-command-modifier 'meta)

;; I like having line numbers on the left of my editor -- whether it is coding or LaTeX or just my notes file.
(require 'linum)
(line-number-mode 1)
(column-number-mode 1)  ;; Line numbers on left most column
(global-linum-mode 1)

;;  alias the command name list-buffers to ibuffer
(defalias 'list-buffers 'ibuffer)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

;; Make URLs in comments/strings clickable, (emacs > v22)
(add-hook 'find-file-hooks 'goto-address-prog-mode)
;; Make shell scrips executable on save. Good!
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)
;; Scratch message
(setq initial-scratch-message ";; scratch buffer created -- happy hacking\n")
;;Emacs is a text editor, make sure your text files end in a newline
;;(setq require-final-newline 'query)
;;no extra whitespace after lines
;;(add-hook 'before-save-hook 'delete-trailing-whitespace)


;;(require 'helm-config)
(setq helm-buffer-max-length 50)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; press F in dired to visit marked files
(eval-after-load "dired"
  '(progn
     (define-key dired-mode-map "F" 'my-dired-find-file)
     (defun my-dired-find-file (&optional arg)
       "Open each of the marked files, or the file under the point, or when prefix arg, the next N files "
       (interactive "P")
       (let* ((fn-list (dired-get-marked-files nil arg)))
         (mapc 'find-file fn-list)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; bookmarks
;; TODO: do we need this bookmark script ?
(setq
  bookmark-default-file "~/.emacs.d/bookmarks" ;; keep my ~/ clean
  bookmark-save-flag 1)                        ;; autosave each change)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; My only complaint about occur is that it does not let you quickly search a set of buffers that match a specific major
;; mode — arguably a common use case if you’re a programmer. The code seen below will search all open buffers that share
;; the same mode as the active buffer.
(eval-when-compile
  (require 'cl))

(defun get-buffers-matching-mode (mode)
  "Returns a list of buffers where their major-mode is equal to MODE"
  (let ((buffer-mode-matches '()))
   (dolist (buf (buffer-list))
     (with-current-buffer buf
       (if (eq mode major-mode)
           (add-to-list 'buffer-mode-matches buf))))
   buffer-mode-matches))

(defun multi-occur-in-this-mode ()
  "Show all lines matching REGEXP in buffers with this major mode."
  (interactive)
  (multi-occur
   (get-buffers-matching-mode major-mode)
   (car (occur-read-primary-args))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-x b") 'helm-buffers-list)
(global-set-key (kbd "C-c i") 'iedit-mode)
(global-set-key (kbd "C-c h") 'helm-multi-swoop-all)
(global-set-key (kbd "C-c f") 'highlight-symbol-at-point)
(global-set-key [?\C-x ?g] 'point-to-register)
(global-set-key [?\C-x ?j] 'jump-to-register)
(global-set-key [?\C-x ?c] 'copy-to-register)
(global-set-key [?\C-x ?v] 'insert-register)
(global-set-key [?\C-x ?l] 'align-entire)
(global-set-key [?\C-c ?r] 'replace-string)

;; Emacs poses the irritating "yes or no" questions which requires you to type upto 3 full characters!!. You can replace it with a shorter "y or n" prompt.
(fset 'yes-or-no-p 'y-or-n-p)

(defun my-frame-config (frame)
  "Custom behaviours for new frames."
  (with-selected-frame frame
    (when (display-graphic-p)
     ;; hide toolbar
      (tool-bar-mode -1)
    ))
)

;; run now
(my-frame-config (selected-frame))
;; and later
(add-hook 'after-make-frame-functions 'my-frame-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)

(define-key input-decode-map "\e[1;10C" [M-S-right])
(define-key input-decode-map "\e[1;10D" [M-S-left])
(define-key input-decode-map "\e[1;9C" [C-right])
(define-key input-decode-map "\e[1;9D" [C-left])
(load-theme 'zenburn t)

(when (window-system)
(set-frame-font "Source Code Pro")
(set-face-attribute 'default nil :font "Source Code Pro" :height 140)
(set-face-font 'default "Source Code Pro"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; redo+.el provides a linear undo/redo system which is easy to understand for many people.
;;(require 'redo+)
;;(global-set-key (kbd "C-/") 'redo)
;;(setq undo-no-redo t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; FLYSPELL
(require 'flyspell)
;; TODO: for osx only (setq ispell-program-name "/opt/local/bin/aspell")
(setq ispell-program-name "aspell")
;; -C makes aspell accept run-together words
;; --run-together-limit is maximum number of words that can be strung together.
(setq ispell-extra-args '("-C" "--sug-mode=ultra" "--run-together-limit=5"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'uniquify)
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlight FIXME, TODO and BUG keywords
(add-hook 'c-mode-common-hook
          (lambda ()
            (font-lock-add-keywords
             nil '(("\\<\\(FIXME\\|TODO\\|BUG\\||sslusny||@todo||@TODO\\):" 1 font-lock-warning-face t)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; taken from http://www.emacswiki.org/emacs/AutoIndentation
;;  pasted lines are automatically indented:
(dolist (command '(yank yank-pop))
   (eval `(defadvice ,command (after indent-region activate)
            (and (not current-prefix-arg)
                 (member major-mode '(emacs-lisp-mode lisp-mode
                                                      clojure-mode    scheme-mode
                                                      haskell-mode    ruby-mode
                                                      rspec-mode      
                                                      c-mode          c++-mode
                                                      objc-mode       latex-mode
                                                      plain-tex-mode))
                 (let ((mark-even-if-inactive transient-mark-mode))
                   (indent-region (region-beginning) (region-end) nil))))))

;; I had problems with rgrep on my Mac machine. Recursive grep did not work, only grep in current directory.
(setq grep-find-template
      "find . <X> -type f \\( ! -name '*~' \\) -a -type f <F> -print0 | xargs -0 grep <C> --extended-regexp -nH -e <R>")
;; Miscellaneous features
(setq  grep-command "grep -RniI "
       scroll-bar-mode nil
      require-final-newline t)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; compile-again ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; How is that different from M-x recompile?
;; Answer: M-x recompile just executes the last compile command in the directory of the current buffer which
;; can be different from the directory of the compile buffer. So you would have to manually switch to the compile
;; buffer and do compile there. This is what the above command does.
(defun compile-again (pfx)
  """Run the same compile as the last time.

If there was no last time, or there is a prefix argument, this acts like
M-x compile.
"""
 (interactive "p")
 (if (and (eq pfx 1)
    compilation-last-buffer)
     (progn
       (set-buffer compilation-last-buffer)
       (revert-buffer t t))
   (call-interactively 'compile)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; compilation buffer: wrap lines
(defun my-compilation-mode-hook ()
  (save-some-buffers 1)
  (setq truncate-lines nil)
  (setq truncate-partial-width-windows nil)
  (setq compilation-last-buffer nil)
  (setq compilation-scroll-output 'first-error)
  )
(add-hook 'compilation-mode-hook 'my-compilation-mode-hook)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

(add-to-list 'auto-mode-alist '("\\.m\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.mm\\'" . objc-mode))
(add-to-list 'auto-mode-alist '("\\.ipp\\'" . c++-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(autoload 'my-c++-mode-hook "~/.emacs.d/lisp/emacs-my-cc-mode.el" nil t)

(add-hook 'objc-mode-hook 'my-objc-mode-hook)
(autoload 'my-objc-mode-hook "~/.emacs.d/lisp/objc-mode.el" nil t)


;; this would made any value of flycheck-gcc-include-path safe:
;;(put 'flycheck-gcc-include-path 'safe-local-variable (lambda (xx) t))
;;(autoload 'python -mode "~/.emacs.d/lisp/.emacs-python-mode.el" nil t)

;; Tex
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flycheck-mode)

(eval-after-load "flycheck"
  '(progn
     (set-face-background 'flycheck-error "red")
     (set-face-foreground 'flycheck-error "black")
     (set-face-background 'flycheck-warning "orange")
     (set-face-foreground 'flycheck-warning "black")))
