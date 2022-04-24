;Dice , Face of a die -> value.
(declare-fun B (Int Int) Int)

;function that defines possible outcomes of one face of the wining die against all faces of the losing die
;(counting)
(define-fun DiePlayOutcome ((face Int)(die Int)) (Int)
    (+
        (ite (> face (B die 1)) 1 0)
        (ite (> face (B die 2)) 1 0)
        (ite (> face (B die 3)) 1 0)
        (ite (> face (B die 4)) 1 0)
        (ite (> face (B die 5)) 1 0)
        (ite (> face (B die 6)) 1 0)
    )
)

(assert
(and

(forall ((die Int)(face Int)) 
    ; Three cubes . Six faces each
    (=> (and (<= 1 die 3) (<= 1 face 6))
        ;Values of die from 1 to 6.
        (<= 1 (B die face) 9)
    )
    
)
;For all dice there exists a die that's loose to the die.
;(Intransitivity)
(forall ((dice Int))
    (=> (<= 1 dice 3)
        (exists ((beatingDice Int))
            (and
            ;Loosing die is one of the three dice.
            (<= 1 beatingDice 3)
            ;And not the same dice though.
            (not (= dice beatingDice))
            ;And wins >50% of the times. (50*36)/100=18 
            (>
                (+
                    (DiePlayOutcome  (B beatingDice 1)  dice)
                    (DiePlayOutcome  (B beatingDice 2)  dice)
                    (DiePlayOutcome  (B beatingDice 3)  dice)
                    (DiePlayOutcome  (B beatingDice 4)  dice)
                    (DiePlayOutcome  (B beatingDice 5)  dice)
                    (DiePlayOutcome  (B beatingDice 6)  dice)
                )
            18)
            )
        )
    )
)
)
)

(check-sat)
(get-value(
    1
    (B 1 1)
    (B 1 2)
    (B 1 3)
    (B 1 4)
    (B 1 5)
    (B 1 6)
    2
    (B 2 1)
    (B 2 2)
    (B 2 3)
    (B 2 4)
    (B 2 5)
    (B 2 6)
    3   
    (B 3 1)
    (B 3 2)
    (B 3 3)
    (B 3 4)
    (B 3 5)
    (B 3 6)
))