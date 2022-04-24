;Table
(declare-fun T (Int Int) Bool)
;True per row counter
(declare-fun N_rows (Int) Int)
;True per column counter
(declare-fun N_meds (Int) Int)
;True per pair counter
(declare-fun N_pairs (Int Int) Int)

;Three medicines per round
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

;Three medicines per all rounds 
(define-fun ExactlyThreeForAllRounds() Bool
     (and (ExactlyThreePerRound 1)
          (ExactlyThreePerRound 2)
          (ExactlyThreePerRound 3)
          (ExactlyThreePerRound 4)
          (ExactlyThreePerRound 5)
          (ExactlyThreePerRound 6)
          (ExactlyThreePerRound 7)
     )
)

;Three rounds per medicine 
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

;Three rounds per all medicines
(define-fun ExactlyThreeForAllMeds() Bool
     (and (ExactlyThreePerMedicine 1)
          (ExactlyThreePerMedicine 2)
          (ExactlyThreePerMedicine 3)
          (ExactlyThreePerMedicine 4)
          (ExactlyThreePerMedicine 5)
          (ExactlyThreePerMedicine 6)
          (ExactlyThreePerMedicine 7)
     )
)

;Assure that no pairs are tested twice.
;Compare two rows for coinciding elements. Assure that in two rows less than 2, so 1 at most coincides. 
(define-fun NoTwoPairsInRound((Round1 Int) (Round2 Int)) Bool
     (and 
          (= (N_pairs Round1 Round2) (+
                    (ite (and (T Round1 1) (T Round2 1)) 1 0)
                    (ite (and (T Round1 2) (T Round2 2)) 1 0)
                    (ite (and (T Round1 3) (T Round2 3)) 1 0)
                    (ite (and (T Round1 4) (T Round2 4)) 1 0)
                    (ite (and (T Round1 5) (T Round2 5)) 1 0)
                    (ite (and (T Round1 6) (T Round2 6)) 1 0)
                    (ite (and (T Round1 7) (T Round2 7)) 1 0)
          ) 
          )
          (< (N_pairs Round1 Round2) 2)
     )
)

;Assure that no pairs in all rounds.
;Optimization: no double checks. E.g. after (1 and 2) are checked, no need to check again.
(define-fun NoTwoPairsInAllRounds() Bool
     (and
          ;1
          (NoTwoPairsInRound 1 2)
          (NoTwoPairsInRound 1 3)
          (NoTwoPairsInRound 1 4)
          (NoTwoPairsInRound 1 5)
          (NoTwoPairsInRound 1 6)
          (NoTwoPairsInRound 1 7)
          ;2
          (NoTwoPairsInRound 2 3)
          (NoTwoPairsInRound 2 4)
          (NoTwoPairsInRound 2 5)
          (NoTwoPairsInRound 2 6)
          (NoTwoPairsInRound 2 7)
          ;3
          (NoTwoPairsInRound 3 4)
          (NoTwoPairsInRound 3 5)
          (NoTwoPairsInRound 3 6)
          (NoTwoPairsInRound 3 7)
          ;4
          (NoTwoPairsInRound 4 5)
          (NoTwoPairsInRound 4 6)
          (NoTwoPairsInRound 4 7)
          ;5
          (NoTwoPairsInRound 5 6)
          (NoTwoPairsInRound 5 7)
          ;6
          (NoTwoPairsInRound 6 7)
     )
)

;apply all the constraints
(assert (and ExactlyThreeForAllRounds ExactlyThreeForAllMeds NoTwoPairsInRound))
;get model
(check-sat)
(get-model)