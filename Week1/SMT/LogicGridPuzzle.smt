; Input
(declare-const A Int)
(declare-const B Int)
(declare-const C Int)
(declare-const D Int)

;Condition constants
(declare-const Condition1 Bool)
(declare-const Condition2 Bool)
(declare-const Condition3 Bool)

;Ensure that number is only used once
(assert (distinct A B C D))

;Add constraint on possible values
(assert (and (>= A 1) (<= A 4)))
(assert (and (>= B 1) (<= B 4)))
(assert (and (>= C 1) (<= C 4)))
(assert (and (>= D 1) (<= D 4)))

;Conditions defined by question
(assert (= Condition1 (< (* C D) 10)))
(assert (= Condition2 (> (* A C) 7)))
(assert (= Condition3 (< (* A A) 9)))

;All conditions are met?
(assert (and Condition1 Condition2 Condition3))
(check-sat)
(get-model)