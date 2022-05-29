(define-macro (test . L)
   `(begin
;       (print ',@(reverse! (cdr (reverse (append L '(x))))))
       (write ,@L)
       (print)))

(define (t1)
   (define *k* #f)
   
   (define (even1 x)
      (if (= x 0)
	  (call/cc
	   (lambda (k)
	      (set! *k* k)
	      (cons #t #t)))
	  (odd1 (- x 1))))
   
   (define (odd1 x)
      (if (= x 0)
	  (call/cc
	   (lambda (k)
	      (set! *k* k)
	      (cons #f #f)))
	  (even2 (- x 1))))
   
   (define (even2 x)
      (if (= x 0)
	  (call/cc
	   (lambda (k)
	      (set! *k* k)
	      (cons #t #t)))
	  (odd2 (- x 1))))
   
   (define (odd2 x)
      (if (= x 0)
	  (call/cc
	   (lambda (k)
	      (set! *k* k)
	      (cons #f #f)))
	  (even1 (- x 1))))
   
   (test (let ((t (even1 10035)))
	    (print t)
	    (if (pair? t)
		(*k* (car t))
		t)))
	       
   
   (test (let ((t (odd1 10055)))
	    (print t)
	    (if (pair? t)
		(*k* (car t))
		t)))
   
   (test (let ((t (even2 10088)))
	    (print t)
	    (if (pair? t)
		(*k* (car t))
		t)))
   
   (test (let ((t (odd2 10070)))
	    (print t)
	    (if (pair? t)
		(*k* (car t))
		t))))
(t1)



; ;; tail-recs
; (define (f1 x y)
;    (if (> y 0)
;        (f2 x (- y 1))
;        x))
; (define (f2 x y)
;    (f3 x y))
; (define (f3 x y)
;    (f4 x y))
; (define (f4 x y)
;    (f5 x y))
; (define (f5 x y)
;    (f6 x y))
; (define (f6 x y)
;    (f7 x y))
; (define (f7 x y)
;    (f1 x y))

; ;; not-tail-rec
; (define (not-tail-rec)
;    (+ (f1 2 15000)
;       3))

; ;; partially tail-rec

; (define (g1)
;    (g2))
; (define (g2)
;    (g3))
; (define (g3)
;    (g4))
; (define (g4)
;    (g5))
; (define (g5)
;    (g6))
; (define (g6)
;    (g7))
; (define (g7)
;    (g8))
; (define (g8)
;    (not-tail-rec))

; (test (g1))

; (define (h1)
;    (+ 3 2))

; (test (h1))

; (define (h2)
;    3)
; (test (h2))


; (define (fr1 x z)
;    (fr2 x (+ z 1)))
; (define (fr2 x z)
;    (fr3 x (+ z 1)))
; (define (fr3 x z)
;    (fr4 x (+ z 1)))
; (define (fr4 x z)
;    (gr x (+ z 1)))
; (define (gr x z)
;    (if (= x 0)
;        z
;        (+ 1 (hr1 (- x 1) (+ z 1) 1000))))
; (define (hr1 x z y)
;    (hr2 x (+ z 1) y))
; (define (hr2 x z y)
;    (hr3 x (+ z 1) y))
; (define (hr3 x z y)
;    (hr4 x (+ z 1) y))
; (define (hr4 x z y)
;    (if (= y 0)
;        (fr1 x (+ z 1))
;        (hr1 x (+ z 1) (- y 1))))

; (test (fr1 3 0))

; (define (tt vvv)
;    (define (f x z)
;       z)
;    (define (h x z)
;       (h (- x 1) (+ z 1)))
;    (set! f h)
;    (set! h (lambda (x z)
; 	      (if (<= x 0)
; 		  z
; 		  (f (- x 2) (+ z 1)))))

;    (f vvv 0))

; (test (tt 10000))
