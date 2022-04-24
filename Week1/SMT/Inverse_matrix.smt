; Input
(declare-const TopLeft Int)
(declare-const TopRight Int)
(declare-const BottomLeft Int)
(declare-const BottomRight Int)
;Determinant 
(declare-const Determinant Int)
;Output
(declare-const InvTopLeft Int)
(declare-const InvTopRight Int)
(declare-const InvBottomLeft Int)
(declare-const InvBottomRight Int)

;Assert input
;|3 1|
;|5 2|
(assert (= TopLeft 3 ))
(assert (= TopRight 1 ))
(assert (= BottomLeft 5 ))
(assert (= BottomRight 2 ))
;Compute the determinant
(assert (= Determinant (- (* TopLeft BottomRight) (* BottomLeft TopRight) ) ) )
;Multiply transformed matrix by 1/determinant and ensure int input
(assert (and (not (= Determinant 0)) (= (mod BottomRight Determinant ) 0) (= InvTopLeft (* BottomRight (/ 1 Determinant) ) )) )
(assert (and (not (= Determinant 0)) (= (mod TopLeft Determinant) 0)  (= InvBottomRight (* TopLeft (/ 1 Determinant) ) )) )
(assert (and (not (= Determinant 0)) (= (mod BottomLeft Determinant) 0) (= InvBottomLeft (* BottomLeft (- 0 1) (/ 1 Determinant) ))))
(assert (and (not (= Determinant 0)) (= (mod TopRight Determinant) 0) (= InvTopRight (* TopRight (- 0 1) (/ 1 Determinant) ))))
;Checks
(check-sat)
(get-value (InvTopLeft))
(get-value (InvTopRight))
(get-value (InvBottomLeft))
(get-value (InvBottomRight))

