; Grid. X Y -> Traingle vertex reference
(declare-fun B (Int Int) Int)

;Is same diagonal 
;The same diagonal, then at least one fails.
(define-fun SameDiag ((x1 Int) (y1 Int) (x2 Int) (y2 Int)) (Bool)
	(not (and
		(distinct (- y1 y2) (- x1 x2))
		(distinct (- y1 y2) (- x2 x1))
	))
)

;Conditions for 0
(define-fun CheckCoords ((input Int) (c1 Int) (c2 Int)) (Bool)
    (and
        ;not the same
        (distinct c1 c2)
        ;bounds
        (<= 1 c1 5) (<= 1 c2 5) 
        ;x is between (is covered)
        (< c1 input c2)
    )
)

;Find total amount of zeroes in a row
(define-fun Total ((row Int)) (Int)
    (+
        (ite ( = (B 1 row) 0) 1 0)
        (ite ( = (B 2 row) 0) 1 0)
        (ite ( = (B 3 row) 0) 1 0)
        (ite ( = (B 4 row) 0) 1 0)
        (ite ( = (B 5 row) 0) 1 0)
    )
)

(define-fun ExistsTriangle ((t_number Int)) (Bool)
    (exists ((t1_x Int)(t1_y Int)(t2_x Int)(t2_y Int)(t3_x Int)(t3_y Int))
        (and
            ;no two pairs of verticies are the same
            (not (and (= t1_x t2_x) (= t1_y t2_y)))
            (not (and (= t2_x t3_x) (= t2_y t3_y)))
            (not (and (= t1_x t3_x) (= t1_y t3_y)))

            ;set bounds
            (<= 1 t1_x 5) (<= 1 t1_y 5) 
            (<= 1 t2_x 5) (<= 1 t2_y 5)
            (<= 1 t3_x 5) (<= 1 t3_y 5)

            ; value to each coordinate
            ( = (B t1_x t1_y) t_number)
            ( = (B t2_x t2_y) t_number)
            ( = (B t3_x t3_y) t_number)
        )       
    )
)
;ROW-> are zeroes in between two verticies in a row
(define-fun LiesOnOppositeSide ((x Int)(y Int)) (Bool)
    (exists ((x1 Int)(x2 Int))
        (and
            (CheckCoords x x1 x2)
            ;same row 
            (= (B x1 y) (B x2 y))
            ;only consider vertices
            (not (= (B x1 y) (B x2 y) 0))
        )
    )
)
;Dot lies on adjacent side
(define-fun LiesOnAdjacentSide ((x Int)(y Int)) (Bool)
    (exists ((y1 Int)(y2 Int))
        (and
            (CheckCoords y y1 y2)
            ;same column
            (= (B x y1) (B x y2))
            ;only consider vertices
            (not (= (B x y1) (B x y2) 0))
        )
    )
)
;Diagonal-> are zeroes in between two verticies in a diagonal
(define-fun LiesOnHypotenuse ((x Int)(y Int)) (Bool)
    (exists ((x1 Int)(y1 Int)(x2 Int)(y2 Int))
        (and
            (and
                (distinct y1 y2)
                (distinct x1 x2)
            )
            (<= 1 y1 5) (<= 1 y2 5) 
            (<= 1 x1 5) (<= 1 x2 5) 
            (or
                ;/
                (and (>= x2 x x1) (<= y2 y y1))
                ;\
                (and (>= x2 x x1) (>= y2 y y1))
            )
            ;Check if elements lie in same diagonal
            (SameDiag x1 y1 x2 y2)
            (SameDiag x1 y1 x y)
            (SameDiag x2 y2 x y)

            ;check for verticies
            (= (B x1 y1) (B x2 y2))
            (not (= (B x1 y1) (B x2 y2) 0))
        )
    )
)



(assert
(and
    ;values in grid 0, 1, 2 or 3
    (forall ((x Int)(y Int))
    (=> (and (<= 1 x 5) (<= 1 y 5))
        (<= 0 (B x y) 3) 
    )
    )

    ;define triangles 
    (ExistsTriangle 1)
    (ExistsTriangle 2)
    (ExistsTriangle 3)

    ;0 represents a dot (25 - 9 verticies = 16 remaining squares to be covered)
    (=
        (+ (Total 1) (Total 2) (Total 3) (Total 4) (Total 5))
    16)

    ;defining edge triangle behaivior
    (forall ((x Int)(y Int))
    ;select only non-verticies elements
    (=> (and (<= 1 x 5) (<= 1 y 5) (= (B x y) 0))
        (or

            ;Dot lies on opposite side
            (LiesOnAdjacentSide x y)
            ;Column -> are zeroes in between two verticies in a column
            (LiesOnOppositeSide x y)
            ;Dot lies on hypotenus
            (LiesOnHypotenuse x y)
        )
    )
    )
)
)

(check-sat)
(get-value(
    (B 1 1)
    (B 1 2)
    (B 1 3)
    (B 1 4)
    (B 1 5)
    (B 2 1)
    (B 2 2)
    (B 2 3)
    (B 2 4)
    (B 2 5)
    (B 3 1)
    (B 3 2)
    (B 3 3)
    (B 3 4)
    (B 3 5)
    (B 4 1)
    (B 4 2)
    (B 4 3)
    (B 4 4)
    (B 4 5)
    (B 5 1)
    (B 5 2)
    (B 5 3)
    (B 5 4)
    (B 5 5)
))