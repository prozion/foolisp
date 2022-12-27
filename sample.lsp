(defun fact-1_2 (i)
  (if (eq i 1)
      1
      (mul i (fact (dec i)))))

(fact-1_2 5)
