;Size (4x4)
(declare-fun B (Int Int) Int)

(declare-const Grid Int)
(declare-const Size Int)

;Assert hints
(assert (= (B 1 5) 4))
(assert (= (B 1 3) 3))
(assert (= (B 1 2) 1))

;Input grid size
(assert (= Grid 4))

;Assert board size
(assert (= Size (+ Grid 2))) 


;Assert inner grid range is 1 <= x <= 4
(assert 
    (forall ((row Int) (col Int))
    (ite 
        (and
            (< 1 row Size)
            (< 1 col Size)
        )
        (<= 1 (B row col) Grid)
        (ite
            (<= 1 (B row col) Grid)
            true
            (= (B row col) 0)
        )
    )
    )
)
;Rows and columns are distinct
(assert 
    (forall ((col Int) (row1 Int) (row2 Int))
        (=>
            (and
                (< 1 col  Size)
                (< 1 row1 Size)
                (< 1 row2 Size)
                (distinct row1 row2)
            )
            (distinct (B col row1) (B col row2))
            )
        )
)

(assert 
    (forall ((row Int) (col1 Int) (col2 Int))
    (=>
        (and
            (< 1 row  Size)
            (< 1 col1 Size)
            (< 1 col2 Size)
            (distinct col1 col2)
        )
        (distinct (B col1 row) (B col2 row))
        )
    )
)


;Function for descerning which of a pair is taller
(define-fun FindTaller ((a Int) (b Int)) Int (ite (> a b) a b))

(define-fun CheckHeightOfRow ((row Int) (hint Int) (e1 Int) (e2 Int) (e3 Int) (e4 Int)) Bool
    (=> 
        (<= 1 (B hint row) Grid)
        (=
            (+
                1
                (ite (> (B e2 row) (B e1 row)) 1 0)
                (ite (> (B e3 row) (FindTaller (B e2 row) (B e1 row))) 1 0)
                (ite (> (B e4 row) (FindTaller (B e3 row) (FindTaller (B e2 row) (B e1 row)))) 1 0)
            )
        (B hint row)
        )
)
)

(define-fun CheckHeightOfCol ((col Int) (hint Int) (e1 Int) (e2 Int) (e3 Int) (e4 Int)) Bool
    (=> 
        (<= 1 (B col hint) Grid)
        (=
            (+
                1
                (ite (> (B col e2) (B col e1)) 1 0)
                (ite (> (B col e3) (FindTaller (B col e2) (B col e1))) 1 0)
                (ite (> (B col e4) (FindTaller (B col e3) (FindTaller (B col e2) (B col e1)))) 1 0)
            )
        (B col hint)
        )
    )
)

;All rows
(assert 
    (forall ((index Int))
        (=> 
            (< 1 index Size)
            (and 
                (CheckHeightOfRow index 1 2 3 4 5)
                (CheckHeightOfRow index 6 5 4 3 2)
                (CheckHeightOfCol index 1 2 3 4 5)
                (CheckHeightOfCol index 6 5 4 3 2)
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
(B 5 5)
))