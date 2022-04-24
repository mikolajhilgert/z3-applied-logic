
(declare-fun T (Int Int) Bool)
(declare-fun N_rows (Int) Int)
(declare-fun N_meds (Int) Int)

(define-fun ExactlyThreePerRound((Round Int)) Bool
    (and (= (N_rows Round) (+
            (ite (T Round 1) 1 0)
            (ite (T Round 2) 1 0)  
            (ite (T Round 3) 1 0)  
            (ite (T Round 4) 1 0)  
            (ite (T Round 5) 1 0)  
            (ite (T Round 6) 1 0)  
            (ite (T Round 7) 1 0)  
        ) 
    )
    (= (N_rows Round) 3))
)

(define-fun ExactlyThreeForAllRounds() Bool
    (and 
        (ExactlyThreePerRound 1)
        (ExactlyThreePerRound 2)
        (ExactlyThreePerRound 3)
        (ExactlyThreePerRound 4)
        (ExactlyThreePerRound 5)
        (ExactlyThreePerRound 6)
        (ExactlyThreePerRound 7)
    )
)

(define-fun ExactlyThreePerMedicine((Medicine Int)) Bool
    (and (= (N_meds Medicine) (+
            (ite (T 1 Medicine) 1 0)
            (ite (T 2 Medicine) 1 0)  
            (ite (T 3 Medicine) 1 0)  
            (ite (T 4 Medicine) 1 0)  
            (ite (T 5 Medicine) 1 0)  
            (ite (T 6 Medicine) 1 0)  
            (ite (T 7 Medicine) 1 0)  
        ) 
    )
    (= (N_meds Medicine) 3))
)

(define-fun ExactlyThreeForAllMeds() Bool
    (and    
        (ExactlyThreePerMedicine 1)
        (ExactlyThreePerMedicine 2)
        (ExactlyThreePerMedicine 3)
        (ExactlyThreePerMedicine 4)
        (ExactlyThreePerMedicine 5)
        (ExactlyThreePerMedicine 6)
        (ExactlyThreePerMedicine 7)
    )
)

(define-fun NoTwoPairsOfMedicines() Bool
    (not (exists ((round1 Int) (round2 Int) (med1 Int) (med2 Int)) 
        (and 
                (and (T round1  med1) (T round2 med1))
                (and (T round1  med2) (T round2 med2))
        )
    ))
)

(assert (and ExactlyThreeForAllRounds ExactlyThreeForAllMeds ))

(check-sat)
(get-model)