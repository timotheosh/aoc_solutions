(defsystem "tuning-trouble"
  :version "0.1.0"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("cl-ppcre"
               "unix-opts")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Solution for Advent of Code day 6"
  :build-operation "asdf:program-op"
  :build-pathname "target/tuning-trouble"
  :entry-point "tuning-trouble:-main"
  :in-order-to ((test-op (test-op "tuning-trouble/tests"))))

(defsystem "tuning-trouble/tests"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("tuning-trouble"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for tuning-trouble"
  :perform (test-op (op c) (symbol-call :rove :run c)))
