;;; exwmx-button.el --- Add some Exwm-X buttons to mode-line or header-line

;; * Header
;; Copyright 2015-2017 Feng Shu

;; Author: Feng Shu <tumashu@163.com>
;; URL: https://github.com/tumashu/exwm-x
;; Version: 1.0
;; Keywords: exwm, exwmx

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; * README                                                               :doc:
;;; Code:

;; * Code                                                                 :code:
(require 'exwmx-core)
(require 'switch-window)

(defvar exwmx-button-floating-button-line 'header-line
  "Use 'header-line or 'mode-line as the button-line of floating window.")

(defun exwmx-button--create-button (button-line button-name &optional mouse-1-action
                                                mouse-3-action mouse-2-action
                                                active-down-mouse)
  "Generate code of button named `button-name' for `button-line', the value of `button-line'
can be `mode-line' or `header-line'.

`mouse-1-action', `mouse-2-action' and `mouse-2-action' are quoted lists.
when click it with mouse-1, `mouse-1-action' will be execute.
click mouse-2, `mouse-2-action' execute. click mouse-3, `mouse-3-action'
execute. "
  `(:eval (propertize
           ,button-name
           'face 'mode-line-buffer-id
           'help-echo ""
           'mouse-face 'mode-line-highlight
           'local-map
           (let ((map (make-sparse-keymap)))
             (unless (eq (quote ,mouse-1-action) nil)
               (define-key map [,button-line mouse-1]
                 #'(lambda (event)
                     (interactive "e")
                     (with-selected-window (posn-window (event-start event))
                       ,mouse-1-action))))
             (unless (eq (quote ,mouse-2-action) nil)
               (define-key map [,button-line mouse-2]
                 #'(lambda (event)
                     (interactive "e")
                     (with-selected-window (posn-window (event-start event))
                       ,mouse-2-action))))
             (unless (eq (quote ,mouse-3-action) nil)
               (define-key map [,button-line mouse-3]
                 #'(lambda (event)
                     (interactive "e")
                     (with-selected-window (posn-window (event-start event))
                       ,mouse-3-action))))
             (when (and (eq major-mode 'exwm-mode)
                        exwm--floating-frame
                        (not (eq (quote ,active-down-mouse) nil)))
               (define-key map [,button-line down-mouse-1]
                 #'exwmx-mouse-move-floating-window)
               (define-key map [,button-line down-mouse-3]
                 #'exwmx-mouse-move-floating-window))
             map))))

(defun exwmx-button--create-tilling-button-line ()
  "Create tilling window's button-line, which has buttons:

X: Delete current application.
D: Delete current window.
F: Toggle floating window.

<: Move border to left.
+: Maximize current window.
>: Move border to right.

-: Split window horizontal.
|: Split window vertical."
  (setq header-line-format nil)
  (setq mode-line-format
        (list (exwmx-button--create-button
               'mode-line "[X]" '(exwmx-kill-exwm-buffer) '(exwmx-kill-exwm-buffer))
              (exwmx-button--create-button
               'mode-line "[D]" '(delete-window) '(delete-window))
              (exwmx-button--create-button
               'mode-line "[F]" '(exwm-floating-toggle-floating) '(exwm-floating-toggle-floating))
              " "
              (exwmx-button--create-button
               'mode-line "[<]" '(switch-window-mvborder-left 10) '(switch-window-mvborder-left 10))
              (exwmx-button--create-button
               'mode-line "[+]" '(delete-other-windows) '(delete-other-windows))
              (exwmx-button--create-button
               'mode-line "[>]" '(switch-window-mvborder-right 10) '(switch-window-mvborder-right 10))
              " "
              (exwmx-button--create-button
               'mode-line "[-]" '(split-window-below) '(split-window-below))
              (exwmx-button--create-button
               'mode-line "[|]" '(split-window-right) '(split-window-right))
              " "
              (exwmx-button--create-line2char-button (exwm--buffer->id (window-buffer)))
              " - "
              exwm-title)))

(defun exwmx-button--create-floating-button-line ()
  "Create floating window's button-line, which have buttons:

X:  Delete current application.
_:  Minumize floating application
F:  Toggle floating window.

L:  Line-mode
C:  Char-mode

←↓↑→: Zoom floating application's window."
  (let* ((button-line exwmx-button-floating-button-line)
         (value (list (exwmx-button--create-button
                       button-line "[X]" '(exwmx-kill-exwm-buffer) '(exwmx-kill-exwm-buffer))
                      (exwmx-button--create-button
                       button-line "[_]" '(exwm-floating-hide) '(exwm-floating-hide))
                      (exwmx-button--create-button
                       button-line "[F]" '(exwm-floating-toggle-floating) '(exwm-floating-toggle-floating))
                      " "
                      (exwmx-button--create-button
                       button-line "[←]"
                       '(exwm-layout-enlarge-window-horizontally -60)
                       '(exwm-layout-enlarge-window-horizontally -300))
                      (exwmx-button--create-button
                       button-line "[↓]"
                       '(exwm-layout-enlarge-window 30)
                       '(exwm-layout-enlarge-window 150))
                      (exwmx-button--create-button
                       button-line "[↑]"
                       '(exwm-layout-enlarge-window -30)
                       '(exwm-layout-enlarge-window -150))
                      (exwmx-button--create-button
                       button-line "[→]"
                       '(exwm-layout-enlarge-window-horizontally 60)
                       '(exwm-layout-enlarge-window-horizontally 300))
                      " "
                      (exwmx-button--create-line2char-button (exwm--buffer->id (window-buffer)) t)
                      (exwmx-button--create-button
                       button-line
                       (concat " - " exwm-title (make-string 200 ? )) nil nil nil t))))
    (if (eq button-line 'mode-line)
        (progn (setq mode-line-format value)
               (setq header-line-format nil))
      (setq header-line-format value)
      (setq mode-line-format nil))))

(defun exwmx-button--create-line2char-button (id &optional short)
  "Create Char-mode/Line-mode toggle button."
  (or (when id (exwmx-button--create-line2char-button-1 id short)) ""))

(defun exwmx-button--create-line2char-button-1 (id short)
  "Internal function of `exwmx-button--create-line2char-button'."
  (let (help-echo cmd mode)
    (cl-case exwm--on-KeyPress
      ((exwm-input--on-KeyPress-line-mode)
       (setq mode
             (if short
                 "[L]"
               (substitute-command-keys
                "[Line `\\[exwmx-toggle-keyboard]']"))
             help-echo "mouse-1: Switch to char-mode"
             cmd `(lambda ()
                    (interactive)
                    (exwm-input-release-keyboard ,id))))
      ((exwm-input--on-KeyPress-char-mode)
       (setq mode
             (if short
                 "[C]"
               (substitute-command-keys
                "[Char `\\[exwmx-toggle-keyboard]']"))
             help-echo "mouse-1: Switch to line-mode"
             cmd `(lambda ()
                    (interactive)
                    (exwm-input-grab-keyboard ,id)))))
    (with-current-buffer (exwm--id->buffer id)
      `(""
        (:propertize ,mode
                     face mode-line-buffer-id
                     help-echo ,help-echo
                     mouse-face mode-line-highlight
                     local-map
                     (keymap (mode-line keymap
                                        (down-mouse-1 . ,cmd))))))))

(defun exwmx-button--update-button-line ()
  "Update all buffer's button-line."
  (interactive)
  ;; Set all buffer's mode-line or header-line.
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (cond ((and (eq major-mode 'exwm-mode)
                  (not exwm--floating-frame))
             (exwmx-button--create-tilling-button-line))
            ((and (eq major-mode 'exwm-mode)
                  exwm--floating-frame)
             (exwmx-button--create-floating-button-line))
            (t (setq mode-line-format
                     (default-value 'mode-line-format)))))
    (force-mode-line-update)))

(add-hook 'exwm-update-class-hook #'exwmx-button--update-button-line)
(add-hook 'exwm-update-title-hook #'exwmx-button--update-button-line)
(add-hook 'buffer-list-update-hook #'exwmx-button--update-button-line)

;; * Footer

(provide 'exwmx-button)

;;; exwmx-modeline.el ends here
