
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
               '("el" "#+BEGIN_SRC elisp\n?\n#+END_SRC"))
  (add-to-list 'org-structure-template-alist
               '("week" "#+BEGIN: clocktable :maxlevel 2 :scope agenda-with-archives :block thisweek :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("today" "#+BEGIN: clocktable :maxlevel 2 :scope agenda-with-archives :block today :formula % :link t :fileskip0\n#+END:"))

  ;; Task and org-capture management
  (setq org-directory "~/ownCloud/org")

  (defun org-file-path (filename)
    "Return the absolute address of an org file, given its relative name."
    (concat (file-name-as-directory org-directory) filename)
    )

  (setq org-index-file (org-file-path "index.org"))

  ;; Derive my agenda from org-index-file, where all my todos are in.
  (setq org-agenda-files (list
                          org-directory))

  ;; Capturing tasks
  (setq org-capture-templates
        '(
          ("f" "Finished book"
           table-line
           (file (org-file-path "books-read.org"))
           "| %^{Title} | %^{Author} | %u |")

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

          ("d" "Daily Plan & Review"
           entry
           (file+datetree (org-file-path "dailyplan.org"))
           "* %?\n")

          ("r" "Subscribe to an RSS feed"
           plain
           (file "~/ownCloud/org/rss/urls")
           "%^{Feed URL} \"~%^{Feed name}\"")

          ("c" "Code Snippet" entry
           (file (org-file-path "snippet.org"))
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")

          ("i" "Index"
           entry
           (file+headline org-index-file "Inbox")
           "* %?\n\tCaptured %U")))

  (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; Reliling
  (setq org-refile-targets (quote ((nil :maxlevel . 3)
                                   (org-agenda-files :maxlevel . 3))))

  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-allow-creating-parent-nodes 'confirm)

  ;; custom agenda view
  (setq org-agenda-custom-commands
        '(("i" "Tasks Focus Now"
           ((agenda "")
            (tags "URGENT")
            (todo "NEXT")
            (todo "SHORT")))
          ("o" "Agenda and Office-related tasks"
           ((agenda "")
            (todo "work")
            (tags "office")))))

  ;; 自动换行
  (add-hook 'org-mode-hook
            (lambda () (setq truncate-lines nil)))

  ;; log
  (setq org-log-into-drawer t)

  ;; clock
  (setq spaceline-org-clock-p t)

  ;; Publish
  (setq org-publish-project-alist
        '(("orgfiles"
            :base-directory "~/ownCloud/org/"
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
            :base-directory "~/ownCloud/org/images/"
            :base-extension "jpg\\|gif\\|png"
            :publishing-directory "~/Dropbox/org_publish/images/"
            :publishing-function org-publish-attachment)

          ("other"
            :base-directory "~/ownCloud/org/other/"
            :base-extension "css\\|el\\|setup"
            :publishing-directory "~/Dropbox/org_publish/other/"
            :publishing-function org-publish-attachment)
          ("website" :components ("orgfiles" "images" "other"))))
  )
