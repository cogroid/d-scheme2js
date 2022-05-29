;; regression tests, that did not fit into any other category.

(define (f x y) (print "f"))
(define (g) (print "g"))
(define (h) (print "h"))
(define (i) (print "i"))
(define y (< (abs 3) 0))

(print "evaluation order is unspecified. but between i and h there must be no other line")
(f (g) (begin (let loop () (if y (loop) (i))) (h)))
