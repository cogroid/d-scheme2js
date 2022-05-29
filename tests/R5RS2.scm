(define-macro (test . L)
   `(begin
;       (print ',@L)
       (write ,@L)
       (print)))

;; all tests from R5RS

(define (part1)
   (define x 0)
   (test (begin (set! x 5)
		(+ x 1)))
   (begin
      (display "4 plus 1 equals ")
      (display (+ 4 1)))
   
   (test (do ((vec (make-vector 5))
	      (i 0 (+ i 1)))
	     ((= i 5) vec)
	     (vector-set! vec i i)))
   (test (let ((x '(1 3 5 7 9)))
	    (do ((x x (cdr x))
		 (sum 0 (+ sum (car x))))
		((null? x) sum))))
   (print)
   (test (let loop ((numbers '(3 -2 1 6 -5))
		    (nonneg '())
		    (neg '()))
	    (cond ((null? numbers) (list nonneg neg))
		  ((>= (car numbers) 0)
		   (loop (cdr numbers)
			 (cons (car numbers) nonneg)
			 neg))
		  ((< (car numbers) 0)
		   (loop (cdr numbers)
			 nonneg
			 (cons (car numbers) neg))))))
   ;; TODO: delay
   (test `(list ,(+ 1 2) 4))
   (test (let ((name 'a)) `(list ,name ',name)))
   (test `(a ,(+ 1 2) ,@(map abs '(4 -5 6)) b))
   (test `(( foo ,(- 10 3)) ,@(cdr '(c)) . ,(car '(cons))))
   (test `#(10 5 ,(sqrt 4) ,@(map sqrt '(16 9)) 8))
   (print)
   (test `(a `(b ,(+ 1 2) ,(foo ,(+ 1 3) d) e) f))
   (test (let ((name1 'x)
	       (name2 'y))
	    `(a `(b ,,name1 ,',name2 d) e)))
   (print)
   (test (quasiquote (list (unquote (+ 1 2)) 4)))
   (test '(quasiquote (list (unquote (+ 1 2)) 4)))
   (print))
(part1)

(define (part2)
   ;; TODO scheme2js and bigloo are known not to be compliant.
   ;(test (let ((=> #f))
   ;	  (cond (#t => 'ok))))
   ;(print)
   (define add3
      (lambda (x) (+ x 3)))
   (test (add3 3))
   (let ((dummy 0))
      (define first car)
      (test (first '(1 2))))
   (print)
   (test (let ((x 5))
	    (define foo (lambda (y) (bar x y)))
	    (define bar (lambda (a b) (+ (* a b) a)))
	    (foo (+ x 3))))
   (test (let ((x 5))
	    (letrec ((foo (lambda (y) (bar x y)))
		     (bar (lambda (a b) (+ (* a b) a))))
	       (foo (+ x 3)))))
   (print)
   (test (eqv? 'a 'a))
   (test (eqv? 'a 'b))
   (test (eqv? 2 2))
   (test (eqv? '() '()))
   (test (eqv? 1000000000 1000000000))
   (test (eqv? (cons 1 2) (cons 1 2)))
   (test (eqv? (lambda () 1)
	       (lambda () 2)))
   (test (eqv? #f 'nil))
   (test (let ((p (lambda (x) x)))
	    (eqv? p p)))
   ; don't test unspecified cases

   (let ((dummy 0))
      (define gen-counter
	 (lambda ()
	    (let ((n 0))
	       (lambda () (set! n (+ n 1)) n))))
      (test (let ((g (gen-counter)))
	       (eqv? g g)))
      (test (eqv? (gen-counter) (gen-counter))))

   (let ((dummy 0))
      (define gen-loser
	 (lambda ()
	    (let ((n 0))
	       (lambda () (set! n (+ n 1)) 27))))
      (test (let ((g (gen-loser)))
	       (eqv? g g)))
      ;; not testing unspecified behavior
      (eqv? (gen-loser) (gen-loser)))
   
   ;; unspecified again.
   (letrec ((f (lambda () (if (eqv? f g) 'both 'f)))
	    (g (lambda () (if (eqv? f g) 'both 'g))))
      (eqv? f g))
   
   (test (letrec ((f (lambda () (if (eqv? f g) 'f 'both)))
		  (g (lambda () (if (eqv? f g) 'g 'both))))
	    (eqv? f g)))
   (print "---")
   )
(part2)

(define (part3)
   ;; not displaying unspecified behavior:
   (eqv? '(a) '(a))
   (eqv? "a" "a")
   (eqv? '(b) (cdr '(a b)))
   
   (test (let ((x '(a)))
	    (eqv? x x)))
   
   (test (eq? 'a 'a))
   (eq? '(a) '(a))
   (test (eq? (list 'a) (list 'a)))
   (eq? "a" "a")
   (eq? "" "")
   (test (eq? '() '()))
   (eq? 2 2)
   (eq? #\A #\A)
   (test (eq? car car))
   (let ((n (+ 2 3)))
      (eq? n n))
   (test (let ((x '(a)))
	    (eq? x x)))
   (test (let ((x '#()))
	    (eq? x x)))
   (test (let ((p (lambda (x) x)))
	    (eq? p p)))
   (print "***")
   (test (equal? 'a 'a))
   (test (equal? '(a) '(a)))
   (test (equal? '(a (b) c)
		 '(a (b) c)))
   (test (equal? "abc" "abc"))
   (test (equal? 2 2))
   (test (equal? (make-vector 5 'a)
		 (make-vector 5 'a)))
   (equal? (lambda (x) x)
	   (lambda (y) y))
   (print "-*<>*-")

   (let ((dummy 0))
      (define (f) (make-string 3 #\*))
      (define (g) "***")
      ;; not testing string-set!
      ;(string-set! (f) 0 #\?)
      ;(string-set! (g) 0 #\?)
      ;(string-set! (symbol->string 'immutable)
      ;	     0
      ;	     #\?)
      )
   )
(part3)