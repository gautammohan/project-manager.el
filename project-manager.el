
(cl-defgeneric pm-list-files (proj remote vc) "sup"
               `("default" . (,proj ,remote ,vc)))

(cl-defmethod pm-list-files  (proj remote (vc (eql git)))
  (if (eq vc 'git)
      (cons "git-yes" (cl-call-next-method))
    (cons "git-no" (cl-call-next-method))))

(cl-defmethod pm-list-files (proj (remote (eql t)) vc)
  (if (eq proj 1)
      (cons "remote-git-any" (cl-call-next-method))
    (cons "remote-git-any" (cl-call-next-method proj remote nil))))

(cl-defmethod pm-list-files (proj (remote (eql t)) (vc (eql git)))
  (if (eq proj 1)
      (cons "remote-yes-git-yes" (cl-call-next-method))
    (cons "remote-no-git" (pm-list-files proj remote nil))))
    ;; (cons "remote-no" (pm-list-files proj nil nil))

;; observations.... cl-call-method will call the next method regardless of whether or not its specialization matches the called arguments. the above evaluates with a git-no despite the eql git specializer on the pm-list-files.

;; instead we can restart the dispatch by calling the generic method with new arguments.
;; but if a function can be called with arguments that break its predicate, we should be able to detect that in the body (hence "git-no") and just call next method instead. '

(provide 'project-manager)

(defun pm-list ()
  (interactive)
  (print (pm-list-files 1 t 'git)))
