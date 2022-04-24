(declare-fun B (Int Int) Bool)
;At least one queen per file
(define-fun MinOneQueenPerFile ((file Int)) Bool
    (or (B file 1) (B file 2) (B file 3) (B file 4) (B file 5) (B file 6) (B file 7) (B file 8))
)
;At least one queen per rank
(define-fun MinOneQueenPerRank ((rank Int)) Bool
    (or (B 1 rank) (B 2 rank) (B 3 rank) (B 4 rank) (B 5 rank) (B 6 rank) (B 7 rank) (B 8 rank))
)
;At least one queen per all files
(define-fun MinOneQueenPerAllFiles () Bool
    (and 
        (MinOneQueenPerFile 1)
        (MinOneQueenPerFile 2)
        (MinOneQueenPerFile 3)
        (MinOneQueenPerFile 4)
        (MinOneQueenPerFile 5)
        (MinOneQueenPerFile 6)
        (MinOneQueenPerFile 7)
        (MinOneQueenPerFile 8)
    )
)
;At least one queen per all ranks
(define-fun MinOneQueenPerAllRanks () Bool
    (and 
        (MinOneQueenPerRank 1)
        (MinOneQueenPerRank 2)
        (MinOneQueenPerRank 3)
        (MinOneQueenPerRank 4)
        (MinOneQueenPerRank 5)
        (MinOneQueenPerRank 6)
        (MinOneQueenPerRank 7)
        (MinOneQueenPerRank 8)
    )
)
;Exactly one queen per file
(define-fun UniquePerFile ((file Int)) Bool
    (and 
    (=> (B file 1) (not (or (B file 2) (B file 3) (B file 4) (B file 5) (B file 6) (B file 7) (B file 8))))
    (=> (B file 2) (not (or (B file 1) (B file 3) (B file 4) (B file 5) (B file 6) (B file 7) (B file 8))))
    (=> (B file 3) (not (or (B file 1) (B file 2) (B file 4) (B file 5) (B file 6) (B file 7) (B file 8))))
    (=> (B file 4) (not (or (B file 1) (B file 2) (B file 3) (B file 5) (B file 6) (B file 7) (B file 8))))
    (=> (B file 5) (not (or (B file 1) (B file 2) (B file 3) (B file 4) (B file 6) (B file 7) (B file 8))))
    (=> (B file 6) (not (or (B file 1) (B file 2) (B file 3) (B file 4) (B file 5) (B file 7) (B file 8))))
    (=> (B file 7) (not (or (B file 1) (B file 2) (B file 3) (B file 4) (B file 5) (B file 6) (B file 8))))
    (=> (B file 8) (not (or (B file 1) (B file 2) (B file 3) (B file 4) (B file 5) (B file 6) (B file 7))))
    )
)
;Exactly one queen per rank
(define-fun UniquePerRank ((rank Int)) Bool
    (and 
    (=> (B 1 rank) (not (or (B 2 rank) (B 3 rank) (B 4 rank) (B 5 rank) (B 6 rank) (B 7 rank) (B 8 rank))))
    (=> (B 2 rank) (not (or (B 1 rank) (B 3 rank) (B 4 rank) (B 5 rank) (B 6 rank) (B 7 rank) (B 8 rank))))
    (=> (B 3 rank) (not (or (B 1 rank) (B 2 rank) (B 4 rank) (B 5 rank) (B 6 rank) (B 7 rank) (B 8 rank))))
    (=> (B 4 rank) (not (or (B 1 rank) (B 2 rank) (B 3 rank) (B 5 rank) (B 6 rank) (B 7 rank) (B 8 rank))))
    (=> (B 5 rank) (not (or (B 1 rank) (B 2 rank) (B 3 rank) (B 4 rank) (B 6 rank) (B 7 rank) (B 8 rank))))
    (=> (B 6 rank) (not (or (B 1 rank) (B 2 rank) (B 3 rank) (B 4 rank) (B 5 rank) (B 7 rank) (B 8 rank))))
    (=> (B 7 rank) (not (or (B 1 rank) (B 2 rank) (B 3 rank) (B 4 rank) (B 5 rank) (B 6 rank) (B 8 rank))))
    (=> (B 8 rank) (not (or (B 1 rank) (B 2 rank) (B 3 rank) (B 4 rank) (B 5 rank) (B 6 rank) (B 7 rank))))
    )
)
;Exactly one queen per all files
(define-fun UniquePerAllFiles () Bool
    (and 
        (UniquePerFile 1)
        (UniquePerFile 2)
        (UniquePerFile 3)
        (UniquePerFile 4)
        (UniquePerFile 5)
        (UniquePerFile 6)
        (UniquePerFile 7)
        (UniquePerFile 8)
    )
)
;Exactly one queen per all ranks
(define-fun UniquePerAllRanks () Bool
    (and 
        (UniquePerRank 1)
        (UniquePerRank 2)
        (UniquePerRank 3)
        (UniquePerRank 4)
        (UniquePerRank 5)
        (UniquePerRank 6)
        (UniquePerRank 7)
        (UniquePerRank 8)
    )
)


