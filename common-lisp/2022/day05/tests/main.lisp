(defpackage supply-stacks/tests/main
  (:use :cl
        :supply-stacks
        :rove))
(in-package :supply-stacks/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :supply-stacks)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
