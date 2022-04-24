; First Int - jug number, Second Int - step
(declare-fun B (Int Int) Int)

;Column limits. (Jug limits)
(define-fun Jug1_Max () Int 8)
(define-fun Jug2_Max () Int 5)
(define-fun Jug3_Max () Int 3)


;1) No jugs exceedes MAX 
(assert 
    (forall ((step Int))
        (=>
            (<= 1 step 12)
            (and
                (<= 1 (B 1 step) Jug1_Max)
                (<= 1 (B 2 step) Jug2_Max)
                (<= 1 (B 3 step) Jug3_Max)
            )
        )
    )
)
;2) No two same rows
(assert
    (not
        (exists ((step1 Int) (step2 Int))
            (and
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


(check-sat)
(get-value(
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
))
