;;;=============================================================================
;;; @author David Bloom <iprog4u@gmail.com>
;;;  [https://oookaaay.net]
;;; @copyright 2025 David Bloom
;;; @doc RPC over TCP server.  This module defines a server process that listens
;;;      for incoming TCP connections and allows the user to execute RPC
;;;      commands via that TCP stream.
;;; @end
;;;=============================================================================

(defmodule tr-server
  (behaviour gen_server)
  (include-lib '"eunit/include/eunit.hrl")
  (export
   ;; API
   (start 1)
   (start 0)
   (get-count 0)
   (stop 0)
   ;; gen_server callbacks
   (init 1)
   (handle_call 3)
   (handle_cast 2)
   (handle_info 2)
   (terminate 2)
   (code_change 3)))

(defun server-name () (MODULE))
(defun default-port () 1055)

(defrecord state port lsock (request-count 0))

;;;===========================================================================
;;; API
;;;===========================================================================

(defun start (port)
  (gen_server:start_link `#(local ,(MODULE))
			 (MODULE)
			 port
			 '()))

(defun start ()
  (start (default-port)))

(defun get-count ()
  (gen_server:call (server-name) 'get-count))

(defun stop ()
  (gen_server:cast (server-name) 'stop))


;;;===========================================================================
;;; gen_server callback implementation
;;;===========================================================================

(defun init (port)
  (let (((tuple 'ok lsock) (gen_tcp:listen port '(#(active true) #(packet 0)))))
     `#(ok ,(make-state port port lsock lsock) 0)))

(defun handle_call (get-count _from state)
  `#(reply #(ok ,(state-request-count state)) ,state))

(defun handle_cast (stop state)
  `#(stop normal ,state))

(defun handle_info
  (((tuple 'tcp socket raw-data) state)
   (do-rpc socket raw-data)
   `#(noreply ,(set-state-request-count state
					(+ 1 (state-request-count state)))))
  ((timeout state)
   (let (((tuple 'ok _sock) (gen_tcp:accept (state-lsock state))))
     `#(noreply ,state))))

(defun terminate (_reason _state)
  'ok)

(defun code_change (_old-vsn state _extra)
  `#(ok ,state))

;;;===========================================================================
;;; Internal functions
;;;===========================================================================

(defun do-rpc (socket raw-data)
  (try
      (let* ((sexpr (parse-sexpr raw-data))
	     (result (lfe_eval:expr sexpr)))
	(gen_tcp:send socket
		      (io_lib:fwrite "~p~n" (list result))))
    (catch
      (`#(error ,error-type ,_stacktrace)
       (gen_tcp:send socket
		     (io_lib:fwrite "~p~n" (list error-type)))))))

(defun parse-sexpr (raw-data)
  (let* (((tuple 'ok tokens _line) (lfe_scan:string raw-data))
	 ((tuple 'ok _ sexpr _) (lfe_parse:sexpr tokens)))
    sexpr))