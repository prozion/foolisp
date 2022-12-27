#!/usr/bin/racket

#lang racket

(require odysseus/debug)

(define (cons* v1 v2)
  (hash 'car v1 'cdr v2))

(define (car* cns)
  (hash-ref cns 'car))

(define (cdr* cns)
  (hash-ref cns 'cdr))

(define nil 0)

(define (char-range c1 c2)
  (map integer->char (inclusive-range (char->integer c1) (char->integer c2))))

(define (s? char)
  ; (indexof (list #\space #\tab #\newline) char))
  (index-of (list 32 9 10) (char->integer char)))

(define (S? char)
  (or
    (index-of (char-range #\0 #\9) char)
    (index-of (char-range #\a #\z) char)
    (index-of (char-range #\A #\Z) char)
    (index-of (string->list "-_?!") char)))

(define (open-paren? char)
  (= 40 (char->integer char)))

(define (close-paren? char)
  (= 41 (char->integer char)))

(define (paren? c)
  (or (open-paren? c) (close-paren? c)))

(define content (file->string (vector-ref (current-command-line-arguments) 0)))

(define current-token empty)

(define token-number 0)

(define *tokens* empty)

(define (push tokens token)
  (append tokens (list token)))

(define (add-token! token)
  (cond
    ((empty? token)
      #f)
    (else
      (set! *tokens* (push *tokens* (cons token nil)
      #t)))

(for ((c content))
  (cond
    ((or (s? c) (paren? c))
      (add-token! current-token)
      (set! current-token empty))
    ((S? c)
      (set! current-token (push current-token c)))
    (else
      (void))))

(println *tokens*)
