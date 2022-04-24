
;Board (4x4)
(declare-fun B (Int Int) Int)

;Assign left hints
(assert (=  (B 1 2) 3))
(assert (=  (B 4 1) 3))
(assert (=  (B 3 6) 2))
(assert (=  (B 2 4) 1))
(assert (=  (B 3 3) 1))



;Assert inner grid range is 1 <= x <= 4
(assert 
    (forall ((row Int) (col Int))
      (ite 
        (and
            (<= 2 row 5 )
            (<= 2 col 5 )
        )
        (<= 1 (B row col) 4)
        (ite
            (<= 1 (B row col) 4)
            true
            (= (B row col) 0)
        )
     )
    )
)
; Rows and columns are distinct
(assert 
    (forall ((row Int) (col Int))
      (=>
        (and
            (<= 2 row 5 )
            (<= 2 col 5 )
        )
        (and 
            (distinct (B 2 row) (B 3 row) (B 4 row) (B 5 row))
            (distinct (B col 2) (B col 3) (B col 4) (B col 5))
        )
     )
    )
)

;(define-fun findTaller ((a Int) (b Int)) Int (ite (> a b) a b))

;Assert height of inner grid
(define-fun CheckHeightOfRowLeft ((row Int)) Bool
    (=> 
            (<= 1 (B 1 row) 4)
            (=
                (+
                    (ite (and (> (B 5 row) (B 4 row)) (> (B 5 row) (B 3 row)) (> (B 5 row) (B 2 row))) 1 0)
                    (ite (and (> (B 4 row) (B 3 row)) (> (B 4 row) (B 2 row))) 1 0)
                    (ite (> (B 3 row) (B 2 row)) 1 0)
                    1
                )
            (B 1 row)
            )
    )
)

(define-fun CheckHeightOfRowRight ((row Int)) Bool
    (=> 
            (<= 1 (B 6 row) 4)
            ;5432
            (=
                (+
                    (ite (and (> (B 2 row) (B 3 row)) (> (B 2 row) (B 4 row)) (> (B 2 row) (B 5 row))) 1 0)
                    (ite (and (> (B 3 row) (B 4 row)) (> (B 3 row) (B 5 row))) 1 0)
                    (ite (> (B 4 row) (B 5 row)) 1 0)
                    1
                )
            (B 6 row)
            )
    )
)

;Assert height of inner grid
(define-fun CheckHeightOfColTop ((col Int)) Bool
    (=> 
            (<= 1 (B col 6) 4)
            ;5432
            (=
                (+
                    (ite (and (> (B col 2) (B col 3)) (> (B col 2) (B col 4)) (> (B col 2) (B col 5))) 1 0)
                    (ite (and (> (B col 3) (B col 4)) (> (B col 3) (B col 5))) 1 0)
                    (ite (> (B col 4) (B col 5)) 1 0)
                    1
                )
            (B col 6)
            )
    )
)

;Assert height of inner grid
(define-fun CheckHeightOfColBottom ((col Int)) Bool
    (=> 
            (<= 1 (B col 1) 4)
            ;2345
            (=
                (+
                    (ite (and (> (B col 5) (B col 4)) (> (B col 5) (B col 3)) (> (B col 5) (B col 2))) 1 0)
                    (ite (and (> (B col 4) (B col 3)) (> (B col 4) (B col 3))) 1 0)
                    (ite (> (B col 3) (B col 2)) 1 0)
                    1
                )
            (B col 1)
            )
    )
)

;All rows
(assert 
    (forall ((index Int))
        (=> 
            (<= 2 index 5)
            (and 
                (CheckHeightOfRowLeft index)
                (CheckHeightOfRowRight index)
                (CheckHeightOfColTop index)
                (CheckHeightOfRowRight index)
            )
        )
    )
)

(check-sat)
(get-value (
(B 2 2)
(B 2 3)
(B 2 4)
(B 2 5)
(B 3 2)
(B 3 3)
(B 3 4)
(B 3 5)
(B 4 2)
(B 4 3)
(B 4 4)
(B 4 5)
(B 5 2)
(B 5 3)
(B 5 4)
(B 5 5))
)