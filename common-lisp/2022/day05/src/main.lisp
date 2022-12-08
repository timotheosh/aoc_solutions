(defpackage supply-stacks
  (:use :cl)
  (:export :-main))
(in-package :supply-stacks)
(cl-annot:enable-annot-syntax)

(defun move (num from to &optional &key reverse)
  (let ((crate (subseq (getf *stacks* from) (- (length (getf *stacks* from)) num))))
    (setf (getf *stacks* to) (concatenate 'list (getf *stacks* to) (if reverse (reverse crate) crate)))
    (setf (getf *stacks* from) (subseq (getf *stacks* from) 0 (- (length (getf *stacks* from)) num)))))
;;
(defun memoizer (function-name)
  (setf (fdefinition function-name) (fare-memoization:memoizing function-name)))

(opts:define-opts
  (:name :help
   :description "print this help text"
   :short #\h
   :long "help"))

(defun unknown-option (condition)
  (format t "warning: ~s option is unknown!~%" (opts:option condition))
  (invoke-restart 'opts:skip-option))

(defun input-file (file)
  (uiop:read-file-lines file))

@memoizer
(defun num->sym (number)
  (intern (string-upcase (format nil "~:r"
                                 (if (stringp number)
                                     (parse-integer number)
                                     number))) :keyword))

@memoizer
(defun get-index (num line)
  (position (char num 0) line))

(defun get-letter (index line)
  (char (subseq line index (1+ index)) 0))

@memoizer
(defun find-key (data)
  (position (first (loop
                     for x in data
                     when (and (> (length x) 2)
                               (string-equal " 1" (subseq x 0 2)))
                       collect x))
            data :test 'string-equal))

(defun generate-keys(line-key)
  (let ((keys (remove-if (lambda (key) (zerop (length key)))
                         (cl-ppcre:split "\\s+" line-key)))
        (plist '()))
    (mapcar (lambda (x) (num->sym x))
            keys)))

(defun generate-data (data)
  (let ((plist '())
        (key-line (find-key data)))
    (loop
      for line in (subseq data 0 key-line)
      do
         (loop
           for number in (cdr (cl-ppcre:split "\\s+" (nth key-line data)))
           do
              (let* ((index (get-index number (nth key-line data)))
                     (letter (get-letter index line)))
                (when (char/= letter #\ )
                  (setf (getf plist (num->sym number)) (push letter (getf plist (num->sym number))))))))
    plist))


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
          (t                         (format t "Hello, ~A!~%" (first args))))))
