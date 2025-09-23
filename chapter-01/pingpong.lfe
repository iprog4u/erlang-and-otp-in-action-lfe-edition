;;----------------------------------------------------------------------
;; File: pingpong.lfe


(defmodule pingpong
  (export (run 0)))

(defun run ()
  (let ((pid (spawn (lambda () (ping)))))
    (! pid (self))
    (receive
     ('pong 'ok))))

(defun ping ()
  (receive
    (from
     (! from 'pong))))
