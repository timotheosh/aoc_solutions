(defpackage calorie-counting
  (:use :cl)
  (:export :most-calories :top-three-calories))
(in-package :calorie-counting)

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
