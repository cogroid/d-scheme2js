(define-macro (test . L)
   `(begin
       (print ',@L)
       (write ,@L)
       (print)))

(for-each (lambda (a b c d e f)
	     (display (+ a b c d e f)))
	  '(1 2 3) ; a
	  '(2 3 4) ; b
	  '(3 4 5) ; c
	  '(4 5 6) ; d
	  '(5 6 7) ; e
	  '(6 7 8) ; f
	  )
(print)

(for-each (lambda (a b c)
	     (display (+ a b c)))
	  '(1 2 3) ; a
	  '(2 3 4) ; b
	  '(3 4 5) ; c
	  )
(print)

(for-each (lambda (a b)
	     (display (+ a b)))
	  '(1 2 3) ; a
	  '(2 3 4) ; b
	  )
(print)

(for-each (lambda (a)
	     (display a))
	  '(1 2 3) ; a
	  )
(print)

(test (map (lambda (a b c d e f)
	      (+ a b c d e f))
	   '(1 2 3) ; a
	   '(2 3 4) ; b
	   '(3 4 5) ; c
	   '(4 5 6) ; d
	   '(5 6 7) ; e
	   '(6 7 8) ; f
	   ))
(print)

(test (map (lambda (a)
	      a)
	   '(1 2 3) ; a
	   ))
(print)

(test (map (lambda (a b)
	      (+ a b))
	   '(1 2 3) ; a
	   '(2 3 4) ; b
	   ))
(print)

(test (map (lambda (a b c)
	      (+ a b c))
	   '(1 2 3) ; a
	   '(2 3 4) ; b
	   '(3 4 5) ; c
	   ))
(print)

(define (bad x) x)
(if #f (set! bad #f))

(print 1)
(print (map! (lambda (a b c d e f)
		(if #f (bad a))
		(+ a b c d e f))
	     (list 1 2 3) ; a
	     '(2 3 4) ; b
	     '(3 4 5) ; c
	     '(4 5 6) ; d
	     '(5 6 7) ; e
	     '(6 7 8) ; f
	     ))

(print 2)
(print (map! (lambda (a)
	       (if #f (bad a))
	       a)
	    (list 1 2 3) ; a
	    ))

(print 3)
(print (map! (lambda (a b)
		(if #f (bad a))
		(+ a b))
	     (list 1 2 3) ; a
	     '(2 3 4) ; b
	     ))

(print 4)
(print (map! (lambda (a b c)
		(if #f (bad a))
		(+ a b c))
	     (list 1 2 3) ; a
	     '(2 3 4) ; b
	     '(3 4 5) ; c
	     ))
(print)

(print 'filter 1)
(print (filter (lambda (a)
		  (if #f (bad a))
		  (pair? a))
	       (list 1 2 3 4 5 6 7 8 9) ; a
	     ))
(print (filter (lambda (a)
		  0)
	       (list 1 2 3 4 5 6 7 8 9)
	     ))

(let ((filter (if #t filter #f)))
   (print (filter (lambda (a)
		     (if #f (bad a))
		     (pair? a))
		  (list 1 2 3 4 5 6 7 8 9) ; a
		  ))
   (print (filter (lambda (a)
		     0)
		  (list 1 2 3 4 5 6 7 8 9)
		  )))

(print 2)
(print 'filter! 1)
(print (filter! (lambda (a)
		   (if #f (bad a))
		   (pair? a))
		(list 1 2 3 4 5 6 7 8 9) ; a
	     ))

(define (f1 x y)
   (if (> y 0)
       (f2 x (- y 1))
       x))
(define (f2 x y)
   (f3 x y))
(define (f3 x y)
   (f4 x y))
(define (f4 x y)
   (f5 x y))
(define (f5 x y)
   (f6 x y))
(define (f6 x y)
   (f7 x y))
(define (f7 x y)
   (f1 x y))

(define (map-fun)
   (map (lambda (a b)
	   (f1 (+ a b) 20))
	'(1 2 3) ; a
	'(2 3 4) ; b
	))

(define (g1)
   (g2))
(define (g2)
   (g3))
(define (g3)
   (g4))
(define (g4)
   (g5))
(define (g5)
   (g6))
(define (g6)
   (g7))
(define (g7)
   (g8))
(define (g8)
   (map-fun))

(test (g1))


(define (any-1)
   (print (any (lambda (x) (and (> x 7) x)) '(1 2 3 4 5 6 7 8)))
   (print (any? (lambda (x) (and (> x 7) x)) '(1 2 3 4 5 6 7 8)))
   (print (any (lambda (x) (and (> x 0) x)) '(1 2 3 4 5 6 7 8)))
   (print (any? (lambda (x) (and (> x 0) x)) '(1 2 3 4 5 6 7 8)))
   (print (any (lambda (x) (and (> x 5) x)) '(1 2 3 4)))
   (print (any? (lambda (x) (and (> x 5) x)) '(1 2 3 4)))
   (print (any (lambda (x) (and (> x 2) x)) '(1 2 3 4)))
   (print (any? (lambda (x) (and (> x 2) x)) '(1 2 3 4)))
   (print (every (lambda (x) (and (<= x 8) x)) '(1 2 3 4 5 6 7 8)))
   (print (every? (lambda (x) (and (<= x 8) x)) '(1 2 3 4 5 6 7 8)))
   (print (every (lambda (x) (and (> x 1) x)) '(1 2 3 4 5 6 7 8)))
   (print (every? (lambda (x) (and (> x 1) x)) '(1 2 3 4 5 6 7 8)))
   (print (every (lambda (x) (and (> x 2) x)) '(1 2 3 4)))
   (print (every? (lambda (x) (and (> x 2) x)) '(1 2 3 4)))
   'done)

(test (any-1))

(with-handler
 (begin
    (display "before")
    (lambda (e)
       (display "after")))
 (car '()))

(let* ((l1 '(a b))
       (l2 (list 'a 'b))
       (l `(1 2 ,l1 3 ,l2 4 ,l1 6)))
   (print (remq l1 l))
   (print (delete l1 l))
   (remq! l1 l)
   (print l)
   (delete! l1 l)
   (print l))

; (let ((ht (make-hashtable)))
;    (for-each (lambda (p)
; 		(hashtable-put! ht (car p) (cadr p)))
; 	     '((x 1)
; 	       (2 y)
; 	       ("testing" 3)
; 	       ((1 . 2) 5)))
;    (hashtable-for-each ht
; 		       (lambda (k e)
; 			  (print k " " e))))

(print (substring=? "abcdef" "ab9989898" 2))
(print (substring=? "abcdef" "ab9989898" 3))
(print (substring-at? "abcdefghij" "def" 3))
(print (substring-at? "abcdefghij" "def" 2))
(print (substring-at? "abcdefghij" "defz" 3))
(print (substring-at? "abcdefghij" "defz" 3 3))

(print (string-upcase "foo"))
(print (string-downcase "bAr"))
(print (string-capitalize "fooBar"))
