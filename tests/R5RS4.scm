(define-macro (test . L)
   `(begin
;       (print ',@L)
       (write ,@L)
       (print)))

;; all tests from R5RS

(test (apply + (list 3 4)))
(define compose
   (lambda (f g)
      (lambda args
	 (f (apply g args)))))
(test ((compose sqrt *) 12 75))
(print)
(test (map cadr '((a b) (d e) (g h))))
(test (map (lambda (n) (expt n n))
	   '(1 2 3 4 5)))
(test (map + '(1 2 3) '(4 5 6)))
(test (let ((count 0))
	 (map (lambda (ignored)
		 (set! count (+ count 1))
		 count)
	      '(a b))))
(print)
(test (let ((v (make-vector 5)))
	 (for-each (lambda (i)
		      (vector-set! v i (* i i)))
		   '(0 1 2 3 4))
	 v))
(print)
(test (force (delay (+ 1 2))))
(test (let ((p (delay (+ 1 2))))
	 (list (force p) (force p))))
(define a-stream
   (letrec ((next
	     (lambda (n)
		(cons n (delay (next (+ n 1)))))))
      (next 0)))
(define head car)
(define tail
   (lambda (stream) (force (cdr stream))))
(test (head (tail (tail a-stream))))
(define count 0)
(define p
   (delay (begin (set! count (+ count 1))
		 (if (> count x)
		     count
		     (force p)))))
(define x 5)
;(test p)
(test (force p))
;(test p)
(test (begin (set! x 10)
	     (force p)))
(print)
(test (call-with-values (lambda () (values 4 5))
			(lambda (a b) b)))
(test (call-with-values * -))
(print)
;; following test needs call/cc
;; TODO: change once call/cc exists
;; added in callcc.scm
; (let ((path '())
;       (c #f))
;    (let ((add (lambda (s)
; 		 (set! path (cons s path)))))
;       (dynamic-wind
; 	 (lambda () (add 'connect))
; 	 (lambda ()
; 	    (add (call-with-current-continuation
; 		  (lambda (c0)
; 		     (set! c c0)
; 		     'talk1))))
; 	 (lambda () (add 'disconnect)))
;       (if (< (length path) 4)
; 	  (c 'talk2)
; 	  (reverse path))))
;(print)

;; the following tests need eval.
;; TODO: change, once 'eval' is implemented.
;(test (eval '(* 7 3) (scheme-report-environment 5)))
;(test (let ((f (eval '(lambda (f x) (f x x))
;		     (null-environment 5))))
;	 (f + 10)))
;(print)
