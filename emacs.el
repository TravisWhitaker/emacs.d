(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/")
)

(setq-default package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package)
)

(use-package evil :ensure t)
(use-package general :ensure t)
(use-package haskell-mode :ensure t)
(use-package nix-mode :ensure t :mode "\\.nix\\'")
(use-package column-enforce-mode :ensure t)
(use-package rainbow-delimiters :ensure t)
(use-package markdown-mode :ensure t :mode "\\.md\\'")
(use-package dhall-mode :ensure t :mode "\\.dhall\\'")
(use-package org :ensure t)
(use-package magit :ensure t)
(use-package quelpa :ensure t)
(use-package quelpa-use-package :ensure t)
(use-package zoom-frm
             :quelpa (zoom-frm :fetcher github :repo "emacsmirror/zoom-frm")
)

; No tool bar or menu bar:
(tool-bar-mode -1)
(menu-bar-mode -1)

; Make it vim:
(evil-mode t)
(general-evil-setup)

; kj -> <Esc>
(general-imap "k"
              (general-key-dispatch 'self-insert-command
                                    "j"
                                    'evil-normal-state
              )
)

; No tabs:
(setq-default indent-tabs-mode nil)

; Delete trailing whitespace on save:
(add-hook 'before-save-hook 'delete-trailing-whitespace)

; Enforce 80 columns:
(global-column-enforce-mode t)

; Show matching parens:
(setq-default show-paren-delay 0)
(show-paren-mode 1)

; Show line numbers.
(global-display-line-numbers-mode)

; When graphical, use leuven, visual whitespace, bind frame zoom.
(when (display-graphic-p)
      (progn (global-whitespace-mode)
             (load-theme 'leuven)
             (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
             (global-set-key (kbd "C-+") 'zoom-all-frames-in)
             (global-set-key (kbd "C--") 'zoom-all-frames-out)
      )
)

; On macOS, use menu bar, /usr/bin/login as the shell:
(when (eq system-type 'darwin)
      (progn (setq-default explicit-shell-file-name "/usr/bin/login")
             (setq-default explicit-login-args '("-fp" "traviswhitaker" "bash"))
             (menu-bar-mode 1)
      )
)

; Add Nix profile to exec path; emacs doesn't know about bashrc.
(setenv "PATH" (concat "/Users/traviswhitaker/.nix-profile/bin:"
                       (getenv "PATH")
               )
)
(setq-default exec-path (cons "/Users/traviswhitaker/.nix-profile/bin"
                              exec-path
                        )
)

; Markkdown stuff:
(setq-default markdown-command "pandoc")

; Haskell stuff:
(require 'haskell-interactive-mode)
(require 'haskell-process)
(setq-default haskell-tags-on-save t)
(setq-default haskell-process-type 'cabal-repl)
(add-hook 'haskell-mode-hook #'interactive-haskell-mode)
;; It's baffling, but it seems this hook _and_ eval-after-mode must be
;; present for this to be set in the map...
(add-hook 'haskell-mode-hook '(define-key 'haskell-mode-map
                                          (kbd "C-c C-c")
                                          'haskell-compile
                              )
)
(eval-after-load 'haskell-mode
  '(define-key haskell-mode-map
     (kbd "C-c C-c")
     'haskell-compile)
)
(setq-default haskell-indentation-layout-offset 4)
(setq-default haskell-indentation-left-offset 4)
(setq-default haskell-indentation-starter-offset 4)
(setq-default haskell-indentation-where-pre-offset 4)
(setq-default haskell-indentation-where-post-offset 6)
(setq-default haskell-indentation-electric-flag nil)


(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

; Tell with-editor about Nix's emacsclient, need to change this
; depending on how the machine is setup...
(setq-default with-editor-emacsclient-executable
              "/Users/traviswhitaker/.nix-profile/bin/emacsclient"
)
