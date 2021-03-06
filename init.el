
;; set the right path for aquamacs
;;(setq user-emacs-directory "~/.emacs.d/")

;; load the package manager
(require 'package)

;; add the MELPA respository to the package archive
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/") t)


;; add color theme load path
(add-to-list 'custom-theme-load-path
	     "~/.emacs.d/non-elpa/emacs-color-theme-solarized/")

;; load and activate packages
(package-initialize)

;; use the solarized color
;; (set 'color-theme-current 'dark)
;;(load-theme 'solarized-dark t)
;; THIS BIT WORKED FOR ITERM
(load-theme 'solarized t)
(set 'frame-background-mode 'dark)
;;(require 'solarized-theme)
;;(load-theme 'solarized-dark t)


;; require org-mode
(require 'org)

;; get the vim bindings
(require 'evil)
(evil-mode t)

;; AUCTex support
;;(load "auctex.el" nil t t)
(require 'auto-complete)
(require 'auto-complete-config)
(setq ac-auto-show-menu nil)
(ac-set-trigger-key "TAB")

;;(autoload 'latex-mode "auto-complete-auctex" nil t)
(ac-config-default)
;;(ac-flyspell-workaround)

(require 'ac-math)
(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of `latex-mode`

(defun ac-LaTeX-mode-setup () ; add ac-sources to default ac-sources
   (setq ac-sources
         (append '(ac-source-math-latex ac-source-latex-commands)
                 ac-sources))
   )
(add-hook 'LaTeX-mode-hook 'ac-LaTeX-mode-setup)
(global-auto-complete-mode t)

;; AucTeX
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(setq TeX-PDF-mode t)

;; python/anaconda
(add-hook 'python-mode-hook 'anaconda-mode)

;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)

;; so we can find latexmk and pdflatex
(setq exec-path (append exec-path '("/usr/texbin")))
(setq exec-path (append exec-path '("/usr/local/bin")))

(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk" "latexmk -pvc -pdf %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk")))

(add-hook 'LaTeX-mode-hook (lambda ()
  (push
    '("latexmk-ps" "latexmk -pvc -pdfps %s" TeX-run-TeX nil t
      :help "Run latexmk on file")
    TeX-command-list)))
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "latexmk-ps")))
;; use Skim as default pdf viewer
;; Skim's displayline is used for forward search (from .tex to .pdf)
;; option -b highlights the current line; option -g opens Skim in the background  
(setq TeX-view-program-selection '((output-pdf "PDF Viewer")))
(setq TeX-view-program-list
     '(("PDF Viewer" "/Applications/Skim.app/Contents/SharedSupport/displayline -b -g %n %o %b")))

(server-start); start emacs in server mode so that skim can talk to it

;; snippets!!! 
(require 'yasnippet)
(yas-global-mode t)

(setq yas-snippet-dirs
      '("~/.emacs.d/elpa/yasnippet-20150415.1554/snippets"        ;; default collection
	"~/.emacs.d/snippets"                                     ;; personal collection
	))

(add-hook 'term-mode-hook (lambda()
			    (setq yas-dont-activate t)))

;; get powerline code
;;(require 'powerline)
(require 'powerline-evil)
(powerline-evil-center-color-theme)

;; load ess for emacs to play nice with R, Julia, etc.
(autoload 'ess-mode "ess-site" nil t)
(define-key ac-completing-map (kbd "M-h") 'ac-quick-help)

(require 'r-autoyas)
(add-hook 'ess-mode-hook 'r-autoyas-ess-activate)

;; add polymodes for .Rmd support
(require 'poly-R)
(require 'poly-markdown)

;; automatically enter mode for some common file types (.md,.Snw,.Rnw,.Rmd)
;;; MARKDOWN
(add-to-list 'auto-mode-alist '("\\.md" . poly-markdown-mode))

;;; R modes
(add-to-list 'auto-mode-alist '("\\.Snw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rnw" . poly-noweb+r-mode))
(add-to-list 'auto-mode-alist '("\\.Rmd" . poly-markdown+r-mode))

;; get terminal support inside of emacs
(setq system-uses-terminfo nil)
(require 'multi-term)
(setq multi-term-program "/bin/zsh")
(add-hook 'term-mode-hook
          (lambda ()
            (setq term-buffer-maximum-size 10000)))

;; for easy switching between solarized light and dark
;;(global-set-key (kbd "<f5>") (lambda () (interactive)
;;   (if (string= 'dark color-theme-current)
;;       (progn (load-theme 'solarized-light t)
;;               (set 'color-theme-current 'light))
;;        (progn (load-theme 'solarized-dark t)
;;               (set 'color-theme-current 'dark)))))


 (defun swap-theme () (interactive)
        (if (string= 'dark frame-background-mode)
 	   (progn (set 'frame-background-mode 'light)
 		  (mapcar 'frame-set-background-mode (frame-list)))
 	 (progn (set 'frame-background-mode 'dark)
 		(mapcar 'frame-set-background-mode (frame-list))))
 )

(global-set-key (kbd "<f5>") (lambda () (interactive) (swap-theme) (enable-theme 'solarized)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-delay 0.5)
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(ess-swv-processor (quote knitr)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
