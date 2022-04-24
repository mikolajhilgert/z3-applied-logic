(declare-fun B (Int Int) Int)

(declare-const N Int)

(define-fun atleastOneMiss ((side Int) (step Int)) (Bool)
    (>=
        (+
            (ite (= (B step 1) side) 1 0) 
            (ite (= (B step 2) side) 1 0) 
            (ite (= (B step 3) side) 1 0) 
        )
    1
    )
)

(define-fun SafeLSide ((step Int)) Bool
    (=> (atleastOneMiss 0 step)
        (<=
            (+ 
                (ite (= (B step 4) 0) 1 0) 
                (ite (= (B step 5) 0) 1 0) 
                (ite (= (B step 6) 0) 1 0) 
            )
            (+ 
                (ite (= (B step 1) 0) 1 0) 
                (ite (= (B step 2) 0) 1 0) 
                (ite (= (B step 3) 0) 1 0) 
            )
        )
    )
)
(define-fun SafeRSide ((step Int)) Bool
    (=> (atleastOneMiss 1 step)
        (<=
            (+ 
                (ite (= (B step 4) 1) 1 0) 
                (ite (= (B step 5) 1) 1 0) 
                (ite (= (B step 6) 1) 1 0) 
            )
            (+ 
                (ite (= (B step 1) 1) 1 0) 
                (ite (= (B step 2) 1) 1 0) 
                (ite (= (B step 3) 1) 1 0) 
            )
        )
    )
)



(define-fun isEven ((step Int)) Bool
    (= (mod step 2) 0)
)

(assert (and
    (= (B 1 1) 0)
    (= (B 1 2) 0)
    (= (B 1 3) 0)
    (= (B 1 4) 0)
    (= (B 1 5) 0)
    (= (B 1 6) 0)

    (= (B N 1) 1)
    (= (B N 2) 1)
    (= (B N 3) 1)
    (= (B N 4) 1)
    (= (B N 5) 1)
    (= (B N 6) 1)

    (not 
        (exists ((step Int))
            (and
                (<= 1 step (- N 1))
                (isEven step)
                (exists ((person Int))
                    (and
                        (<= 1 person 6)
                        (= (B step person) 0)
                        (= (B (+ step 1) person) 1)
                    )
                )
            )
        )
    )

    (forall ((x Int) (y Int))
        (=> (and (<= 1 x N) (<= 1 y 6 ))
            (<= 0 (B x y) 1)
        )
    )



    (forall ((step Int))
    (=>
        (<= 1 step N)
        (and
            (SafeRSide step)
            (SafeLSide step)
            (exists ((p1 Int)(p2 Int)(p3 Int)(p4 Int)(p5 Int)(p6 Int))
                (and
                    (distinct p1 p2 p3 p4 p5 p6)
                    (<= 1 p1 6)
                    (<= 1 p2 6)
                    (<= 1 p3 6)
                    (<= 1 p4 6)
                    (<= 1 p5 6)
                    (<= 1 p6 6)

                    (or
                        (and
                            (distinct (B step p1) (B (+ step 1) p1))
                            (distinct (B step p2) (B (+ step 1) p2))
                        )
                        (and
                            (distinct (B step p1) (B (+ step 1) p1))
                            (= (B step p2) (B (+ step 1) p2))
                        )
                    )
                    (= (B step p3) (B (+ step 1) p3))
                    (= (B step p4) (B (+ step 1) p4))
                    (= (B step p5) (B (+ step 1) p5))
                    (= (B step p6) (B (+ step 1) p6))
                )
            )
        )
    )
    )
    (<= 1 N 13)
))
(check-sat)
(get-value (
    N
    ;1
    (B 1 1)
    (B 1 2)
    (B 1 3)
    (B 1 4)
    (B 1 5)
    (B 1 6)
    ;2
    (B 2 1)
    (B 2 2)
    (B 2 3)
    (B 2 4)
    (B 2 5)
    (B 2 6)
    ;3
    (B 3 1)
    (B 3 2)
    (B 3 3)
    (B 3 4)
    (B 3 5)
    (B 3 6)
    ;4
    (B 4 1)
    (B 4 2)
    (B 4 3)
    (B 4 4)
    (B 4 5)
    (B 4 6)
    ;5
    (B 5 1)
    (B 5 2)
    (B 5 3)
    (B 5 4)
    (B 5 5)
    (B 5 6)
    ;6
    (B 6 1)
    (B 6 2)
    (B 6 3)
    (B 6 4)
    (B 6 5)
    (B 6 6)
    ;7
    (B 7 1)
    (B 7 2)
    (B 7 3)
    (B 7 4)
    (B 7 5)
    (B 7 6)
    ;8
    (B 8 1)
    (B 8 2)
    (B 8 3)
    (B 8 4)
    (B 8 5)
    (B 8 6)
    ;9
    (B 9 1)
    (B 9 2)
    (B 9 3)
    (B 9 4)
    (B 9 5)
    (B 9 6)
    ;10
    (B 10 1)
    (B 10 2)
    (B 10 3)
    (B 10 4)
    (B 10 5)
    (B 10 6)
    ;11
    (B 11 1)
    (B 11 2)
    (B 11 3)
    (B 11 4)
    (B 11 5)
    (B 11 6)
    ;12
    (B 12 1)
    (B 12 2)
    (B 12 3)
    (B 12 4)
    (B 12 5)
    (B 12 6)
))