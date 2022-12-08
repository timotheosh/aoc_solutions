(defsystem "supply-stacks"
  :version "0.1.0"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("cl-project"
               "unix-opts"
               "cl-annot"
               "memoize")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Solutions for day 5"
  :build-operation "asdf:program-op"
  :build-pathname "target/supply-stacks"
  :entry-point "supply-stacks:-main"
  :in-order-to ((test-op (test-op "supply-stacks/tests"))))

(defsystem "supply-stacks/tests"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("supply-stacks"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for supply-stacks"
  :perform (test-op (op c) (symbol-call :rove :run c)))
