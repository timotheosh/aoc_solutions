(defpackage rock-paper-scissors
  (:use :cl)
  (:export :-main))
(in-package :rock-paper-scissors)

(defvar rps/values
  '(rock 1 paper 2 scissors 3))

(opts:define-opts
  (:name :help
   :description "print this help text"
   :short #\h
   :long "help"))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun value->thing (character)
  (cond ((or (char-equal character #\A)
             (char-equal character #\X)) 'rock)
        ((or (char-equal character #\B)
             (char-equal character #\Y)) 'paper)
        ((or (char-equal character #\C)
             (char-equal character #\z)) 'scissors)
        (t  (format t "Invalid character: ~A!~%" character))))

(defun rock-result(op)
  (let ((result (case op
                  (rock 3)
                  (paper 6)
                  (scissors 0))))
    (when result
      (+ (getf rps/values op) result))))

(defun paper-result(op)
  (let ((result (case op
                  (rock 0)
                  (paper 3)
                  (scissors 6))))
    (when result
      (+ (getf rps/values op) result))))

(defun scissors-result(op)
  (let ((result (case op
                  (rock 6)
                  (paper 0)
                  (scissors 3))))
    (when result
      (+ (getf rps/values op) result))))

(defun pair->score (pair)
  (let ((score (case (first pair)
                 (rock (rock-result (second pair)))
                 (paper (paper-result (second pair)))
                 (scissors (scissors-result (second pair))))))
    (if (null score)
        (format t "Invalid pair! (~{~A ~})~%" pair)
        score)))

(defun load-input(file)
  (mapcar #'pair->score
          (mapcar (lambda (line)
                    (mapcar (lambda (str) (value->thing (coerce str 'character)))
                            (cl-ppcre:split "\\W+" line)))
                  (cl-ppcre:split "\\n" (uiop:read-file-string file)))))

(defun -main (&rest args)
  (declare (ignorable args))
  (multiple-value-bind (options args)
      (handler-case
          (handler-bind ((opts:unknown-option #'unknown-option))
            (opts:get-opts)))
    (cond ((getf options :help) (progn (opts:describe
                                        :prefix (format nil "rock-paper-scissors is an implementation of the Advent of Code challenge Day 2 of 2022")
                                        :usage-of "rock-paper-scissors PATH-TO-INPUT-FILE")
                                       (opts:exit 1)))
          ((not (= (length args) 1)) (progn
                                       (format t "Can only process one input file at a time!")
                                       (opts:describe
                                        :prefix (format nil "rock-paper-scissors is an implementation of the Advent of Code challenge Day 2 of 2022")
                                        :usage-of "rock-paper-scissors PATH-TO-INPUT-FILE")
                                       (opts:exit 1)))
          (t                          (let ((input-values (load-input (first args))))
                                        (format t "Total score: ~A~%" (reduce #'+ input-values)))))))
