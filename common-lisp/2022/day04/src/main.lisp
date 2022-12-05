(defpackage camp-cleanup
  (:use :cl)
  (:export :-main))
(in-package :camp-cleanup)

(opts:define-opts
  (:name :help
   :description "print this help text"
   :short #\h
   :long "help"))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun range (pairs)
  (loop for n from (first pairs) to (second pairs)
        collect n))

(defun input-file (file)
  (mapcar (lambda (line)
            (mapcar (lambda (pair)
                      (mapcar #'parse-integer (cl-ppcre:split "-" pair))) (cl-ppcre:split "," line)))
          (cl-ppcre:split "\\n" (uiop:read-file-string file))))

(defun filter-full-overlap (line)
  (let ((pair1 (first line))
        (pair2 (second line)))
    (or (and (>= (first pair1) (first pair2))
             (<= (second pair1) (second pair2)))
        (and (>= (first pair2) (first pair1))
             (<= (second pair2) (second pair1))))))


(defun filter-partial-overlap (line)
  (let ((range1 (range (first line)))
        (range2 (range (second line))))
    (when (> (length (remove-if-not (lambda (num) (member num range2)) range1)) 0)
      t)))

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
          (t                         (let ((part1-solution (length (remove-if-not #'filter-full-overlap
                                                                                  (input-file (first args)))))
                                           (part2-solution (length (remove-if #'null (mapcar #'filter-partial-overlap
                                                                                             (input-file (first args)))))))
                                       (format t "Number of fully overlapping pairs: ~A~%" part1-solution)
                                       (format t "Number of partial overlapping pairs: ~A~%" part2-solution))))))
