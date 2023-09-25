;(move,tower,position)->diskVal
(declare-fun B (Int Int Int) Int)

; timepoint at which the required end-state is reached
(declare-const N Int)

; returns the total of all disks and rods per move
(define-fun TotalPerMove((t Int)) Int
	(+
        (B t 1 1) (B t 1 2) (B t 1 3) (B t 1 4)
        (B t 2 1) (B t 2 2) (B t 2 3) (B t 2 4)
        (B t 3 1) (B t 3 2) (B t 3 3) (B t 3 4)
	)
)

; returns the total amount of zeros per move
(define-fun ZeroCountPerMove((t Int)) Int
    (+
        (ite(=(B t 1 1) 0) 1 0) (ite(=(B t 1 2) 0) 1 0) (ite(=(B t 1 3) 0) 1 0) (ite(=(B t 1 4) 0) 1 0) 
        (ite(=(B t 2 1) 0) 1 0) (ite(=(B t 2 2) 0) 1 0) (ite(=(B t 2 3) 0) 1 0) (ite(=(B t 2 4) 0) 1 0) 
        (ite(=(B t 3 1) 0) 1 0) (ite(=(B t 3 2) 0) 1 0) (ite(=(B t 3 3) 0) 1 0) (ite(=(B t 3 4) 0) 1 0) 
    ) 
)

;function for disk movement, that says one position in the rod changes
;and two stay the same. As per rule to move one disk per MOVE.
(define-fun DiskMovement ((t Int) (row Int) (p1 Int) (p2 Int) (p3 Int) (p4 Int)) Bool
    (and
        ;different positions
        (distinct p1 p2 p3 p4)
        (<= 1 p1 4)
        (<= 1 p2 4)
        (<= 1 p3 4)
        (<= 1 p4 4)

        ;two position on the rod stays the same, whilst one changes
        (distinct (B t row p1) (B (+ t 1) row p1))
        (= (B t row p2)(B (+ t 1) row p2))
        (= (B t row p3)(B (+ t 1) row p3))
        (= (B t row p4)(B (+ t 1) row p4))
    )
)

(assert (and
    ;start state
    (= (B 0 1 1) 4) (= (B 0 1 2) 3) (= (B 0 1 3) 2) (= (B 0 1 4) 1)
    (= (B 0 2 1) 0) (= (B 0 2 2) 0) (= (B 0 2 3) 0) (= (B 0 2 4) 0)
    (= (B 0 3 1) 0) (= (B 0 3 2) 0) (= (B 0 3 3) 0) (= (B 0 3 4) 0)

    ;wanted-end state
    (= (B N 1 1) 0) (= (B N 1 2) 0) (= (B N 1 3) 0) (= (B N 1 4) 0)
    (= (B N 2 1) 0) (= (B N 2 2) 0) (= (B N 2 3) 0) (= (B N 2 4) 0)
    (= (B N 3 1) 4) (= (B N 3 2) 3) (= (B N 3 3) 2) (= (B N 3 4) 1)

    ;A disk on the bottom must be larger than the one above it, and the one above it must be 
    ;larger than the one above that one (or equal to, in an instance of a 0)
    (forall ((t Int) (rod Int))
        (=> 
            (<= 0 t N)
            (>= (B t rod 1) (B t rod 2) (B t rod 3) (B t rod 4))
        )
    )

    ; total for disks is 9, and there are 8 zeros per step
    (forall ((t Int))
        (=> 
            (<= 0 t N)
            (and
                (= (TotalPerMove t) (TotalPerMove (+ t 1)))
                (= (ZeroCountPerMove t) (ZeroCountPerMove (+ t 1)))
            )
        )
    )

    ; all combinations of moves
    (forall ((t Int))
	(=> 
        ;conditions per move
		(<= 0 t N)
            (exists ((r1 Int) (r2 Int) (r3 Int))
                (and
                    ;different rods
                    (distinct r1 r2 r3)
                    (<= 1 r1 3)
                    (<= 1 r2 3)
                    (<= 1 r3 3)

                    ;One rod doesnt change in any way
                    (= (B t r1 4) (B (+ t 1) r1 4))
                    (= (B t r1 3) (B (+ t 1) r1 3))
                    (= (B t r1 2) (B (+ t 1) r1 2))
                    (= (B t r1 1) (B (+ t 1) r1 1))

                    ;There exists a position in a another rod that becomes 0 -> movement of the disk
                    (exists ((p1 Int) (p2 Int) (p3 Int) (p4 Int))
                        (and
                            ;disk movement
                            (distinct p1 p2 p3 p4)
                            (<= 1 p1 4)
                            (<= 1 p2 4)
                            (<= 1 p3 4)
                            (<= 1 p4 4)

                            ;two position on the rod stays the same, whilst one changes
                            (distinct (B t r2 p1) (B (+ t 1) r2 p1))
                            (= (B t r2 p2)(B (+ t 1) r2 p2))
                            (= (B t r2 p3)(B (+ t 1) r2 p3))
                            (= (B t r2 p4)(B (+ t 1) r2 p4))
                            ;one position becomes 0
                            (= (B (+ t 1) r2 p1) 0)
                        )
                    )

                    ;There exists a position in the last rod that becomes either 1,2,3 or 4. 
                    (exists ((p1 Int) (p2 Int) (p3 Int) (p4 Int))
                        (and
                            ;disk movement
                            (distinct p1 p2 p3 p4)
                            (<= 1 p1 4)
                            (<= 1 p2 4)
                            (<= 1 p3 4)
                            (<= 1 p4 4)

                            ;two position on the rod stays the same, whilst one changes
                            (distinct (B t r3 p1) (B (+ t 1) r3 p1))
                            (= (B t r3 p2)(B (+ t 1) r3 p2))
                            (= (B t r3 p3)(B (+ t 1) r3 p3))
                            (= (B t r3 p4)(B (+ t 1) r3 p4))
                            ;one position becomes 1, 2, 3 or 4
                            (or
                                (= (B (+ t 1) r3 p1) 1)
                                (= (B (+ t 1) r3 p1) 2)
                                (= (B (+ t 1) r3 p1) 3)
                                (= (B (+ t 1) r3 p1) 4)
                            )
                        )
                    )
                )
            )
        )
    )
    ;limit on steps
    (<= 0 N 15)
))

