; First Int - jug number, Second Int - step
(declare-fun B (Int Int) Int)

(declare-const Jug1_Max Int)
(declare-const Jug2_Max Int)
(declare-const Jug3_Max Int)

(assert (= Jug1_Max 8))
(assert (= Jug2_Max 0))
(assert (= Jug3_Max 0))

(assert (= (B 1 1) Jug1_Max))
(assert (= (B 2 1) Jug2_Max))
(assert (= (B 3 1) Jug3_Max))

(assert (<= 0 (B 1 1) 8))
(assert (<= 0 (B 2 1) 5))
(assert (<= 0 (B 3 1) 3))

(assert 
    ( 
        (forall ((step Int))
            (and
                (<= 0 (B 1 step) 8)
                (<= 0 (B 2 step) 5)
                (<= 0 (B 3 step) 3)
            )
        )
    )    
)

(define-fun PourWater ((jugFrom Int) (jugTo Int) (step Int) Bool)
    
    (ite (= jugTo 2) (
            (ite
                ;if
                (> (+ jugTo jugFrom) Jug2_Max)
                ;then
                (and 
                    (= (B jugTo step) Jug2_Max)
                    (= (B jugFrom step) (- jugFrom Jug2_Max))
                )
                ;else
                (and
                    (= (B jugTo step) (+ jugTo jugFrom))
                    (= (B jugFrom step) 0)
                )
                
            )
        ) 
    )
    true
)

(assert 
    ( 
        (forall ((jug Int) (step Int))
            ;if not
            (=>
                (not
                    (exists (step Int)
                        (and
                            (= (B 1 step) 4)
                            (= (B 2 step) 4)
                            (= (B 3 step) 0)
                        )
                    )
                )
            )
            ;keep going
            (

            )
        )
    )    
)



(check-sat)
(get-model)

