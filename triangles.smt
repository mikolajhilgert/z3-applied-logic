; Grid. X Y 
(declare-fun B (Int Int) Int)

(define-fun TwoCoordDistinct ((x1 Int)(y1 Int)(x2 Int)(y2 Int)) (Bool)
    (not (and (= x1 x2) (= y1 y2)))
)

(define-fun SameDiag ((x1 Int) (y1 Int) (x2 Int) (y2 Int)) (Bool)
	(not (and
		(distinct (- y1 y2) (- x1 x2))
		(distinct (- y1 y2) (- x2 x1))
	))
)

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
            (TwoCoordDistinct t1_x t1_y t2_x t2_y)
            (TwoCoordDistinct t2_x t2_y t3_x t3_y)
            (TwoCoordDistinct t1_x t1_y t3_x t3_y)

            (<= 1 t1_x 5) (<= 1 t1_y 5) 
            (<= 1 t2_x 5) (<= 1 t2_y 5)
            (<= 1 t3_x 5) (<= 1 t3_y 5)

            ( = (B t1_x t1_y) t_number)
            ( = (B t2_x t2_y) t_number)
            ( = (B t3_x t3_y) t_number)
        )       
    )
)


(assert
(and
    (forall ((x Int)(y Int))
    (=> (and (<= 1 x 5) (<= 1 y 5))
        (<= 0 (B x y) 3) 
    )
    )
    ;(= (B 4 5) 3)

    (ExistsTriangle 1)
    (ExistsTriangle 2)
    (ExistsTriangle 3)
    (=
        (+ (Total 1) (Total 2) (Total 3) (Total 4) (Total 5))
    16)

    (forall ((x Int)(y Int))
    (=> (and (<= 1 x 5) (<= 1 y 5) (= (B x y) 0))
        (or
            ;ROW
            (exists ((x1 Int)(x2 Int))
                (and
                    ;not the same
                    (distinct x1 x2)
                    ;bounds
                    (<= 1 x1 5) (<= 1 x2 5) 
                    ;x is between (is covered)
                    (< x1 x x2)
                    ;same row 
                    (= (B x1 y) (B x2 y))
                    ;only consider vertices
                    (not (= (B x1 y) (B x2 y) 0))
                )
            )
            ;Column
            (exists ((y1 Int)(y2 Int))
                (and
                    ;not the same
                    (distinct y1 y2)
                    ;bounds
                    (<= 1 y1 5) (<= 1 y2 5) 
                    ;y is between (is covered)
                    (< y1 y y2)
                    ;same column
                    (= (B x y1) (B x y2))
                    ;only consider vertices
                    (not (= (B x y1) (B x y2) 0))
                )
            )
            ;Diagonal
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
                        (and
                            (>= x2 x x1)
                            (<= y2 y y1)
                        )
                        ;\
                        (and
                            (>= x2 x x1)
                            (>= y2 y y1)
                        )
                    )

                    (SameDiag x1 y1 x2 y2)
                    (SameDiag x1 y1 x y)
                    (SameDiag x2 y2 x y)
                    (= (B x1 y1) (B x2 y2))
                    (not (= (B x1 y1) (B x2 y2) 0))
                )
            )
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