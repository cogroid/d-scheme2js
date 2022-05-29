(define (f)
   (define *fs* '())
   (define *k* #f)

   (let loop ((i 0))
      (when (<fx i 10)
	 (set! *fs* (cons (lambda () (print i)) *fs*))
	 (when (=fx i 8)
	    (set! *k* (call/cc (lambda (k) k))))
	 (loop (+fx i 1))))

   (when *k* (*k* #f))
   (for-each (lambda (f) (f)) *fs*))
(print "f")
(f)


(define (g)
   (define *k* #f)

   (define (h k)
      (set! *k* k))
   (define (foo)
      (when *k*
	 (let ((tmp *k*))
	    (set! *k* #f)
	    (print "k")
	    (tmp #f))))

   (if (eq? (cons 1 2) (cons 1 2))
       (set! h #f))

   (if (eq? (cons 1 2) (cons 1 2))
       (set! foo #f))

   (let loop ((i 0))
      (when (<fx i 2)
	 (print i)
	 (unless *k* (call/cc h))
	 (loop (+fx i 1))))

   (foo))
(print)
(print "g")
(g)
