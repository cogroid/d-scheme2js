(define-macro (test . L)
   `(begin
       (print ',@L)
       (write ,@L)
       (print)))

(define-macro (ifn test exp1 exp2)
   `(if ,test ,exp2 ,exp1))

(test (ifn "testing"
	   1
	   2))


(test `(1 2 3 ,@(list 3 4)))
(test `(1 2 3 . ,@(list 3 4)))
(test `(1 2 3 . ,(list 3 4)))


(cond-expand
   (scheme2js
    (let ((o (js-new (lambda () #unspecified))))
       (set! o.x (js-new (lambda () #unspecified)))
       (set! o.x.y (lambda (a b) (print "foo")))
       (o.x.y 1 2)
       (let* ((k (js-field o "x"))
	     (l (js-field k "y")))
	  (l 1 2))
        (let ((k (js-field o "x")))
	   (k.y 1 2))
       ((js-field (js-field o "x") "y") 1 2)
       ((js-field o "x").y 1 2)
       (let ((f1 "x")
       	     (f2 "y"))
       	  (let* ((k (js-field o f1))
		 (l (js-field k f2)))
       	     (l 1 2))
       	  (let ((k (js-field o f1)))
       	     (k.y 1 2))
       	  ((js-field (js-field o f1) f2) 1 2)
       	  ((js-field o f1).y 1 2))))
   (else
    (print "foo")
    (print "foo")
    (print "foo")
    (print "foo")
    (print "foo")
    (print "foo")
    (print "foo")
    (print "foo")
    (print "foo")))
