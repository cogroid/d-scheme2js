(module moduleC_b
  (export (macro foo)
	  -x-x
	  (fun::bool x::bint ::bstring))
  (scheme2js-pragma (-x-x (JS XX))))

(define-macro (foo x) (string-append x "yyy"))
