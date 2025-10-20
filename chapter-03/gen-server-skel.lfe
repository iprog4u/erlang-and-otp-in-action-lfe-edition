;; -----------------------------------------------------------------------------
;; File: gen-server-skel.lfe
;;
;; This is a skeleton implementation of a gen_server callback module

(defmodule gen-server-skel
  (behaviour gen_server)
  (export
   ;; gen_server implementation
   (start 0)
   (stop 0)
   ;; callback implementation
   (init 1)
   (handle_call 3)
   (handle_cast 2)
   (handle_info 2)
   (terminate 2)
   (code_change 3))

  (defrecord state '#())

  (defun init ('())
    `#(ok ,(make-state)))

  (defun handle_call (_request _from state)
    `#(reply ok ,state))

  (defun handle_cast (_msg state)
    `#(noreply ,state))

  (defun handle_info (_info state)
    `#(noreply ,state))

  (defun terminate (_reason _state)
    'ok)

  (defun code_change (_oldvsn state _extra)
    `#(ok state)))