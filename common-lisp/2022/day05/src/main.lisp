(defpackage supply-stacks
  (:use :cl)
  (:export :-main :move))
(in-package :supply-stacks)
(cl-annot:enable-annot-syntax)

(defparameter *stacks* '())

(defun memoize (function-name)
  (fare-memoization:memoize function-name))

@memoize
(defun num->sym (number)
  (intern (string-upcase (format nil "~:r"
                                 (if (stringp number)
                                     (parse-integer number)
                                     number))) :keyword))

(defun move (num &key from to reverse)
  (let ((sym-from (num->sym from))
        (sym-to   (num->sym to)))
    (let ((crate (subseq (getf *stacks* sym-from) (- (length (getf *stacks* sym-from)) num))))
      (setf (getf *stacks* sym-to) (concatenate 'list (getf *stacks* sym-to) (if reverse (reverse crate) crate)))
      (setf (getf *stacks* sym-from) (subseq (getf *stacks* sym-from) 0 (- (length (getf *stacks* sym-from)) num))))))

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

@memoize
(defun get-index (num line)
  (position (char num 0) line))

(defun get-letter (index line)
  (char (subseq line index (1+ index)) 0))

@memoize
(defun find-key (data)
  (position (first (loop
                     for x in data
                     when (and (> (length x) 2)
                               (string-equal " 1" (subseq x 0 2)))
                       collect x))
            data :test 'string-equal))

(defun generate-keys (line-key)
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

(defun get-instructions (data)
  (let ((key-line (find-key data)))
    (remove-if (lambda (line) (zerop (length line)))
               (subseq data (1+ key-line)))))

(defun string->instructions (x)
  (cond ((numberp (parse-integer x :junk-allowed t)) (parse-integer x :junk-allowed t))
        ((string-equal (string-upcase x) "MOVE")     'SUPPLY-STACKS:MOVE)
        (t                                           (intern (string-upcase x) :keyword))))

(defun process-line(line &optional &key reverse)
  (let ((inst (mapcar #'string->instructions (remove-if (lambda (x) (zerop (length x)))
                                                        (cl-ppcre:split "\\s+" line)))))
    (if reverse
        (append inst '(:reverse t))
        inst)))

(defun sort-list (data)
  (list (getf data :first)
        (getf data :second)
        (getf data :third)
        (getf data :fourth)
        (getf data :fifth)
        (getf data :sixth)
        (getf data :seventh)
        (getf data :eighth)
        (getf data :ninth)))

(defun do-part1 (data)
  (let ((*stacks* (generate-data data))
        (instructions (mapcar (lambda (x) (process-line x :reverse t)) (get-instructions data))))
    (loop for inst in instructions
          do (eval inst))
    (coerce (mapcar (lambda (x) (car (last x))) (sort-list *stacks*)) 'string)))

(defun do-part2 (data)
  (let ((*stacks* (generate-data data))
        (instructions (mapcar (lambda (x) (process-line x)) (get-instructions data))))
    (loop for inst in instructions
          do (eval inst))
    (coerce (mapcar (lambda (x) (car (last x))) (sort-list *stacks*)) 'string)))

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
                                        (format t "Part 1 of day 5 solution: ~A~%" (do-part1 input-data))
                                        (format t "Part 2 of day 5 solution: ~A~%" (do-part2 input-data)))))))
