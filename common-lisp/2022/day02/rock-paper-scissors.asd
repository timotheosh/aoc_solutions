(defsystem "rock-paper-scissors"
  :version "0.1.0"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("cl-ppcre"
               "unix-opts")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "Scores a game of rock paper scissors"
  :build-operation "asdf:program-op"
  :build-pathname "target/rock-paper-scissors"
  :entry-point "rock-paper-scissors:-main"
  :in-order-to ((test-op (test-op "rock-paper-scissors/tests"))))

(defsystem "rock-paper-scissors/tests"
  :author "Tim Hawes"
  :license "MIT"
  :depends-on ("rock-paper-scissors"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for rock-paper-scissors"
  :perform (test-op (op c) (symbol-call :rove :run c)))
