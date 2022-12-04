(defpackage rucksacks
  (:use :cl)
  (:export :-main))
(in-package :rucksacks)

(opts:define-opts
  (:name :help
   :description "print this help text"
   :short #\h
   :long "help"))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun input-file(file)
  (mapcar (lambda (line) (list (subseq line 0 (/ (length line) 2)) (subseq line (/ (length line) 2))))
          (cl-ppcre:split "\\n" (uiop:read-file-string file))))

(defun prioritize (character)
  (let ((code (char-code character)))
    (if (< code 91)
        (- code 38)
        (- code 96))))

(defun filter-for-dups (alist)
  (let ((char-list (coerce (first alist) 'list)))
    (first
     (remove-duplicates
      (mapcar #'prioritize
              (remove-if-not (lambda (char) (position char (second alist))) char-list))))))

(defun -main (&rest args)
  (declare (ignorable args))
  (multiple-value-bind (options args)
      (handler-case
          (handler-bind ((opts:unknown-option #'unknown-option))
            (opts:get-opts)))
    (cond ((getf options :help) (progn (opts:describe
                                        :prefix (format nil "rucksacks is an implementation of the Advent of Code challenge Day 3 of 2022")
                                        :usage-of "rucksacks PATH-TO-INPUT-FILE")
                                       (opts:exit 1)))
          ((not (= (length args) 1)) (progn
                                       (format t "Can only process one input file at a time!")
                                       (opts:describe
                                        :prefix (format nil "rucksacks is an implementation of the Advent of Code challenge Day 3 of 2022")
                                        :usage-of "rucksacks PATH-TO-INPUT-FILE")
                                       (opts:exit 1)))
          (t                          (let* ((input-values (input-file (first args)))
                                             (priority-score (reduce #'+
                                                                     (mapcar #'filter-for-dups input-values))))
                                        (format t "Rucksack priorities score: ~A~%" priority-score))))))
