(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages
  '(
    haskell-mode
    magit
    starter-kit
    starter-kit-bindings
    starter-kit-eshell
    starter-kit-lisp
    unbound
    clojure-mode
    )
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;; Remove line-highlighting.
(remove-hook 'prog-mode-hook 'esk-turn-on-hl-line-mode)

;;; This is what I added after org mode was'nt highlighting, etc.
;; The following lines are always needed.  Choose your own keys.
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
     (add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when
                                        ; global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;; Peters additions.
(define-skeleton org-mode-src-skel
  "Insert #+BEGIN_SRC <source>...#+END_SRC blocks."
  "Source: "
  >
  "#+BEGIN_SRC " str
  \n
  _
  \n
  "#+END_SRC"
  > \n)

(define-skeleton org-mode-example-skel
  "Insert #+BEGIN_EXAMPLE...#+END_EXAMPLE blocks."
  nil
  >
  "#+BEGIN_EXAMPLE"
  \n
  _
  \n
  "#+END_EXAMPLE"
  > \n)

(define-skeleton org-mode-quote-skel
  "Insert #+BEGIN_QUOTE...#+END_QUOTE blocks."
  nil
  >
  "#+BEGIN_QUOTE"
  \n
  _
  \n
  "#+END_QUOTE"
  > \n)

(add-hook
 'org-mode-hook
 (lambda ()
    (define-key org-mode-map (kbd "C-c C-x C-s") 'org-mode-src-skel)
    (define-key org-mode-map (kbd "C-c C-x C-q") 'org-mode-quote-skel)
    (define-key org-mode-map (kbd "C-c C-x C-e") 'org-mode-example-skel)))

;;; Hitting return opens link in browser.
(setq org-return-follows-link t)

;;; org-mode statuses
(setq org-todo-keywords
      '((sequence "TODO(t)" "|" "DONE(d)" "CANCELED(c)")))

;;; Allows you to set a note when switching from TODO to DONE.
(setq org-log-done 'note)

;;; Evaluate whole Scheme buffer.
(defun scheme-send-buffer ()
  "Just send the goddamn thing."
  (interactive)
  (scheme-send-region (point-min) (point-max)))

(defun scheme-send-buffer-and-go ()
  "Send and go."
  (interactive)
  (scheme-send-buffer)
  (switch-to-buffer-other-window "*scheme*"))

(setq scheme-program-name "csi -n")

(add-hook
 'scheme-mode-hook
 (lambda ()
   (define-key scheme-mode-map (kbd "C-c b") 'scheme-send-buffer)
   (define-key scheme-mode-map (kbd "C-c B") 'scheme-send-buffer-and-go)))

;;;;;; mini-kanren
(put 'run 'scheme-indent-function 1)
(put 'run* 'scheme-indent-function 1)
(put 'fresh 'scheme-indent-function 1)

;;; Unification (i.e. "identical to" as goal)
(font-lock-add-keywords
 'scheme-mode
 '(("(\\(==\\)\\>"
    (0 (prog1 ()
         (compose-region (match-beginning 1)
                         (match-end 1)
                         ?≡))))))

;;; Answer yes-or-no questions with <return>.
(define-key query-replace-map (kbd "C-m") 'act)

;;; When doing a M-x compile see the end of the buffer.
(setq compilation-scroll-output 1)

;;; Keyboard shortcuts
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c R") 'recompile)

;;; Hack to disable flyspell, which was freezing up when writing e.g.
;;; git commit-comments.
(eval-after-load "flyspell"
  '(defun flyspell-mode (&optional arg)))

(setq inferior-lisp-program "/usr/bin/clisp")

(setq visible-bell nil)
