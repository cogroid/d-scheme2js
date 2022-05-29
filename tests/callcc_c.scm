
(define (t16)
   (define kks '())
   (define first #t)
   
   (let loop ((i 0))
      (when (< i 2)
	 (let loop ((j 0))
	    (when (< j 2)
	       (display i)
	       (display " ")
	       (display j)
	       (display " ")
	       (call/cc (lambda (k)
			   (if first
			       (set! kks (cons k kks)))))
	       (print i "_" j)
	       (loop (+ j 1))))
	 (loop (+ i 1))))

   (if first
       (set! first #f))
   (unless (null? kks)
      (let ((k (car kks)))
	 (set! kks (cdr kks))
	 (k #t))))
(print "t16")
(t16)

(define (t17)
   (define k #f)
   (define first #t)
   (define funs '())
   
   (call/cc (lambda (kk) (set! k kk)))
   
   (let ((x 3))
      (set! funs (cons (lambda () (set! x (+ x 1)) (print x))
		       funs)))

   (when first
      (set! first #f)
      (k #f))
   (for-each (lambda (f) (f)) funs))
(print "t17")
(t17)

(define (t18)
   (define k #f)
   (define first #t)
   (define funs '())
   
   (let ((x 3))
      (call/cc (lambda (kk) (set! k kk)))
   
      (set! funs (cons (lambda () (set! x (+ x 1)) (print x))
		       funs)))

   (when first
      (set! first #f)
      (k #f))
   (for-each (lambda (f) (f)) funs))
(print "t18")
(t18)

(define (t19)
   (define k #f)
   (define iters 2)
   (define funs '())

   (let ((y 3))
      (call/cc (lambda (kk) (set! k kk)))
      (let ((x 3))
	 (set! funs (cons (lambda ()
			     (set! x (+ x 1)) (print x)
			     (set! y (+ y 1)) (print y))
			  funs)))
      
      (when (> iters 0)
	 (set! iters (- iters 1))
	 (k #f)))
   (for-each (lambda (f) (f)) funs))
(print "t19")
(t19)

(define (t20)
   (define k #f)
   (define iters 1)
   (define funs '())

   (let* ((x 3)
	  (f (lambda () ;; make function too big for inlining
		(+ 1 2) (+ 2 3) (+ 3 4) (+ 4 5)
		(+ 1 2) (+ 2 3) (+ 3 4) (+ 4 5)
		(+ 1 2) (+ 2 3) (+ 3 4) (+ 4 5)
		(+ 1 2) (+ 2 3) (+ 3 4) (+ 4 5)
		(+ 1 2) (+ 2 3) (+ 3 4) (+ 4 5)
		(print x))))
      (f)
      (call/cc (lambda (kk) (set! k kk)))
      (set! x (+ x 1))
      (f))

   (when (> iters 0)
      (set! iters (- iters 1))
      (k #f)))
(print "t20")
(t20)

(define (t21)
   (define k #f)
   (define k2 #f)
   (define counter 0)
   (define iters 0)

   (let ((x (call/cc (lambda (k) counter))))
      (set! counter (+ 1 counter))
      (let ((y (call/cc (lambda (kk) (set! k kk) counter))))
	 (set! counter (+ 1 counter))
	 (let ((z (call/cc (lambda (kk) (unless k2 (set! k2 kk)) counter))))
	    (set! counter (+ 1 counter))
	    (print x y z))))

   (set! iters (+ iters 1))
   (cond
      ((= iters 1)
       (k -1))
      ((= iters 2)
       (k2 -2))
      (else
       'do-nothing)))
(print "t21")
(t21)


(define (t22)
   (define k #f)
   (define k2 #f)
   (define counter -1)
   (define iters 0)

   (letrec ((x (call/cc (lambda (k)
			   (set! counter (+ 1 counter))
			   counter)))
	    (y (call/cc (lambda (kk)
			   (set! k kk)
			   (set! counter (+ 1 counter))
			   counter)))
	    (z (call/cc (lambda (kk)
			   (unless k2 (set! k2 kk))
			   (set! counter (+ 1 counter))
			   counter))))
      (print x y z))

   (set! iters (+ iters 1))
   (cond
      ((= iters 1)
       (k -1))
      ((= iters 2)
       (k2 -2))
      (else
       'do-nothing)))
(print "t22")
(t22)

(define (t23)
   (letrec ((f (lambda () (print "f")))
	    (g (call/cc (lambda (k) k))))
      (when g
	 (set! f (lambda () (print "bad")))
	 (g #f))
      (f)))
(print "t23")
(t23)
   
