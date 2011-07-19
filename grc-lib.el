;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; General purpose functions
(defun grc-list (thing)
  "Return THING if THING is a list, or a list with THING as its element."
  (if (listp thing)
      thing
    (list thing)))

(defun grc-string (thing)
  (if (stringp thing)
      thing
    (prin1-to-string thing t)))

(defun grc-flatten (x)
  (cond ((null x) nil)
        ((listp x) (append (grc-flatten (car x)) (grc-flatten (cdr x))))
        (t (list x))))

(defun grc-get-in (alist seq &optional not-found)
  (let ((val (reduce (lambda (a k)
                       (aget a k)) seq :initial-value alist)))
    (if (and (null val) not-found)
        not-found
      val)))

(defun grc-sort-by (field entries &optional reverse-result)
  (let* ((sorted (sort (copy-alist entries)
                       (lambda (a b)
                         (string<
                          (downcase (grc-string (aget a field)))
                          (downcase (grc-string (aget b field)))))))
         (sorted (if reverse-result (reverse sorted) sorted)))
    sorted))

(defun grc-group-by (field entries)
  (let* ((groups (remq nil (remove-duplicates
                            (mapcar (lambda (x)
                                      (grc-string (aget x field t))) entries)
                            :test 'string=)))
         (ret-list '()))
    (amake 'ret-list groups)
    (mapcar (lambda (entry)
              (let* ((k (aget entry field t))
                     (v (aget ret-list k t)))
                (aput 'ret-list k (cons entry v))))
            entries)
    ret-list))

(provide 'grc-lib)