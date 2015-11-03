;; variables that might be worth setting do different values: << START
;; Linux
(set-variable 'ycmd-server-command '("python" "/home/sslusny/tmp/ycmd/ycmd"))
(set-variable 'clang-format-executable '("/usr/bin/clang-format-3.4"))
(add-hook 'my-c++-mode-hook (setq compile-command "./akamake AKAMAKE-LINUX-BUILD-64=1 -j4"))
;(add-hook 'my-c++-mode-hook (setq flycheck-c/c++-gcc-executable "/home/sslusny/compiled/bin/gcc"))
;; OSX
(if (eq system-type 'darwin)
    (progn
      (set-variable 'ycmd-server-command '("python" "/Users/sslusny/Personal/ycmd/ycmd"))
      (set-variable 'clang-format-executable '("/opt/local/bin/clang-format-mp-3.7"))
      (add-hook 'my-c++-mode-hook (setq compile-command "make"))
      )
)
;; variables that might be worth setting do different values: << END

(require 'google-c-style)
(require 'flycheck)
(require 'ycmd)
(require 'company)
(require 'company-ycmd)
(company-ycmd-setup)
(require 'flycheck-ycmd)
(flycheck-ycmd-setup)
(require 'p4)
(require 'whitespace)

;; highlight long lines
(setq whitespace-style '(face indentation trailing empty lines-tail))
(setq whitespace-line-column 80)
(set-face-attribute 'whitespace-line nil
                    :background "purple"
                    :foreground "white"
                    :weight 'bold)

;; Show flycheck errors in idle-mode as well
(setq ycmd-parse-conditions '(save new-line mode-enabled idle-change))

(setq-default mode-line-format
              '("%e" mode-line-front-space
                ;; Standard info about the current buffer
                mode-line-modified
;;                mode-line-remote
;;                mode-line-frame-identification
                mode-line-buffer-identification " " mode-line-position
                ;; Some specific information about the current buffer:
;;                (vc-mode lunaryorn-vc-mode-line) ; VC information
;;                (flycheck-mode flycheck-mode-line) ; Flycheck status
                " "
                mode-line-misc-info
                ;; And the modes, which I don't really care for anyway
                " " mode-line-modes mode-line-end-spaces))

(defun my-c++-mode-hook ()
  (google-set-c-style)
  (google-make-newline-indent)
  (setq-default c-basic-offset 2)
  (setq-default indent-tabs-mode nil)
  (setq ycmd-extra-conf-handler 'load)  
  (flyspell-mode 1)
  (add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode)
  (flycheck-mode)
  (ycmd-mode)
  (exec-path-from-shell-initialize) ;; this is required on OSX to find "global" executable
  (company-mode)
  (setq company-idle-delay 2)
  (which-function-mode)
  (whitespace-mode)
  (local-set-key [\C-ck] 'kill-compilation)
  (local-set-key [\C-/] 'comment-or-uncomment-line-or-region)
  (local-set-key (kbd "M-p") 'flycheck-previous-error)
  (local-set-key (kbd "M-n") 'flycheck-next-error)
  (local-set-key [(control c) (c)] 'compile-again)
  (local-set-key "\C-ct" 'ff-get-other-file)
  (local-set-key "\C-cz" 'company-complete)
  (local-set-key "\M-." 'ycmd-goto)
  ;;(local-set-key (kbd "C-c z") 'ace-jump-mode)
  )					; my-c++-mode-hook

(define-key c-mode-base-map (kbd "C-c c") (function compile-again))

;; (global-set-key [\C-/] 'comment-or-uncomment-line-or-region)
;; (require 'yasnippet)

