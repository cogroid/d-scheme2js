(print
 (let ((v (list (let loop () (if (even? 2) 5 (loop))))))
    v))

(let ((dummy #f))
   (define (loop obj)
      (print obj)
      (unless (null? obj)
	 (for-each (lambda (b) (loop b)) obj)))
   (print (loop '(() ()))))

(print (let loop ((i 0))
	  (case i
	     ((0) (loop (+ i 1)))
	     ((1) 2))))

(let loop ((i 0))
   (when i
      (begin
	 (print i)
	 (loop #f))))
