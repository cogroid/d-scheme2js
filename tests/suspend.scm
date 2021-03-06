(js rhinoSaveK)

(define (t1)
   (print "before")
   (print (suspend (lambda (resume)
		      (print "in suspend")
		      (rhinoSaveK resume))))
   (print "after"))
(print "t1")
(t1)

(define (t2)
   (let loop ((i 0))
      (when (< i 4)
	 (print "before " i)
	 (print (suspend (lambda (resume)
			    (print "in")
			    (rhinoSaveK resume))))
	 (print "after " i)
	 (loop (+ i 1))))
   (print "after loop"))
(print "t2")
(t2)
   

(define (t3)
   (let loop ((i 0))
      (when (< i 2)
	 (let loop2 ((j 0))
	    (when (< j 2)
	       (print "before " i " " j)
	       (print (suspend (lambda (resume)
				  (print "in")
				  (rhinoSaveK resume))))
	       (print "after " i " " j)
	       (loop2 (+ j 1))))
	 (loop (+ i 1))))
   (print "after loop"))
(print "t3")
(t3)
