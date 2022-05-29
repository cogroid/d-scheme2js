(define (f)
   (g))

(define (g)
   (print "testing"))


(f)
(set! f #f)


;; can't be tested automatically.
;; normally the print function should be completely inlined.
(define (f1)
   (define (g)
      (define (h)
	 (define (k)
	    #f)
	 (k) (k)
	 (set! k #f)
	 (print 1))
      (h) (h))
   (g) (g))
(f1) (f1)

(define (foo) #t)
(let ((bar foo))
   (print (bar)))

(define (bar)
   (define (l)
      (let ((v '#(1 2 3 4 5)))
	 (let loop ((i 0))
	    (let ((el (vector-ref v i)))
	       (if (even? el)
		   el
		   (loop (+fx i 1)))))))
   (let ((x (l)))
      (+ x 3)))
(print (bar))
