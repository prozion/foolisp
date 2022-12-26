#lang racket

(provide (all-defined-out))

(define (err . args)
  (error (apply format args)))
