(define-macro (get-exports file)
   (define (my-assq x L)
      (cond
	 ((null? L) #f)
	 ((and (pair? (car L))
	       (eq? (caar L) x))
	  (car L))
	 (else (my-assq x (cdr L)))))

   (with-input-from-file file
      (lambda ()
	 (let loop ((module-exports '()))
	    (let ((e (read)))
	       (if (eof-object? e)
		   (list 'quote (apply append module-exports))
		   ;; e is a module clause.
		   ;; skip the 'module' and 'module-name'
		   (let* ((a-list (cddr e))
			  (exports (my-assq 'export a-list)))
		      (loop (cons (cdr exports) module-exports)))))))))
