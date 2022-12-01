(defsystem "calorie-counting"
  :version "0.1.0"
  :author "Tim Hawes"
  :license ""
  :depends-on (#:cl-ppcre)
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Tallies number of calories in a set and identifies which set in the list has the most."
  :in-order-to ((test-op (test-op "calorie-counting/tests"))))

(defsystem "calorie-counting/tests"
  :author "Tim Hawes"
  :license ""
  :depends-on ("calorie-counting"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for calorie-counting"
  :perform (test-op (op c) (symbol-call :rove :run c)))
