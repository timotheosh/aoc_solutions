(defpackage tuning-trouble
  (:use :cl)
  (:export :-main))
(in-package :tuning-trouble)

#|
Advent of code problem URL https://adventofcode.com/2022/day/6
|#

(defparameter *test-lines*
  '("bvwbjplbgvbhsrlpgdmjqwftvncz"
    "nppdvjthqldpwncqszvftbrmjlhg"
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"))

(defparameter *test-messages*
  '("mjqjpqmgbljsphdztnvjfqwrcgsmlb"    ; first marker after character 19
    "bvwbjplbgvbhsrlpgdmjqwftvncz"      ; first marker after character 23
    "nppdvjthqldpwncqszvftbrmjlhg"      ; first marker after character 23
    "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg" ; first marker after character 29
    "zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw"  ; first marker after character 26
    ))

(opts:define-opts
  (:name :help
   :description "print this help text"
   :short #\h
   :long "help"))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun tuning-test (data characters)
  (when (= (length (remove-duplicates data)) characters)
    (progn
      t)))

(defun find-start-protocol (line characters)
  "Finds a pattern of the first non-duplicating sub-sequence within a given sequence."
  (let ((data (coerce line 'list)))
    (loop for x from 0 to (length data)
          do (when (tuning-test
                    (mapcar (lambda (z) (nth z data))
                            (loop for y from x to (+ (1- x) characters) collect y)) characters)
               (return (+ characters x))))))

(defun input-file (file)
  (uiop:read-file-string file))

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
          (t                          (let ((input-data (input-file (first args))))
                                        (format t "Part 1 Solution: Mesage starts after ~A~%" (find-start-protocol input-data 4))
                                        (format t "Part 1 Solution: Mesage starts after ~A~%" (find-start-protocol input-data 14)))))))
