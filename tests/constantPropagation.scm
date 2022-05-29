;; nothing yet
;; should look at the code to see if propagation actually worked.

(define (foo x)
   (if (= x 0) (set! x #f))
   (print x))
(foo 1)
(foo 0)

(define (bar x)
   (set! x 3)
   (print x))
(bar 1)

(define (toto y)
   (let ((x 0))
      (if (= y 0)
	  (set! x 1)
	  (set! x 1))
      (print x)))
(toto 2)
