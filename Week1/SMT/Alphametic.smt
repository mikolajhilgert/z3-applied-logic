;I+DID=TOO
;Declare alphabet
(declare-const I Int)
(declare-const D Int)
(declare-const T Int)
(declare-const O Int)

;For comparison
(declare-const Input Int)
(declare-const Output Int)

;Ensure that number is only used once
(assert (distinct I D T O))

;Add constraint on possible values
(assert (and (>= I 0) (<= I 9)))
(assert (and (>= D 0) (<= D 9)))
(assert (and (>= T 0) (<= T 9)))
(assert (and (>= O 0) (<= O 9)))

;Create an equation
(assert (= Input (+ (* 1 I) (+ (* 100 D) (* 10 I) (* 1 D)))))
(assert (= Output (+ (* 100 T) (* 10 O) (* 1 O))))
;Actual comparison
(assert (= Output Input) )

(check-sat)
(get-model)