; First Int - jug number, Second Int - step
(declare-fun B (Int Int) Int)

;Column limits. (Jug limits)
(declare-const Jug1_Max Int)
(declare-const Jug2_Max Int)
(declare-const Jug3_Max Int)

;Declare max steps
(declare-const MaxStep Int)

;Set Max consts
(assert (= Jug1_Max 8))
(assert (= Jug2_Max 5))
(assert (= Jug3_Max 3))

;Initial jug amounts
(assert (= (B 1 1) 8))
(assert (= (B 2 1) 0))
(assert (= (B 3 1) 0))

;Between 1 and MAX there exists a permutation [4,4,0].
;Step of [4,4,0] is the MAX.
;Z3 will define which step is the MAX.
(assert
    (exists ((step Int))
        (and
            (<= 1 step MaxStep)
            (= (B 1 step) 4)
            (= (B 2 step) 4)
            (= (B 3 step) 0)
            (= step MaxStep)
        ) 
    )
)


;1) No jugs exceedes MAX 
(assert 
    (forall ((step Int))
        (=>
            (<= 1 step MaxStep)
            (and
                (<= 0 (B 1 step) Jug1_Max)
                (<= 0 (B 2 step) Jug2_Max)
                (<= 0 (B 3 step) Jug3_Max)
            )
        )
    )
)


;2) No two same rows
(assert
    (not
        (exists ((step1 Int) (step2 Int))
            (and
                (<= 1 step1 MaxStep)
                (<= 1 step2 MaxStep)
                (distinct step1 step2)
                (and
                        (= (B 1 step1) (B 1 step2))
                        (= (B 2 step1) (B 2 step2))
                        (= (B 3 step1) (B 3 step2))
                )
            ) 
        )
    )
)

;For all rows Jug1+Jug2+Jug3 = 8
(assert
    (not
        (exists ((step Int))
            (and
                (<= 1 step MaxStep)
                (not
                    (=
                        (+
                            (B 1 step)
                            (B 2 step)
                            (B 3 step)
                        )
                        8   
                    )
                )
            ) 
        )
    )  
)

;For all two adjacent rows exactly 2 values are changed and exactly 1 value is not
(assert
    (forall ((step Int))
        (=>
            (<= 1 step (- MaxStep 1))
            (=
                (+
                    (ite (= (B 1 step) (B 1 (+ step 1))) 1 0)
                    (ite (= (B 2 step) (B 2 (+ step 1))) 1 0)
                    (ite (= (B 3 step) (B 3 (+ step 1))) 1 0)
                )
                1
            )
        )
    )
)
;Assure that poured between second and third jug correctly
(define-fun PouredBetweenSecondThird ((step Int)) Bool
    (ite
        (= (B 1 step) (B 1 (+ step 1)))
        (and
                (= (+ (B 2 step) (B 3 step)) (+ (B 2 (+ step 1)) (B 3 (+ step 1))))
                (or
                (= (B 2 (+ step 1)) 0)
                (= (B 2 (+ step 1)) Jug2_Max)
                (= (B 3 (+ step 1)) 0)
                (= (B 3 (+ step 1)) Jug3_Max)
            )
        )
        false
    )
)
;Assure that poured between first and third jug correctly
(define-fun PouredBetweenFirstThird ((step Int)) Bool
    (ite
        (= (B 2 step) (B 2 (+ step 1)))
        (and
            (= (+ (B 1 step) (B 3 step)) (+ (B 1 (+ step 1)) (B 3 (+ step 1))))
            (or
                (= (B 1 (+ step 1)) 0)
                (= (B 1 (+ step 1)) Jug1_Max)
                (= (B 3 (+ step 1)) 0)
                (= (B 3 (+ step 1)) Jug3_Max)
            )
        )
        false
    )
)
;Assure that poured between first and second jug correctly
(define-fun PouredBetweenFirstSecond ((step Int)) Bool
    (ite
        (= (B 3 step) (B 3 (+ step 1)))
        (and
        (= (+ (B 1 step) (B 2 step)) (+ (B 1 (+ step 1)) (B 2 (+ step 1))))
        (or
            (= (B 1 (+ step 1)) 0)
            (= (B 1 (+ step 1)) Jug1_Max)
            (= (B 2 (+ step 1)) 0)
            (= (B 2 (+ step 1)) Jug2_Max)
        )
        )
    false
    )
)

;Assert that pouring may only happen with two jugs at a time, and either one is filled to its max or the other is emptied
(assert
    (forall ((step Int))
        (=>
            (<= 1 step (- MaxStep 1))
            (or
                (PouredBetweenSecondThird step)
                (PouredBetweenFirstThird step)
                (PouredBetweenFirstSecond step)
            )
        )
    )
)

(check-sat)
(get-value 
(
    MaxStep

    (B 1 1)
    (B 2 1)
    (B 3 1)

    (B 1 2)
    (B 2 2)
    (B 3 2)

    (B 1 3)
    (B 2 3)
    (B 3 3)

    (B 1 4)
    (B 2 4)
    (B 3 4)

    (B 1 5)
    (B 2 5)
    (B 3 5)

    (B 1 6)
    (B 2 6)
    (B 3 6)

    (B 1 7)
    (B 2 7)
    (B 3 7)

    (B 1 8)
    (B 2 8)
    (B 3 8)

    (B 1 9)
    (B 2 9)
    (B 3 9)

    (B 1 10)
    (B 2 10)
    (B 3 10)

    (B 1 11)
    (B 2 11)
    (B 3 11)

    (B 1 12)
    (B 2 12)
    (B 3 12)
)
)
