(defpackage calorie-counting/tests/main
  (:use :cl
        :calorie-counting
        :rove))
(in-package :calorie-counting/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :calorie-counting)' in your Lisp.

(deftest test-target-1
  (testing "Return the highest number in a list."
    (ok (= (most-calories '(1 2 3 9 5 7)) 9))))

(deftest test-target-2
  (testing "Return the sum of the top 3 values in a list."
    (ok (= (top-three-calories '(300 200 100 500 700 150 250)) 1500))))
