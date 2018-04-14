
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
               '("month" "#+BEGIN: clocktable :maxlevel 3 :scope agenda-with-archives :block lastmonth :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("week" "#+BEGIN: clocktable :maxlevel 3 :scope agenda-with-archives :block lastweek :wstart 7 :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("today" "#+BEGIN: clocktable :maxlevel 3 :scope agenda-with-archives :block today :formula % :link t :fileskip0\n#+END:"))
  (add-to-list 'org-structure-template-alist
               '("title" "#+TITLE: ?\n#+SETUPFILE: ./other/theme-bigblow.setup\n#+STARTUP: lognotereschedule\n\n"))

  ;; Task and org-capture management
  (setq org-directory "~/Nextcloud/org")
  (setq org-brain-path "~/Nextcloud/org/brain")

  (setq org-plantuml-jar-path
        (expand-file-name "~/plantuml.jar"))

  (defun org-file-path (directory filename)
    "Return the absolute address of an org file, given its relative name."
    (concat (file-name-as-directory directory) filename)
    )

  (setq org-index-file (org-file-path org-directory "index.org"))

  ;; Derive my agenda from org-index-file, where all my todos are in.
  (setq org-agenda-files org-index-file)

  ;; Capturing tasks
  (setq org-capture-templates
        '(
          ("l" "Today I Learned..."
           entry
           (file+olp+datetree "~/Nextcloud/org/til.org")
           "* %?\n")

          ("j" "Journal"
           entry
           (file+olp+datetree "~/Nextcloud/org/journal.org")
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("t" "Trade Journal"
           entry
           (file+olp+datetree "~/Nextcloud/org/trade_journal.org")
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("n" "Note"
           entry
           (file "~/Nextcloud/org/note.org")
           "* %^{Brief Description} %^g\n%?\n\tCaptured %U")

          ("r" "Review"
           entry
           (file+olp+datetree "~/Nextcloud/org/review.org")
           "* %?\n")

          ("c" "Code Snippet" entry
           (file "~/Nextcloud/org/snippet.org")
           "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")

          ("w" "English Word"
           entry
           (file+headline "~/Nextcloud/org/english.org" "Words")
           "* %?\n\tCaptured %U\n \t%a")

          ("b" "Brain" plain (function org-brain-goto-end)
           "* %i%?" :empty-lines 1)

          ("g" "GTD"
           entry
           (file+headline "~/Nextcloud/org/gtd.org" "Inbox")
           "* %?\n\tCaptured %U\n \t%a")))

  (add-hook 'org-capture-mode-hook 'evil-insert-state)

  ;; Refiling
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
            (todo "DOING")))
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

  ;; Not show further repetitions
  (setq org-agenda-repeating-timestamp-show-all nil)

  ;; Publish
  (setq org-publish-project-alist
        '(("orgfiles"
            :base-directory "~/Nextcloud/org/"
            :base-extension "org\\|md"
            :publishing-directory "~/Nextcloud/org_publish/"
            :publishing-function org-html-publish-to-html
            :exclude "login.org"   ;; regexp
            :headline-levels 3
            :section-numbers nil
            :with-toc nil
            :auto-sitemap t
            :sitemap-title "Sitemap"
            :recursive t
            :html-preamble t)

          ("images"
            :base-directory "~/Nextcloud/org/images/"
            :base-extension "jpg\\|gif\\|png"
            :publishing-directory "~/Nextcloud/org_publish/images/"
            :publishing-function org-publish-attachment)

          ("other"
            :base-directory "~/Nextcloud/org/other/"
            :base-extension "css\\|el\\|setup"
            :publishing-directory "~/Nextcloud/org_publish/other/"
            :publishing-function org-publish-attachment)
          ("website" :components ("orgfiles" "images" "other"))))
  )