;Exactly one queen per diagonal
(define-fun UniquePerDiagonal((val1 Int) (val2 Int) (val3 Int) (val4 Int) (val5 Int) (val6 Int) (val7 Int) (val8 Int)) Bool
    (and 
        (=> (B 1 val1 ) (not (or (B 2 val2 ) (B 3 val3 ) (B 4 val4 ) (B 5 val5 ) (B 6 val6 ) (B 7 val7 ) (B 8 val8 ))))
        (=> (B 2 val2 ) (not (or (B 1 val1 ) (B 3 val3 ) (B 4 val4 ) (B 5 val5 ) (B 6 val6 ) (B 7 val7 ) (B 8 val8 ))))
        (=> (B 3 val3 ) (not (or (B 2 val2 ) (B 1 val1 ) (B 4 val4 ) (B 5 val5 ) (B 6 val6 ) (B 7 val7 ) (B 8 val8 ))))
        (=> (B 4 val4 ) (not (or (B 2 val2 ) (B 3 val3 ) (B 1 val1 ) (B 5 val5 ) (B 6 val6 ) (B 7 val7 ) (B 8 val8 ))))
        (=> (B 5 val5 ) (not (or (B 2 val2 ) (B 3 val3 ) (B 4 val4 ) (B 1 val1 ) (B 6 val6 ) (B 7 val7 ) (B 8 val8 ))))
        (=> (B 6 val6 ) (not (or (B 2 val2 ) (B 3 val3 ) (B 4 val4 ) (B 5 val5 ) (B 1 val1 ) (B 7 val7 ) (B 8 val8 ))))
        (=> (B 7 val7 ) (not (or (B 2 val2 ) (B 3 val3 ) (B 4 val4 ) (B 5 val5 ) (B 6 val6 ) (B 1 val1 ) (B 8 val8 ))))
        (=> (B 8 val8 ) (not (or (B 2 val2 ) (B 3 val3 ) (B 4 val4 ) (B 5 val5 ) (B 6 val6 ) (B 7 val7 ) (B 1 val1 ))))
    )
)

;Exactly one queen per all diagonals
;There are two diagonals pf size 8, four of size 7 etc.
;For 8 element diagonal pass all the parameters. 
;For 7 element diagonal pass 7 parameters and 0 for redundant parameter.
(define-fun UniquePerAllDiagonals() Bool
    (and 
        ;Main diagonals
        (UniquePerDiagonal 1 2 3 4 5 6 7 8)
        (UniquePerDiagonal 8 7 6 5 4 3 2 1)

        ;Upper-left diagonals /
        (UniquePerDiagonal 2 3 4 5 6 7 8 0)
        (UniquePerDiagonal 3 4 5 6 7 8 0 0)
        (UniquePerDiagonal 4 5 6 7 8 0 0 0)
        (UniquePerDiagonal 5 6 7 8 0 0 0 0)
        (UniquePerDiagonal 6 7 8 0 0 0 0 0)
        (UniquePerDiagonal 7 8 0 0 0 0 0 0)

        ;Bottom-right diagonals / 
        (UniquePerDiagonal 0 1 2 3 4 5 6 7)
        (UniquePerDiagonal 0 0 1 2 3 4 5 6)
        (UniquePerDiagonal 0 0 0 1 2 3 4 5)
        (UniquePerDiagonal 0 0 0 0 1 2 3 4)
        (UniquePerDiagonal 0 0 0 0 0 1 2 3)
        (UniquePerDiagonal 0 0 0 0 0 0 1 2)
    
        ;Upper-right reverse diagonals \
        (UniquePerDiagonal 0 8 7 6 5 4 3 2)
        (UniquePerDiagonal 0 0 8 7 6 5 4 3)
        (UniquePerDiagonal 0 0 0 8 7 6 5 4)
        (UniquePerDiagonal 0 0 0 0 8 7 6 5)
        (UniquePerDiagonal 0 0 0 0 0 8 7 6)
        (UniquePerDiagonal 0 0 0 0 0 0 8 7)

        ;Upper-right reverse diagonals \
        (UniquePerDiagonal 7 6 5 4 3 2 1 0)
        (UniquePerDiagonal 6 5 4 3 2 1 0 0)
        (UniquePerDiagonal 5 4 3 2 1 0 0 0)
        (UniquePerDiagonal 4 3 2 1 0 0 0 0)
        (UniquePerDiagonal 3 2 1 0 0 0 0 0)
        (UniquePerDiagonal 2 1 0 0 0 0 0 0)

    )
)
;Apply assertions
(assert (and MinOneQueenPerAllFiles MinOneQueenPerAllRanks UniquePerAllFiles UniquePerAllRanks UniquePerAllDiagonals))

;get model
(check-sat)
(get-model)