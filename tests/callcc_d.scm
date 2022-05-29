(define (intercept f . args)
   (call/cc 
    (lambda (exit)
      (let ((normal-exit #f))
	 (dynamic-wind
	    (lambda () (print "before"))
	    (lambda ()
	       (let ((ret (apply f args)))
		  (set! normal-exit #t)
		  (cons 'ok ret)))
	    (lambda ()
	       (unless normal-exit
		  (call/cc
		   (lambda (x)
		      (exit (cons 'exit x)))))))))))

(define-macro (invoke-native f . args)
 `(begin
  (print "Invoke native " ',f)
  (let ((ret (intercept ,f ,@args)))
    (print "Returned from native " ',f " with: " ret)
    (if (eq? (car ret) 'exit)
    (begin
      (print " Invoking all protectors until next native call frame")
      ((cdr ret) 'foo))
    (cdr ret)))))

(define-macro (invoke-ulm f . args)
 `(begin
  (print "Invoke ulm " ',f)
  (let ((ret (,f ,@args)))
    (print "Returned from ulm " ',f " with: " ret)
    ret)))

(define (ulm1)
 (invoke-native nat1))

(define (nat1)
 (call/cc
  (lambda (x)
     (invoke-ulm ulm2 x)))
 (print "YYY"))

(define (ulm2 x)
 (invoke-native nat2 x))

(define (nat2 x)
 (x 'yeah))


(ulm1)
