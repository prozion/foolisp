(defun context? (v)
  (eq (car v) 'context))

(def initial-context (cons 'context nil))

; (define primitive-functions
;   (hash
;     'inc add1
;     'dec sub1
;     'eq equal?))
;
; (define (elementary-value? v)
;   (or (equal? v 'nil) (equal? v 'true) (equal? v 'false) (integer? v) (string? v)))
;
; (define (get-primitive-function v)
;   (hash-ref primitive-functions v #f))
;
; (define (primitive-function-application? expr)
;   (and
;     (list? expr)
;     (get-primitive-function (car expr))))
;
; (define (get-from-context symbol context)
;   (hash-ref context symbol #f))
;
; (define symbol-in-the-context? get-from-context)
;
; (define (add-to-context context symbol value)
;   (hash-set context symbol value))
;
; (define (lambda-expression? expr)
;   (equal? (car expr) 'lambda))
;
; (define (get-lambda-argument-names lambda-expression)
;   (cadr lambda-expression))
;
; (define (get-lambda-body lambda-expression)
;   (cddr lambda-expression))
;
; (define (bind-names arg-names arg-values context)
;   (cond
;     ((and (empty? arg-names) (empty? arg-values))
;       context)
;     ((or (empty? arg-names) (empty? arg-values))
;       (err "number of parameters in the function definition and number given to function don't match"))
;     (else
;       (bind-names
;         (cdr arg-names)
;         (cdr arg-values)
;         (add-to-context context (car arg-names) (eval (car arg-values) context))))))
;
; (define get-let-bindings cadr)
;
; (define get-let-body cddr)
;
; (define (eval-let-form let-bindings let-body context)
;   (cond
;     ((empty? let-bindings)
;       (eval-sequence let-body context))
;     (else
;       (eval-sequence (cdr let-body) (add-to-context context (caar let-bindings) (cadar let-bindings))))))
;
; (define (apply-primitive-function expr context)
;   (apply
;     (get-primitive-function (car expr))
;     (map (λ (x) (eval x context)) (cdr expr))))
;
; (define (user-function-application? expr context)
;   (and
;     (list? expr)
;     (symbol-in-the-context? (car expr) context)))
;
; (define (apply-function expr context)
;   (let* ((arg-values (map (λ (arg-value) (eval arg-value context)) (cdr expr)))
;         (lambda-expr (get-from-context (car expr) context))
;         (lambda-arg-names (get-lambda-argument-names lambda-expr))
;         (lambda-body (get-lambda-body lambda-expr)))
;     (eval-sequence lambda-body (bind-names lambda-arg-names arg-values context))))
;
; (define (eval-sequence expr context)
;   (cond
;     ((empty? (cdr expr))
;       (eval (car expr) context))
;     (else
;       (eval-sequence
;         (cdr expr)
;         (eval (car expr) context)))))
;
; (define (eval expr context)
;   (cond
;     ((context? expr)
;       (err "returned wrong value"))
;     ((elementary-value? expr)
;       expr)
;     ((symbol-in-the-context? expr context)
;       (get-from-context expr context))
;     ((equal? (car expr) 'def)
;       (add-to-context context (cadr expr) (eval (cddr expr) context)))
;     ((equal? (car expr) 'lambda)
;       expr)
;     ((equal? (car expr) 'defun)
;       (eval (cons 'def (cons (cadr expr) (cons 'lambda (cddr expr)))) context))
;     ((equal? (car expr) 'if)
;       (if (eval (cadr expr) context)
;         (eval (caddr expr) context)
;         (eval (cadddr expr) context)))
;     ((equal? (car expr) 'let)
;       (eval-let-form (get-let-bindings expr) (get-let-body expr)))
;     ((equal? (car expr) 'progn)
;       (eval-sequence (cdr expr) context))
;     ((primitive-function-application? expr)
;       (apply-primitive-function expr context))
;     ((user-function-application? expr context)
;       (apply-function expr context))
;     (else
;       (err (format "unable to evaluate expression ~a" expr)))))
