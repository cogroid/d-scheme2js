;*=====================================================================*/
;*    Author      :  Florian Loitsch                                   */
;*    Copyright   :  2007-2009 Florian Loitsch, see LICENSE file       */
;*    -------------------------------------------------------------    */
;*    This file is part of Scheme2Js.                                  */
;*                                                                     */
;*   Scheme2Js is distributed in the hope that it will be useful,      */
;*   but WITHOUT ANY WARRANTY; without even the implied warranty of    */
;*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the     */
;*   LICENSE file for more details.                                    */
;*=====================================================================*/

(module interface
   (main my-main))

(define *ignored-prefixes* '())
(define *prefix* #f)

(define (interface-name var)
   (let ((str (if (string? var) var (symbol->string var))))
      (string-append *prefix* (remove-prefix str *ignored-prefixes*))))

(define (my-assq x L)
   (cond
      ((null? L) #f)
      ((and (pair? (car L))
	    (eq? (caar L) x))
       (car L))
      (else (my-assq x (cdr L)))))

(define (replace-id! export)
   (let ((js (my-assq 'JS export)))
      (when (not js)
	 (error "interface" "couldn't find JS clause for export: " export))
      (set-car! (cdr js) (interface-name (cadr js)))))

(define (do-exports)
   (print ";; ********* GENERATED DON'T EDIT ***********")
   (print ";; ********* GENERATED DON'T EDIT ***********")
   (print ";; ********* GENERATED DON'T EDIT ***********")
   (print ";; ********* GENERATED DON'T EDIT ***********")
   (let loop ()
      (let ((expr (read)))
	 (unless (eof-object? expr)
	    (when (not (eq? (car expr) 'module))
	       (error "interface" "expected 'module' clause" expr))
	    (let ((exports (my-assq 'export (cddr expr))))
	       (when (not exports)
		  (error "interface" "couldn't find export clause" expr))
	       (map replace-id! (cdr exports))
	       (pp expr))
	    (loop)))))

(define (print-interface export)
   (let ((js (my-assq 'JS export)))
      (when (not js)
	 (error "interface" "couldn't find JS clause for export: " export))
      (print "var " (interface-name (cadr js)) "=" (cadr js) ";")))
   
(define (do-js)
   (print "/* ********* GENERATED DON'T EDIT *********** */")
   (print "/* ********* GENERATED DON'T EDIT *********** */")
   (print "/* ********* GENERATED DON'T EDIT *********** */")
   (print "/* ********* GENERATED DON'T EDIT *********** */")
   (print "/* ********* GENERATED DON'T EDIT *********** */")
   (let loop ()
      (let ((expr (read)))
	 (unless (eof-object? expr)
	    (when (not (eq? (car expr) 'module))
	       (error "interface" "expected 'module' clause" expr))
	    (let ((exports (my-assq 'export (cddr expr))))
	       (when (not exports)
		  (error "interface" "couldn't find export clause" expr))
	       (map print-interface (cdr exports)))
	    (loop)))))

(define *out-file* #f)
(define *in-files* '())

(define *exports* #f)
(define *js* #f)

(define (handle-args args)
   (args-parse (cdr args)
      (section "Help")
      (("?")
       (args-parse-usage #f))
      ((("-h" "--help") (help "?,-h,--help" "This help message"))
       (args-parse-usage #f))
      (section "Misc")
      (("-o" ?file (help "The output file. '-' prints to stdout."))
       (set! *out-file* file))
      (("--interface-prefix" ?prefix (help "interface-prefix"))
       (set! *prefix* prefix))
      (("--ignored-prefixes" ?list
			     (help "scheme-list of ignored original prefixes"))
       (set! *ignored-prefixes* (with-input-from-string list read)))
      (("--js" (help "Generate JavaScript interface file."))
       (set! *js* #t))
      (("--exports" (help "Generate Export file."))
       (set! *exports* #t))
      (else
       (set! *in-files* (append! *in-files* (list else))))))

(define (my-main args)
   (handle-args args)
   (if (not *out-file*)
       (error "interface" "no out-file given" #f))
   (if (null? *in-files*)
       (error "interface" "no input-file(s) given" #f))
   (when (not (null? (cdr *in-files*)))
      (error "interface" "only one input-file is supported" *in-files*))
   (if (not *prefix*)
       (error "interface" "no prefix given" #f))
   (when (and *exports* *js*)
      (error "interface" "--js and --exports are mutually exclusive" #f))
   (when (and (not *exports*) (not *js*))
      (error "interface" "either --js or --exports must be specified" #f))

   (with-handler
      (lambda (e)
	 (delete-file *out-file*)
	 (exit 1))
      (with-output-to-file *out-file*
	 (lambda ()
	    (with-input-from-file (car *in-files*)
	       (lambda ()
		  (if *exports*
		      (do-exports)
		      (do-js)))))))
   (exit 0))
