;;; packages.el --- zilong-ui layer packages file for Spacemacs.
;;
;; Copyright (c) 2014-2016 zilongshanren
;;
;; Author: guanghui <guanghui8827@gmail.com>
;; URL: https://github.com/zilongshanren/spacemacs-private
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Code:

(defconst zilongshanren-org-packages
  '(
    (org :location built-in)
    org-mac-link
    deft
    )
)

;;In order to export pdf to support Chinese, I should install Latex at here: https://www.tug.org/mactex/
;; http://freizl.github.io/posts/2012-04-06-export-orgmode-file-in-Chinese.html
;;http://stackoverflow.com/questions/21005885/export-org-mode-code-block-and-result-with-different-styles
(defun zilongshanren-org/post-init-org ()
  (add-hook 'org-mode-hook (lambda () (spacemacs/toggle-line-numbers-off)) 'append)
  (with-eval-after-load 'org
    (progn

      (spacemacs|disable-company org-mode)
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "," 'org-priority)
      (require 'org-compat)
      (require 'org)
      (add-to-list 'org-modules 'org-habit)
      (require 'org-habit)

      (setq org-refile-use-outline-path 'file)
      (setq org-outline-path-complete-in-steps nil)
      (setq org-refile-targets
            '((nil :maxlevel . 4)
              (org-agenda-files :maxlevel . 4)))
      ;; config stuck project
      (setq org-stuck-projects
            '("TODO={.+}/-DONE" nil nil "SCHEDULED:\\|DEADLINE:"))

      (setq org-agenda-inhibit-startup t) ;; ~50x speedup
      (setq org-agenda-span 'day)
      (setq org-agenda-use-tag-inheritance nil) ;; 3-4x speedup
      (setq org-agenda-window-setup 'current-window)
      (setq org-log-done t)

      (setq org-todo-keywords
            (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
                    (sequence "WAITING(w@/!)" "SOMEDAY(S)" "|" "CANCELLED(c@/!)" "MEETING(m)" "PHONE(p)"))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      ;; Org clock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

      ;; Change task state to STARTED when clocking in
      (setq org-clock-in-switch-to-state "STARTED")
      ;; Save clock data and notes in the LOGBOOK drawer
      (setq org-clock-into-drawer t)
      ;; Removes clocked tasks with 0:00 duration
      (setq org-clock-out-remove-zero-time-clocks t) ;; Show the clocked-in task - if any - in the header line

      (setq org-tags-match-list-sublevels nil)

      (add-hook 'org-mode-hook '(lambda ()
                                  ;; keybinding for editing source code blocks
                                  ;; keybinding for inserting code blocks
                                  (local-set-key (kbd "C-c i s")
                                                 'zilongshanren/org-insert-src-block)))

      ;; define the refile targets
      (setq org-agenda-file-note (expand-file-name "notes.org" org-agenda-dir))
      (setq org-agenda-file-gtd (expand-file-name "gtd.org" org-agenda-dir))
      (setq org-agenda-file-journal (expand-file-name "journal.org" org-agenda-dir))
      (setq org-agenda-file-code-snippet (expand-file-name "snippet.org" org-agenda-dir))
      (setq org-default-notes-file (expand-file-name "gtd.org" org-agenda-dir))
      (setq org-agenda-files (list org-agenda-dir))

      (with-eval-after-load 'org-agenda
        (define-key org-agenda-mode-map (kbd "P") 'org-pomodoro)
        (spacemacs/set-leader-keys-for-major-mode 'org-agenda-mode
          "." 'spacemacs/org-agenda-transient-state/body)
        )
      ;; the %i would copy the selected text into the template
      ;;http://www.howardism.org/Technical/Emacs/journaling-org.html
      ;;add multi-file journal

      ;; template related code mainly from sacha's config
      (defun my/org-contacts-template-email (&optional return-value)
        "Try to return the contact email for a template.
      If not found return RETURN-VALUE or something that would ask the user."
        (or (cadr (if (gnus-alive-p)
                      (gnus-with-article-headers
                        (mail-extract-address-components
                         (or (mail-fetch-field "Reply-To") (mail-fetch-field "From") "")))))
            return-value
            (concat "%^{" org-contacts-email-property "}p")))


      (defvar my/org-basic-task-template "* TODO %^{Task}
    :PROPERTIES:
    :Effort: %^{effort|1:00|0:05|0:15|0:30|2:00|4:00}
    :END:
    Captured %<%Y-%m-%d %H:%M>
    %?

    %i
    " "Basic task data")
      (setq org-capture-templates
            `(("t" "Tasks" entry
               (file+headline org-agenda-file-gtd "Inbox")
               ,my/org-basic-task-template
               :empty-lines 1)
              ("T" "Quick task" entry
               (file+headline org-agenda-file-gtd "Inbox")
               "* TODO %^{Task}\nSCHEDULED: %t\n"
               :immediate-finish t
               :empty-lines 1)
              ("i" "Interrupting task" entry
               (file+headline org-agenda-file-gtd "Inbox")
               "* STARTED %^{Task}"
               :clock-in :clock-resume
               :empty-lines 1)
              ("j" "Journal entry" entry
               (file+datetree org-agenda-file-journal)
               "%K - %a\n%i\n%^g\n%?\n"
               :unnarrowed t)
              ("J" "Journal entry with date" entry
               (file+datetree+prompt org-agenda-file-journal)
               "%K - %a\n%i\n%^g\n%?\n"
               :unnarrowed t)
              ("s" "Journal entry with date, scheduled" entry
               (file+datetree+prompt org-agenda-file-journal)
               "* \n%K - %a\n%t\t%i\n%?\n"
               :unnarrowed t)
              ("q" "Quick note" entry
               (file+headline org-agenda-file-note "Quick notes")
               "* %?\n %i\n %U"
               :empty-lines 1)
              ("c" "Code Snippet" entry
               (file org-agenda-file-code-snippet)
               "* %?\t%^g\n#+BEGIN_SRC %^{language}\n\n#+END_SRC")
              ("B" "Book" entry
               (file+datetree "~/org/books.org" "Inbox")
               "* %^{Title}  %^g
      %i
      *Author(s):* %^{Author} \\\\
      *ISBN:* %^{ISBN}

      %?

      *Review on:* %^t \\
      %a
      %U"
               :clock-in :clock-resume)
               ("C" "Contact" entry (file "~/org/contacts.org")
                "* %(org-contacts-template-name)
      :PROPERTIES:
      :EMAIL: %(my/org-contacts-template-email)
      :END:")
               ))


      ;;An entry without a cookie is treated just like priority ' B '.
      ;;So when create new task, they are default
      (setq org-agenda-custom-commands
            '(
              ("w" . "任务安排")
              ("wa" "重要且紧急的任务" tags-todo "+PRIORITY=\"A\"")
              ("wb" "重要且不紧急的任务" tags-todo "-Weekly-Monthly-Daily+PRIORITY=\"B\"")
              ("wc" "不重要且紧急的任务" tags-todo "+PRIORITY=\"C\"")
              ("b" "Blog" tags-todo "BLOG")
              ("p" . "项目安排")
              ("pw" tags-todo "PROJECT+WORK+CATEGORY=\"cocos2d-x\"")
              ("pl" tags-todo "PROJECT+DREAM+CATEGORY=\"zilongshanren\"")
              ("W" "Weekly Review"
               ((stuck "") ;; review stuck projects as designated by org-stuck-projects
                (tags-todo "PROJECT") ;; review all projects (assuming you use todo keywords to designate projects)
                ))))

      (add-hook 'org-after-todo-statistics-hook 'zilong/org-summary-todo)
      ;; used by zilong/org-clock-sum-today-by-tags

      (define-key org-mode-map (kbd "s-p") 'org-priority)
      (spacemacs/set-leader-keys-for-major-mode 'org-mode
        "tl" 'org-toggle-link-display)
      (define-key evil-normal-state-map (kbd "C-c C-w") 'org-refile)
      )))

(defun zilongshanren-org/init-org-mac-link ()
  (use-package org-mac-link
    :commands org-mac-grab-link
    :init
    (progn
      (add-hook 'org-mode-hook
                (lambda ()
                  (define-key org-mode-map (kbd "C-c g") 'org-mac-grab-link))))
    :defer t))

(defun zilongshanren-org/init-org-tree-slide ()
  (use-package org-tree-slide
    :init
    (spacemacs/set-leader-keys "oto" 'org-tree-slide-mode)))


(defun zilongshanren-org/init-org-download ()
  (use-package org-download
    :defer t
    :init
    (org-download-enable)))

(defun zilongshanren-org/init-plain-org-wiki ()
  (use-package plain-org-wiki
    :init
    (setq pow-directory "~/org")))

(defun zilongshanren-org/init-worf ()
  (use-package worf
    :defer t
    :init
    (add-hook 'org-mode-hook 'worf-mode)))

(defun zilongshanren-org/post-init-deft ()
  (progn
    (setq deft-use-filter-string-for-filename t)
    (spacemacs/set-leader-keys-for-major-mode 'deft-mode "q" 'quit-window)
    (setq deft-recursive t)
    (setq deft-extension "org")
    (setq deft-directory deft-dir)))
;;; packages.el ends here
