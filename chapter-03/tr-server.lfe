;;;-----------------------------------------------------------------------------
;;; @author David Bloom <iprog4u@gmail.com>
;;;  [https://oookaaay.net]
;;; @copyright 2025 David Bloom
;;; @doc RPC over TCP server.  This module defines a server process that listens
;;;      for incoming TCP connections and allows the user to execute RPC
;;;      commands via that TCP stream.
;;; @end
;;;-----------------------------------------------------------------------------

(defmodule tr-server
  (behaviour gen_server)
  )