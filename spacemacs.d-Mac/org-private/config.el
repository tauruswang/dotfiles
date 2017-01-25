;;; org-mode --- customize file

;;; code:

;; Org-Capture-Mode
(with-eval-after-load 'org
  (setq org-default-notes-file "~/org/organizer.org")

  ;; Capture templates
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
           (file+headline "~/org/organizer.org" "Inbox")
           ,my/org-basic-task-template)
          ("T" "Quick task" entry
           (file+headline "~/org/organizer.org" "Inbox")
           "* TODO %^{Task}\nSCHEDULED: %t\n"
           :immediate-finish t)
          ("i" "Interrupting task" entry
           (file+headline "~/org/organizer.org" "Inbox")
           "* STARTED %^{Task}"
           :clock-in :clock-resume)
          ("e" "Emacs idea" entry
           (file+headline "~/org/emacs-notes/tasks.org" "Emacs")
           "* TODO %^{Task}"
           :immediate-finish t)
          ("E" "Energy" table-line
           (file+headline "~/org/organizer.org" "Track energy")
           "| %U | %^{Energy 5-awesome 3-fuzzy 1-zzz} | %^{Note} |"
           :immediate-finish t
           )
          ("b" "Business task" entry
           (file+headline "~/org/business.org" "Tasks")
           ,my/org-basic-task-template)
          ("p" "People task" entry
           (file+headline "~/org/people.org" "Tasks")
           ,my/org-basic-task-template)
          ("j" "Journal entry" plain
           (file+datetree "~/org/journal.org")
           "%K - %a\n%i\n%?\n"
           :unnarrowed t)
          ("J" "Journal entry with date" plain
           (file+datetree+prompt "~/org/journal.org")
           "%K - %a\n%i\n%?\n"
           :unnarrowed t)
          ("s" "Journal entry with date, scheduled" entry
           (file+datetree+prompt "~/org/journal.org")
           "* \n%K - %a\n%t\t%i\n%?\n"
           :unnarrowed t)
          ("c" "Protocol Link" entry (file+headline ,org-default-notes-file "Inbox")
           "* [[%:link][%:description]] \n\n#+BEGIN_QUOTE\n%i\n#+END_QUOTE\n\n%?\n\nCaptured: %U")
          ("db" "Done - Business" entry
           (file+headline "~/org/business.org" "Tasks")
           "* DONE %^{Task}\nSCHEDULED: %^t\n%?")
          ("dp" "Done - People" entry
           (file+headline "~/org/people.org" "Tasks")
           "* DONE %^{Task}\nSCHEDULED: %^t\n%?")
          ("dt" "Done - Task" entry
           (file+headline "~/org/organizer.org" "Inbox")
           "* DONE %^{Task}\nSCHEDULED: %^t\n%?")
          ("q" "Quick note" item
           (file+headline "~/org/organizer.org" "Quick notes"))
          ("l" "Ledger entries")
          ("lm" "MBNA" plain
           (file "~/org/ledger")
           "%(org-read-date) %^{Payee}
    Liabilities:MBNA
    Expenses:%^{Account}  $%^{Amount}
  " :immediate-finish t)
          ("ln" "No Frills" plain
           (file "~/org/ledger")
           "%(let ((org-read-date-prefer-future nil)) (org-read-date)) * No Frills
    Liabilities:MBNA
    Assets:Wayne:Groceries  $%^{Amount}
  " :immediate-finish t)
          ("lc" "Cash" plain
           (file "~/org/ledger")
           "%(org-read-date) * %^{Payee}
    Expenses:Cash
    Expenses:%^{Account}  %^{Amount}
  ")
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
           ("n" "Daily note" table-line (file+olp "~/org/organizer.org" "Inbox")
            "| %u | %^{Note} |"
            :immediate-finish t)
           ("r" "Notes" entry
            (file+datetree "~/org/organizer.org")
            "* %?\n\n%i\n%U\n"
            )))

  (defun my/org-refile-and-jump ()
    (interactive)
    (if (derived-mode-p 'org-capture-mode)
        (org-capture-refile)
      (call-interactively 'org-refile))
    (org-refile-goto-last-stored))
  (eval-after-load 'org-capture
    '(bind-key "C-c C-r" 'my/org-refile-and-jump org-capture-mode-map))

  ;; Org-mode相关设置
  ;;(add-to-list 'auto-mode-alist '("\.\(org\|org_archive\|txt\)$" . org-mode))

  ;; define key-binding
  ;; uncomment at [2015-02-10 Tue]
  ;;(global-set-key (kbd "<C-M-return>") 'org-insert-heading-respect-content)
  ;; (global-set-key (kbd "C-c ! t") 'org-time-stamp-inactive)

  ;; habits settings
  (setq org-habit-graph-column 50)
  (run-at-time "06:00" 86400 '(lambda () (setq org-habit-show-habits t)))

  ;; set variables
  ;;(setq org-log-done 'time)
  (setq org-hide-leading-stars t)
  (setq org-enforce-todo-dependencies t) ; setup todo dependencies
  (setq org-agenda-dim-blocked-tasks t)  ; 淡化暂不可执行的todo条目的显示
  (setq org-use-fast-todo-selection t) ; the same as the default value
  (setq org-stuck-projects '("+project/-done" ("next"))) ; how to identify stuck projects
  (setq org-use-tag-inheritance nil)

  ;; 日历包含文件
  (setq org-directory "~/org/")
  (setq org-agenda-files (list "~/org/"))

  ;; set todo keywords & the faces
  (setq org-todo-keywords
        '((type "inbox(i)" "next(n)" "someday(s)" "maybe(m)" "sche(e)" "waiting(w@/!)" "project(p)" "habit(h)" "|" "DONE(d!)" "canceled(c!)")
          (type "goal(g)" "|" "ACHIEVED(a@!)")))

  (setq org-todo-keyword-faces
        '(("next" . "light sea green")
          ("someday" . "cadet blue")
          ("maybe" . "cadet blue")
          ("sche" . "orange")
          ("waiting" . "sienna")
          ("project" . "sky blue")
          ("canceled" . "grey")))

  ;; 调协子父项目完成度关联
  (defun org-summary-todo (n-done n-not-done)
    "Swith entry to DONE when all subentries are done, to TODO otherwise."
    (let (org-log-done org-log-states)   ; turn off logging.
      (org-todo (if (= n-not-done 0) "DONE" "project"))))

  (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

  ;; 自动换行
  (add-hook 'org-mode-hook
            (lambda () (setq truncate-lines nil)))

  ;; Reliling设置
  (setq org-refile-targets (quote ((nil :maxlevel . 6)
                                   (org-agenda-files :maxlevel . 6))))

  (setq org-refile-use-outline-path 'file)

  ;; Diary设置
  (setq org-agenda-include-diary t)
  (setq diary-file "~/org/diary")
  (setq diary-mail-addr "xashes@outlook.com")

  ;; 打开约会提醒功能
  (appt-activate 1)
  (add-hook 'diary-hook 'appt-make-list)
  (add-hook 'diary-hook '(lambda () (auto-fill-mode t)))
  (diary 0)
  ;; appointment alarm setting in calendar
  (setq appt-issue-message t)
  (setq appt-display-mode-line t)
  (setq appt-display-duration 420)
  (setq appt-display-diary 0)

  ;; 设置 calendar 的显示
  (setq calendar-remove-frame-by-deleting t)
  (setq calendar-week-start-day 1)            ; 设置星期一为每周的第一天
  (setq calendar-mark-diary-entries-flag t)     ; 标记calendar上有diary的日期
  (setq calendar-mark-holidays-flag nil)        ; 为了突出有diary的日期，calendar上不标记节日
  (setq calendar-view-diary-initially-flag nil) ; 打开calendar的时候不显示一堆节日

  ;; Agenda View的自定义命令
  (custom-set-variables
   '(org-agenda-custom-commands (quote (("h" "All lists"
                                         ((agenda)
                                          (todo "next")))

                                        ("d" "Daily Action List"
                                         ((agenda "" ((org-agenda-ndays 1)
                                                      (org-agenda-sorting-strategy
                                                       (quote ((agenda time-up priority-down tag-up) )))
                                                      (org-deadline-warning-days 0)
                                                      )))))))
   '(org-modules (quote (org-bbdb org-bibtex org-docview org-gnus org-info org-habit org-irc org-mhe org-rmail org-w3m))))


  ;; 设置Calendar的热键
  (global-set-key [(f5)] 'calendar)

  ;; Clock相关设定
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)

  ;; 设置阴历显示，在 calendar 上用 pC 显示阴历
  (setq calendar-chinese-celestial-stem
        ["甲" "乙" "丙" "丁" "戊" "己" "庚" "辛" "壬" "癸"])
  (setq calendar-chinese-terrestrial-branch
        ["子" "丑" "寅" "卯" "辰" "巳" "戊" "未" "申" "酉" "戌" "亥"])
)
;;; personal-org.el ends here
