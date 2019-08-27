(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq-default package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
        (package-refresh-contents)
        (package-install 'use-package)
)

; Tell with-editor about Nix's emacsclient. This needs to happen before the
; package starts up.
(setq-default with-editor-emacsclient-executable
              (format "%s/.nix-profile/bin/emacsclient" (getenv "HOME"))
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
(use-package frame-fns
             :quelpa (frame-fns :fetcher github :repo "emacsmirror/frame-fns")
)
(use-package frame-cmds
             :quelpa (frame-cmds :fetcher github :repo "emacsmirror/frame-cmds")
)
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
(setq-default fill-column 80)
(global-column-enforce-mode t)

; Show matching parens:
(setq-default show-paren-delay 0)
(show-paren-mode 1)

; Show line numbers.
(global-display-line-numbers-mode)

; When graphical, use leuven, visual whitespace, bind frame zoom.
(when (display-graphic-p)
      (progn (global-whitespace-mode)
             (setq-default whitespace-style
                           '( face
                              trailing
                              tabs
                              ;spaces
                              lines
                              newline
                              empty
                              ;big-indent
                              ;space-mark
                              tab-mark
                              newline-mark
                            )
             )
             (load-theme 'leuven)
             (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
             (global-set-key (kbd "C-+") 'zoom-all-frames-in)
             (global-set-key (kbd "C--") 'zoom-all-frames-out)
      )
)

; We need to login in a funky way and turn on the menu bar on macOS.
(when (eq system-type 'darwin)
      (progn (setq-default explicit-shell-file-name "/usr/bin/login")
             (setq-default explicit-login-args `("-fp" ,(getenv "USER") "bash"))
             (menu-bar-mode 1)
      )
)

; Add Nix profile to exec path; emacs doesn't know about bashrc.
(setenv "PATH" (concat (format "%s/.nix-profile/bin:" (getenv "HOME"))
                       (getenv "PATH")
               )
)
(setq-default exec-path
              (cons (format "%s/.nix-profile/bin" (getenv "HOME"))
                    exec-path
              )
)

; Markkdown stuff:
(setq-default markdown-command "pandoc")

(setq ispell-program-name "aspell")
(setq ispell-extra-args '("--sug-mode=ultra" "--lang=en"))

; Haskell stuff:
(require 'haskell-interactive-mode)
(require 'haskell-process)
(setq-default haskell-tags-on-save t)
(setq-default haskell-process-type 'cabal-new-repl)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
; These should be default, not sure why they're missing...
(define-key haskell-mode-map
            (kbd "M-n")
            'haskell-goto-next-error
)
(define-key haskell-mode-map
            (kbd "M-p")
            'haskell-goto-prev-error
)
(define-key haskell-mode-map
            (kbd "C-c M-p")
            'haskell-goto-first-error
)

; Cmm stuff:
(add-to-list 'auto-mode-alist '("\\.cmm\\'" . c-mode))

(setq-default haskell-indentation-layout-offset 4)
(setq-default haskell-indentation-left-offset 4)
(setq-default haskell-indentation-starter-offset 4)
(setq-default haskell-indentation-where-pre-offset 4)
(setq-default haskell-indentation-where-post-offset 6)
(setq-default haskell-indentation-electric-flag nil)

; Org mode stuff:
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
