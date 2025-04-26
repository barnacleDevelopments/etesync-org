;;; -*- lexical-binding: t; -*-
;;; ;;; package: etesync-org --- Etebase authentication and login in Emacs
;;; etesync-org.el --- Etebase authentication and login in Emacs
;;; Author: Devin Davis
;;; Commentary:

;;; Code:
(require 'request)
(require 'json)

(defcustom etesync-org-username "devsam"
  "Username for Etebase authentication."
  :type 'string
  :group 'etesync)

(defun etebase-challenge ()
  "Request a challenge from Etebase for authentication."
  (interactive) ; Make it available for emacs to call interactively
  (request
   "https://api.etebase.com/api/v1/authentication/login_challenge/"
   :type "POST"
   :headers '(("Content-Type" . "application/json")
              ("Accept" . "application/json"))
   :data (json-encode `(("username" . "devsam")))
   :parser 'json-read
   :success (cl-function
             (lambda (&key data &allow-other-keys)
               (debug)
               (let ((challenge (alist-get 'challenge data)))
                 (if challenge
                     (message "Challenge received: %s" challenge)
                   (message "Challenge failed: No challenge received.")))))
   :error (cl-function
           (lambda (&key error-thrown &allow-other-keys)
             (debug)
             (message "Challenge error: %S" error-thrown)))))

(provide 'etesync-org)
;;; etesync-org.el ends here
