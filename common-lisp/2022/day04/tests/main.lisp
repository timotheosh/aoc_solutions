(defpackage camp-cleanup/tests/main
  (:use :cl
        :camp-cleanup
        :rove))
(in-package :camp-cleanup/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :camp-cleanup)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
