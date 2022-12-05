(defsystem "camp-cleanup"
  :version "0.1.0"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("cl-ppcre"
               "unix-opts")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Solutions for Advent of Code Day 4"
  :build-operation "asdf:program-op"
  :build-pathname "target/camp-cleanup"
  :entry-point "camp-cleanup:-main"
  :in-order-to ((test-op (test-op "camp-cleanup/tests"))))

(defsystem "camp-cleanup/tests"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("camp-cleanup"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for camp-cleanup"
  :perform (test-op (op c) (symbol-call :rove :run c)))
