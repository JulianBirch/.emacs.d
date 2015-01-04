

(setenv "PATH" (concat (getenv "PATH") ":/home/julian/local/bin"))
(setq exec-path (append exec-path '(":/home/julian/local/bin")))

(setq shm-program-name "/home/julian/local/bin/structured-haskell-mode")

                                        ; Set up marmalade

(require 'package)
(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/") t)
; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(defvar my-packages '(better-defaults
                      paredit ; paren magic
                      idle-highlight-mode ; show other instances
                                          ; of current identifier
                      ido-ubiquitous
                      smex                ; auto-complete on M-x
                                          ; and more
                      find-file-in-project
                      magit ; git support
                      scpaste ; Kind of blogging support
                      cyberpunk-theme ; colours
                      company ; autocomplete flavour of month
                      exec-path-from-shell ; no more manual path mapping in emacs
                      ))

(defvar configs
  '("global"
    "haskell")
  "Configuration files that follow the config/foo.el file path
  format.)")

(defvar load-paths
  '("structured-haskell-mode/elisp"
    "haskell-mode")
  "Custom for stuff that doesn't work through package management.")

(setq package-check-signature nil)

(package-initialize)
(dolist (package my-packages)
  (if (package-installed-p package)
    (message "Package '%s' is installed." package)
    (progn ; progn is the equivalent of do
      (message "Installing package '%s'." package)
      (package-install package))))

(load-theme 'cyberpunk t)



(message "Load custom modules")

(cl-loop for location in load-paths
         do (add-to-list 'load-path
                         (concat (file-name-directory (or load-file-name
                                                          (buffer-file-name)))
                                 "modules/"
                                 location)))

(add-to-list 'load-path "~/.cabal/structured-haskell-mode/.cabal-sandbox/share/x86_64-linux-ghc-7.8.2/hindent-3.9.1/elisp") ; HACK, how else do I track it down?

; (message "Load hindent")

; (load "~/.cabal/structured-haskell-mode/.cabal-sandbox/share/x86_64-linux-ghc-7.8.2/hindent-3.9.1/elisp/hindent.el") ; HACK, how else do I track it down?



(require 'shm) ; Structured Haskell Mode
(require 'hindent) ; Haskell Indent
(require 'shm-case-split)
(require 'shm-reformat)

(message "Load config files")

; Run the config files
(cl-loop for name in configs
         do (let ((f (concat (file-name-directory (or load-file-name (buffer-file-name)))
                          "config/"
                          name ".el")))
              (message (concat "Loading file " f))
              (load f)))

(smex-initialize)
(turn-on-haskell-simple-indent)
(load "haskell-mode-autoloads.el")
