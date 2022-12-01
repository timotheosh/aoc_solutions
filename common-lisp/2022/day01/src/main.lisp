(defpackage calorie-counting
  (:use :cl)
  (:export :most-calories :top-three-calories :-main))
(in-package :calorie-counting)

(opts:define-opts
  (:name :help
   :description "print this help text"
   :short #\h
   :long "help"))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun load-input(file)
  (mapcar (lambda (x) (reduce #'+ (mapcar #'parse-integer (cl-ppcre:split "\\n" x))))
          (cl-ppcre:split "\\n\\n" (uiop:read-file-string file))))

(defun most-calories (input)
  (reduce #'max input))

(defun top-three-calories (input)
  (reduce #'+ (subseq (sort input #'>) 0 3)))

(defun day01-part1 (input-file)
  (let ((input-values (load-input input-file)))
    (most-calories input-values)))

(defun day01-part2 (input-file)
  (let ((input-values (load-input input-file)))
    (top-three-calories input-values)))

(defun -main(&rest args)
  (declare (ignorable args))
  (multiple-value-bind (options args)
      (handler-case
          (handler-bind ((opts:unknown-option #'unknown-option))
            (opts:get-opts)))
    (cond ((getf options :help) (progn (opts:describe
                                        :prefix (format nil "calorie-counter is an implementation of the Advent of Code challenge Day 1 of 2022")
                                        :usage-of "calorie-counter PATH-TO-INPUT-FILE")
                                       (opts:exit 1)))
          ((> (length args) 1) (progn
                                 (format t "Can only process one input file at a time!")
                                 (opts:describe
                                  :prefix (format nil "calorie-counter is an implementation of the Advent of Code challenge Day 1 of 2022")
                                  :usage-of "calorie-counter PATH-TO-INPUT-FILE")
                                 (opts:exit 1)))
          (t                    (let ((input-values (load-input (first args))))
                                  (format t "AoC 2022 Day 1 Part 1: Most Calories: ~A~%" (most-calories input-values))
                                  (format t "AoC 2022 Day 1 Part 2: Sum of top 3 calorie values: ~A~%" (top-three-calories input-values)))))))
