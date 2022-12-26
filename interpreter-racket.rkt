#lang racket

; (require racket/hash)
(require odysseus/debug)
(require "errors.rkt")

(define context? hash?)

(define initial-context (hash))

(define primitive-functions
  (hash
    'inc add1
    'dec sub1
    'eq (λ (a b) (if (equal? a b) 'true 'false))))

(define (elementary-value? v)
  (or (equal? v 'nil) (equal? v 'true) (equal? v 'false) (equal? v 'else) (integer? v) (string? v)))

(define (get-primitive-function v)
  (hash-ref primitive-functions v #f))

(define (primitive-function-application? expr)
  (and
    (list? expr)
    (get-primitive-function (car expr))))

(define (get-from-context symbol context)
  (hash-ref context symbol #f))

(define symbol-in-the-context? get-from-context)

(define (add-to-context context symbol value)
  (hash-set context symbol value))

(define (next-condition cond-expr)
  (caadr cond-expr))

(define (next-cond-body cond-expr)
  (cdadr cond-expr))

(define (lambda-expression? expr)
  (equal? (car expr) 'lambda))

(define (get-lambda-argument-names lambda-expression)
  (cadr lambda-expression))

(define (get-lambda-body lambda-expression)
  (cddr lambda-expression))

(define (bind-names arg-names arg-values context)
  (cond
    ((and (empty? arg-names) (empty? arg-values))
      context)
    ((or (empty? arg-names) (empty? arg-values))
      (err "number of parameters in the function definition and number given to function don't match"))
    (else
      (bind-names
        (cdr arg-names)
        (cdr arg-values)
        (add-to-context context (car arg-names) (eval (car arg-values) context))))))

(define get-let-bindings cadr)

(define get-let-body cddr)

(define (eval-let-form let-bindings let-body context)
  (cond
    ((empty? let-bindings)
      (eval-sequence let-body context))
    (else
      (eval-sequence (cdr let-body) (add-to-context context (caar let-bindings) (cadar let-bindings))))))

(define (apply-primitive-function expr context)
  (apply
    (get-primitive-function (car expr))
    (map (λ (x) (eval x context)) (cdr expr))))

(define (user-function-application? expr context)
  (and
    (list? expr)
    (symbol-in-the-context? (car expr) context)))

(define (apply-function expr context)
  (let* ((arg-values (map (λ (arg-value) (eval arg-value context)) (cdr expr)))
        (lambda-expr (get-from-context (car expr) context))
        (lambda-arg-names (get-lambda-argument-names lambda-expr))
        (lambda-body (get-lambda-body lambda-expr)))
    (eval-sequence lambda-body (bind-names lambda-arg-names arg-values context))))

(define (eval-sequence expr context)
  (cond
    ((empty? (cdr expr))
      (eval (car expr) context))
    (else
      (eval-sequence
        (cdr expr)
        (eval (car expr) context)))))

(define (eval expr context)
  ; (--- expr)
  (cond
    ((context? expr)
      (err "returned wrong value"))
    ((elementary-value? expr)
      ; (--- 111 expr (elementary-value? expr))
      expr)
    ((symbol-in-the-context? expr context)
      ; (--- 111 context)
      (get-from-context expr context))
    ((equal? (car expr) 'def)
      ; (--- 222)
      (add-to-context context (cadr expr) (eval (cddr expr) context)))
    ((equal? (car expr) 'lambda)
      ; (--- 333)
      expr)
    ((equal? (car expr) 'defun)
      ; (--- 444)
      (eval (cons 'def (cons (cadr expr) (cons 'lambda (cddr expr)))) context))
    ((equal? (car expr) 'if)
      ; (--- 555)
      (if (equal? 'false (eval (cadr expr) context))
        (eval (cadddr expr) context)
        (eval (caddr expr) context)))
    ((equal? (car expr) 'cond)
      ; (--- 666 (eval (next-condition expr) context))
      (if (equal? 'false (eval (next-condition expr) context))
        (eval (cons 'cond (cddr expr)) context)
        (eval-sequence (next-cond-body expr) context)))
    ((equal? (car expr) 'let)
      ; (--- 777)
      (eval-let-form (get-let-bindings expr) (get-let-body expr)))
    ((equal? (car expr) 'progn)
      ; (--- 888)
      (eval-sequence (cdr expr) context))
    ((primitive-function-application? expr)
      ; (--- 999)
      (apply-primitive-function expr context))
    ((user-function-application? expr context)
      ; (--- 101010)
      (apply-function expr context))
    (else
      (err (format "unable to evaluate expression ~a" expr)))))

(eval-sequence
  '(
    (defun gt (a b)
      (if (eq a b)
        false
        (if (eq b 0)
          true
          (if (eq a 0)
            false
            (gt (dec a) (dec b))))))

    (defun lt (a b)
      (if (eq a b)
        false
        (if (gt a b)
          false
          true)))

    (defun add (a b)
      (if (eq a 0)
        b
        (if (gt a 0)
          (add (dec a) (inc b))
          (add (inc a) (dec b)))))

    (defun mul (a b)
      (if (eq a 0)
        0
        (if (eq b 0)
          0
          (if (eq a 1)
            b
            (add b (mul (dec a) b))))))

    (defun fact (i)
      (if (eq i 1)
          1
          (mul i (fact (dec i)))))

    ; (gt 5 1))
    ;
    ;   initial-context)

    (cond
      ((gt 10 20)
        (fact 1000000))
      ((gt 1 3)
        (fact 7))
      ((lt 1 2)
        (fact 5))
      (else
        true)))

  initial-context)
