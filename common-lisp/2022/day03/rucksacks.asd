(defsystem "rucksacks"
  :version "0.1.0"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("cl-ppcre"
               "unix-opts"
               "rucksacks/part2")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Solution for day 3 of Advent of Code"
  :build-operation "asdf:program-op"
  :build-pathname "target/rucksacks"
  :entry-point "rucksacks:-main"
  :in-order-to ((test-op (test-op "rucksacks/tests"))))

(defsystem "rucksacks/part2"
  :version "0.1.0"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("serapeum")
  :components ((:module "src"
                :components
                ((:file "part2")))))

(defsystem "rucksacks/tests"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("rucksacks"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for rucksacks"
  :perform (test-op (op c) (symbol-call :rove :run c)))
