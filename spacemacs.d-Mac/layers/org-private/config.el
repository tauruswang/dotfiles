
(with-eval-after-load 'org

  ;; Display preferences
  (setq org-ellipsis "⤵")
  ;; Make TAB act as if it were issued in a buffer of the language's major mode.
  (setq org-src-tab-acts-natively t)
  ;; When editing a code snippet, use the current window rather than popping open a
  ;; new one (which shows the same information).
  (setq org-src-window-setup 'current-window)
  ;; Quickly insert a block of elisp or python:
  (add-to-list 'org-structure-template-alist
               '("el" "#+BEGIN_SRC elisp\n?\n#+END_SRC")
               )


  ;; Task and org-capture management
  (setq org-directory "~/org")

  (defun org-file-path (filename)
    "Return the absolute address of an org file, given its relative name."
    (concat (file-name-as-directory org-directory) filename)
    )

  (setq org-index-file (org-file-path "index.org"))
  (setq org-archive-location
        (concat (org-file-path "archive.org") "::* From %s"))

  ;; Derive my agenda from org-index-file, where all my todos are in.
  (setq org-agenda-files (list
                          org-directory))

  ;; Hitting 'C-c C-x C-s' will mark a todo as done and move it to an appropriate
  ;; place in the archive
  (defun hrs/mark-done-and-archive ()
    "Mark the state of an org-mode item as DONE and archive it."
    (interactive)
    (org-todo 'done)
    (org-archive-subtree))

  (define-key org-mode-map (kbd "C-c C-x C-s") 'hrs/mark-done-and-archive)

  ;; Set todo-keywords
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "STARTED(s)"
           "WAITING(w@/!)"
           "|" "DONE(x!)" "CANCELLED(c@)")))

  (setq org-todo-keyword-faces
        '(
          ("WAITING" . (:foreground "red" :weight bold))
          ("STARTED" . (:foreground "green" :weight bold))))

  ;; Capturing tasks
  (setq org-capture-templates
        '(("b" "Blog idea"
           entry
           (file (org-file-path "blog-ideas.org"))
           "* TODO %?\n")

          ("f" "Finished book"
           table-line
           (file (org-file-path "books-read.org"))
           "| %^{Title} | %^{Author} | %u |")

          ("g" "Groceries"
           checkitem
           (file (org-file-path "groceries.org")))

          ("l" "Today I Learned..."
           entry
           (file+datetree (org-file-path "til.org"))
           "* %?\n")

          ("j" "Journal"
           entry
           (file+datetree (org-file-path "journal.org"))
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("n" "Note"
           entry
           (file (org-file-path "note.org"))
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("t" "Trade"
           entry
           (file+headline (org-file-path "trade.org") "Inbox")
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("p" "Poker"
           entry
           (file+headline (org-file-path "poker.org") "Inbox")
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("r" "Subscribe to an RSS feed"
           plain
           (file "~/org/rss/urls")
           "%^{Feed URL} \"~%^{Feed name}\"")

          ("c" "Code Snippet" entry
           (file (org-file-path "snippet.org"))
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")

          ("i" "Index"
           entry
           (file+headline org-index-file "Inbox")
           "* TODO %?\n\tCaptured %U")))

  (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; Reliling
  (setq org-refile-targets (quote ((nil :maxlevel . 3)
                                   (org-agenda-files :maxlevel . 3))))

  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  ;; 自动换行
  (add-hook 'org-mode-hook
            (lambda () (setq truncate-lines nil)))

  ;; log
  (setq org-log-into-drawer t)

  ;; Publish
  (setq org-publish-project-alist
        '(("orgfiles"
            :base-directory "~/org/"
            :base-extension "org"
            :publishing-directory "~/Dropbox/org_publish/"
            :publishing-function org-html-publish-to-html
            :exclude "login.org"   ;; regexp
            :headline-levels 3
            :section-numbers nil
            :with-toc nil
            :auto-sitemap t
            :sitemap-title "Sitemap"
            :html-preamble t)

          ("images"
            :base-directory "~/org/images/"
            :base-extension "jpg\\|gif\\|png"
            :publishing-directory "~/Dropbox/org_publish/images/"
            :publishing-function org-publish-attachment)

          ("other"
            :base-directory "~/org/other/"
            :base-extension "css\\|el\\|setup"
            :publishing-directory "~/Dropbox/org_publish/other/"
            :publishing-function org-publish-attachment)
          ("website" :components ("orgfiles" "images" "other"))))
  )
