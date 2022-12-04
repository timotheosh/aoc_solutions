(defpackage rock-paper-scissors/part2
  (:use cl)
  (:export :load-input))

(in-package :rock-paper-scissors/part2)

(defvar rps/values
  '(rock 1 paper 2 scissors 3))

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

(defun value->thing (characters)
  (cond ((char-equal (first  characters) #\A) (list 'rock    (case (second characters)
                                                               (#\X 'scissors)
                                                               (#\Y 'rock)
                                                               (#\Z 'paper))))
        ((char-equal (first characters) #\B) (list 'paper    (case (second characters)
                                                               (#\X 'rock)
                                                               (#\Y 'paper)
                                                               (#\Z 'scissors))))
        ((char-equal (first characters) #\C) (list 'scissors (case (second characters)
                                                               (#\X 'paper)
                                                               (#\Y 'scissors)
                                                               (#\Z 'rock))))
        (t  (format t "Invalid character: ~A!~%" characters))))

(defun load-input(file)
  (mapcar (lambda (line)
            (pair->score
             (value->thing (mapcar (lambda (str) (coerce str 'character))
                                   (cl-ppcre:split "\\W+" line)))))
          (cl-ppcre:split "\\n" (uiop:read-file-string file))))