(check-sat)
(get-value(
    N
    0 1
    (B 0 1 4) (B 0 1 3) (B 0 1 2) (B 0 1 1)
    0 2
    (B 0 2 4) (B 0 2 3) (B 0 2 2) (B 0 2 1)
    0 3
    (B 0 3 4) (B 0 3 3) (B 0 3 2) (B 0 3 1)

    1 1
    (B 1 1 4) (B 1 1 3) (B 1 1 2) (B 1 1 1)
    1 2
    (B 1 2 4) (B 1 2 3) (B 1 2 2) (B 1 2 1)
    1 3
    (B 1 3 4) (B 1 3 3) (B 1 3 2) (B 1 3 1)

    2 1
    (B 2 1 4) (B 2 1 3) (B 2 1 2) (B 2 1 1)
    2 2
    (B 2 2 4) (B 2 2 3) (B 2 2 2) (B 2 2 1)
    2 3
    (B 2 3 4) (B 2 3 3) (B 2 3 2) (B 2 3 1)

    3 1
    (B 3 1 4) (B 3 1 3) (B 3 1 2) (B 3 1 1)
    3 2
    (B 3 2 4) (B 3 2 3) (B 3 2 2) (B 3 2 1)
    3 3
    (B 3 3 4) (B 3 3 3) (B 3 3 2) (B 3 3 1)

    4 1
    (B 4 1 4) (B 4 1 3) (B 4 1 2) (B 4 1 1)
    4 2
    (B 4 2 4) (B 4 2 3) (B 4 2 2) (B 4 2 1)
    4 3
    (B 4 3 4) (B 4 3 3) (B 4 3 2) (B 4 3 1)

    5 1
    (B 5 1 4) (B 5 1 3) (B 5 1 2) (B 5 1 1)
    5 2
    (B 5 2 4) (B 5 2 3) (B 5 2 2) (B 5 2 1)
    5 3
    (B 5 3 4) (B 5 3 3) (B 5 3 2) (B 5 3 1)

    6 1
    (B 6 1 4) (B 6 1 3) (B 6 1 2) (B 6 1 1)
    6 2
    (B 6 2 4) (B 6 2 3) (B 6 2 2) (B 6 2 1)
    6 3
    (B 6 3 4) (B 6 3 3) (B 6 3 2) (B 6 3 1)

    7 1
    (B 7 1 4) (B 7 1 3) (B 7 1 2) (B 7 1 1)
    7 2
    (B 7 2 4) (B 7 2 3) (B 7 2 2) (B 7 2 1)
    7 3
    (B 7 3 4) (B 7 3 3) (B 7 3 2) (B 7 3 1)

    8 1
    (B 8 1 4) (B 8 1 3) (B 8 1 2) (B 8 1 1)
    8 2
    (B 8 2 4) (B 8 2 3) (B 8 2 2) (B 8 2 1)
    8 3
    (B 8 3 4) (B 8 3 3) (B 8 3 2) (B 8 3 1)

    9 1
    (B 9 1 4) (B 9 1 3) (B 9 1 2) (B 9 1 1)
    9 2
    (B 9 2 4) (B 9 2 3) (B 9 2 2) (B 9 2 1)
    9 3
    (B 9 3 4) (B 9 3 3) (B 9 3 2) (B 9 3 1)

    10 1
    (B 10 1 4) (B 10 1 3) (B 10 1 2) (B 10 1 1)
    10 2
    (B 10 2 4) (B 10 2 3) (B 10 2 2) (B 10 2 1)
    10 3
    (B 10 3 4) (B 10 3 3) (B 10 3 2) (B 10 3 1)

    11 1
    (B 11 1 4) (B 11 1 3) (B 11 1 2) (B 11 1 1)
    11 2
    (B 11 2 4) (B 11 2 3) (B 11 2 2) (B 11 2 1)
    11 3
    (B 11 3 4) (B 11 3 3) (B 11 3 2) (B 11 3 1)

    12 1
    (B 12 1 4) (B 12 1 3) (B 12 1 2) (B 12 1 1)
    12 2
    (B 12 2 4) (B 12 2 3) (B 12 2 2) (B 12 2 1)
    12 3
    (B 12 3 4) (B 12 3 3) (B 12 3 2) (B 12 3 1)

    13 1
    (B 13 1 4) (B 13 1 3) (B 13 1 2) (B 13 1 1)
    13 2
    (B 13 2 4) (B 13 2 3) (B 13 2 2) (B 13 2 1)
    13 3
    (B 13 3 4) (B 13 3 3) (B 13 3 2) (B 13 3 1)

    14 1
    (B 14 1 4) (B 14 1 3) (B 14 1 2) (B 14 1 1)
    14 2
    (B 14 2 4) (B 14 2 3) (B 14 2 2) (B 14 2 1)
    14 3
    (B 14 3 4) (B 14 3 3) (B 14 3 2) (B 14 3 1)

    15 1
    (B 15 1 4) (B 15 1 3) (B 15 1 2) (B 15 1 1)
    15 2
    (B 15 2 4) (B 15 2 3) (B 15 2 2) (B 15 2 1)
    15 3
    (B 15 3 4) (B 15 3 3) (B 15 3 2) (B 15 3 1)
))