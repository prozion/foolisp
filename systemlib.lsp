(defun cons (a b)
  (lambda (m)
    (if m a b)))

(defun car (cns)
  (cns true))

(defun cdr (cns)
  (cns false))

(defun not (x)
  (if (eq x false)
    true
    false))

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

(defun len (lst)
  (if (eq (cdr lst) nil)
    1
    (inc (len (cdr lst)))))
