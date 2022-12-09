(defpackage tuning-trouble/tests/main
  (:use :cl
        :tuning-trouble
        :rove))
(in-package :tuning-trouble/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :tuning-trouble)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
