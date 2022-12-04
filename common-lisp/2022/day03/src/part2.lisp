(defpackage rucksacks/part2
  (:use cl)
  (:export :input-file :solve))

(in-package :rucksacks/part2)

(defun prioritize (character)
  (let ((code (char-code character)))
    (if (< code 91)
        (- code 38)
        (- code 96))))

(defun filter-for-dups (alist)
  (let ((char-list (remove-duplicates (coerce (first alist) 'list))))
    (first
     (remove-if-not (lambda (char) (and (position char (second alist))
                                        (position char (third alist)))) char-list))))

(defun input-file(file)
  (serapeum:batches
   (cl-ppcre:split "\\n" (uiop:read-file-string file)) 3))

(defun solve (data)
  (reduce #'+
          (mapcar #'prioritize (mapcar #'filter-for-dups data))))

#||#
#|  < 3599
|#
