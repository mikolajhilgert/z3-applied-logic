; step->circle
(declare-fun C (Int) Int)
; step->total
(declare-fun T (Int) Int)

; end-state const
(declare-const N Int)

; priamlity check
(define-fun Prime ((Input Int)) Bool
(and 
    (> Input 0) 
    (not (exists ((y Int) (x Int)) (and (= Input (* x y)) (< x Input) (< y Input)  (> x 1) (> y 1) ) ) 
))
)

(assert (and
    ;start state
    (= (C 0) 3)
    (= (C N) 20)
    ;end state
    (= (T 0) 3)
    (= (T N) 79)

    ;forall steps
    (forall ((step Int))
    (=>
        (<= 0 step N)
        (exists ((circle Int))
            (and
                ;circle may be 3 4 8 2 10 6 or 20
                (xor
                    (= circle 3)
                    (= circle 4)
                    (= circle 8)
                    (= circle 2)
                    (= circle 10)
                    (= circle 6)
                    (= circle 20)
                )
                ;previous circle is not this circle (to stop pingponging)
                (not (= (C step) (C (+ step 1))))
                (not (= (C (- step 1)) (C (+ step 1))))
                ;is result prime
                (Prime (T step))
                ;next circle is asserted
                (= (C (+ step 1)) circle)
                ;next total is asserted via current total + next circle
                (= (T (+ step 1)) (+ (T step) circle))
            )
        )
    )
    )

    ;what circles may be reached from each circle
    (forall ((step Int))
        (=>
        (<= 0 step N)
        (xor
            (and (= (C step) 3)
                (xor
                    (= (C (+ step 1)) 4)
                    (= (C (+ step 1)) 2)
                    (= (C (+ step 1)) 20)
                )
            )
            (and (= (C step) 2)
                (xor
                    (= (C (+ step 1)) 3)
                    (= (C (+ step 1)) 4)
                    (= (C (+ step 1)) 8)
                    (= (C (+ step 1)) 10)
                    (= (C (+ step 1)) 6)
                    (= (C (+ step 1)) 20)
                )
            )
            (and (= (C step) 4)
                (xor
                    (= (C (+ step 1)) 8)
                    (= (C (+ step 1)) 2)
                    (= (C (+ step 1)) 3)
                )
            )
            (and (= (C step) 8)
                (xor
                    (= (C (+ step 1)) 4)
                    (= (C (+ step 1)) 2)
                    (= (C (+ step 1)) 10)
                )
            )
            (and (= (C step) 10)
                (xor
                    (= (C (+ step 1)) 8)
                    (= (C (+ step 1)) 2)
                    (= (C (+ step 1)) 6)
                )
            )
            (and (= (C step) 6)
                (xor
                    (= (C (+ step 1)) 10)
                    (= (C (+ step 1)) 2)
                    (= (C (+ step 1)) 20)
                )
            )
            (and (= (C step) 20)
                (xor
                    (= (C (+ step 1)) 3)
                    (= (C (+ step 1)) 2)
                    (= (C (+ step 1)) 6)
                )
            )
        )
        )
    )
    (<= 0 N 11)
))

(check-sat)
(get-value (
    N

    (C 0)
    (C 1)
    (C 2)
    (C 3)
    (C 4)
    (C 5)
    (C 6)
    (C 7)
    (C 8)
    (C 9)
    (C 10)
    (C 11)


    (T 0)
    (T 1)
    (T 2)
    (T 3)
    (T 4)
    (T 5)
    (T 6)
    (T 7)
    (T 8)
    (T 9)
    (T 10)
    (T 11)
))