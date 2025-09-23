;;----------------------------------------------------------------------
;; File: my-module.lfe

(defmodule my-module
  (export (pie 0)
	  (print 1)
	  (either-or-both 2)
	  (area 1)
	  (sign 1)
	  (yesno 1)
	  (render 0)
	  (sum 1)
	  (do-sum 1)
	  (rev 1)
	  (tailrev 1)))

(defun pie ()
  3.14)

(defun print (term)
  (io:format "The value of term is: ~w~n" '(term)))

(defun either-or-both
  "Example output:
   lfe> (my-module:either-or-both 'true 'false)
   true
   lfe> (my-module:either-or-both 'true 'true)
   true
   lfe> (my-module:either-or-both 'false 'true)
   true
   lfe> (my-module:either-or-both 'false 'false)
   false"
  (('true b) (when (is_boolean b))
   'true)
  ((a 'true) (when (is_boolean a))
   'true)
  (('false 'false)
   'false))

(defun area
  "Example output:
   lfe> (my-module:area `#(circle 10))
   314.1592653589793
   lfe> (my-module:area `#(square 10))
   100
   lfe> (my-module:area `#(rectangle 5 10))
   50"
  ((`#(circle ,radius)) (when (is_number radius))
      (* radius radius (math:pi)))
  ((`#(square ,side)) (when (is_number side))
     (* side side))
  ((`#(rectangle ,height ,width)) (when (andalso (is_number height) (is_number width)))
     (* height width)))

(defun sign
  "Example output:
   lfe> (my-module:sign -5)
   negative
   lfe> (my-module:sign 42)
   positive
   lfe> (my-module:sign 0)
   0"
  ((n) (when (andalso (is_number n) (> n 0)))
   'positive)
  ((n) (when (andalso (is_number n) (< n 0)))
   'negative)
  ((n) (when (is_number n))
   0))

(defun yesno (f)
  "Example output:
   lfe> (my-module:yesno (fun my-module either-or-both 2))
   yes
   ok"
  (let ((result (funcall f 'true 'false)))
    (case result
      ('true (io:format "yes~n"))
      ('false (io:format "no~n")))))

(defun to-html (items f)
  "Uses a list comprehension to call function f on a list of tuple(s) contained
   within items"
  (list "<dl>\n"
	(lc ((<- (tuple t d) items))
	  (io:format "<dt>~s:\n<dd>~s\n" `(,(funcall f t) ,(funcall f d))))
	"</dl>"))

(defun render (items em)
  "Is a higher order function which takes a list of items and an em emphasis.
   It calls to-html to with the items list and an anonymous function to apply
   the em emphasis to them"
  (to-html items
	   (lambda (text)
	     (++ "<" em ">" text "</" em ">"))))

(defun render ()
  #| Example output:
   lfe> (my-module:render)
   <dt><b>D&D</b>:
   <dd><b>Dungeons and Dragons</b>
   ("<dl>\n" (ok) "</dl>")
  |#					;
  (render (list (tuple "D&D" "Dungeons and Dragons")) "b")) ;

(defun sum
  "An example of a non tail-recursive function.  It is not tail-recursive
   because the last call is to the +/2 function and not sum"
  ((0) 0)
  ((n) (+ (sum (- n 1)) n)))

(defun do-sum (n)
  "Helper function to the tail-recursive version of sum"
  (do-sum n 0))

(defun do-sum
  "An example of a tail-recursive function.  Now there is the total accumulator.
   The final call to do-sum is do-sum along with the total accumulator."
  ((0 total) total)
  ((n total) (do-sum (- n 1) (+ total n))))

(defun rev
  "Non tail-recursive reverse function for the same reason as the sum function"
  (((cons x therest)) (++ (rev therest) (list x)))
  ((()) '()))

(defun tailrev (lst)
  (tailrev lst '()))

(defun tailrev
  "Tail-recursive version of rev"
  (((cons x therest) acc) (tailrev therest (cons x acc)))
  ((() acc) acc))