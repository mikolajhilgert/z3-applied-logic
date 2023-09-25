;(move,peg,position)->diskVal
(declare-fun B (Int Int Int) Int)

; timepoint at which the required end-state is reached
(declare-const N Int)

; returns the total of all disks and rods per move
(define-fun TotalPerMove((t Int)) Int
	(+
        (B t 1 1) (B t 1 2) (B t 1 3)
        (B t 2 1) (B t 2 2) (B t 2 3)
        (B t 3 1) (B t 3 2) (B t 3 3)
	)
)

; returns the total amount of zeros per move
(define-fun ZeroCountPerMove((t Int)) Int
    (+
        (ite(=(B t 1 1) 0) 1 0) (ite(=(B t 1 2) 0) 1 0) (ite(=(B t 1 3) 0) 1 0) 
        (ite(=(B t 2 1) 0) 1 0) (ite(=(B t 2 2) 0) 1 0) (ite(=(B t 2 3) 0) 1 0) 
        (ite(=(B t 3 1) 0) 1 0) (ite(=(B t 3 2) 0) 1 0) (ite(=(B t 3 3) 0) 1 0) 
    ) 
)

;function for disk movement, that says one position in the rod changes
;and two stay the same. As per rule to move one disk per MOVE.
(define-fun DiskMovement ((t Int) (row Int) (p1 Int) (p2 Int) (p3 Int)) Bool
    (and
        ;different positions
        (distinct p1 p2 p3)
        (<= 1 p1 3)
        (<= 1 p2 3)
        (<= 1 p3 3)

        ;two position on the rod stays the same, whilst one changes
        (distinct (B t row p1) (B (+ t 1) row p1))
        (= (B t row p2)(B (+ t 1) row p2))
        (= (B t row p3)(B (+ t 1) row p3))
    )
)

(assert (and
    ;start state
    (= (B 0 1 1) 3) (= (B 0 1 2) 2) (= (B 0 1 3) 1)
    (= (B 0 2 1) 0) (= (B 0 2 2) 0) (= (B 0 2 3) 0)
    (= (B 0 3 1) 0) (= (B 0 3 2) 0) (= (B 0 3 3) 0)

    ;wanted-end state
    (= (B N 1 1) 0) (= (B N 1 2) 0) (= (B N 1 3) 0)
    (= (B N 2 1) 0) (= (B N 2 2) 0) (= (B N 2 3) 0)
    (= (B N 3 1) 3) (= (B N 3 2) 2) (= (B N 3 3) 1)

    ;A disk on the bottom must be larger than the one above it, and the one above it must be 
    ;larger than the one above that one (or equal to, in an instance of a 0)
    (forall ((t Int) (rod Int))
        (=> 
            (<= 0 t N)
            (>= (B t rod 1) (B t rod 2) (B t rod 3))
        )
    )

    ; total for disks is 6, and there are 6 zeros per step
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
                    (= (B t r1 3) (B (+ t 1) r1 3))
                    (= (B t r1 2) (B (+ t 1) r1 2))
                    (= (B t r1 1) (B (+ t 1) r1 1))

                    ;There exists a position in a another rod that becomes 0 -> movement of the disk
                    (exists ((p1 Int) (p2 Int) (p3 Int))
                        (and
                            ;disk movement
                            (DiskMovement t r2 p1 p2 p3)
                            ;one position becomes 0
                            (= (B (+ t 1) r2 p1) 0)
                        )
                    )

                    ;There exists a position in the last rod that becomes either 1,2 or 3. 
                    (exists ((p1 Int) (p2 Int) (p3 Int))
                        (and
                            ;disk movement
                            (DiskMovement t r3 p1 p2 p3)
                            ;one position becomes 1, 2 or 3
                            (or
                                (= (B (+ t 1) r3 p1) 1)
                                (= (B (+ t 1) r3 p1) 2)
                                (= (B (+ t 1) r3 p1) 3)
                            )
                        )
                    )
                )
            )
        )
    )
    ;limit on steps
    (<= 0 N 7)
))

(check-sat)
(get-value(
    N
    0 1
    (B 0 1 3) (B 0 1 2) (B 0 1 1)
    0 2
    (B 0 2 3) (B 0 2 2) (B 0 2 1)
    0 3
    (B 0 3 3) (B 0 3 2) (B 0 3 1)
    1 1
    (B 1 1 3) (B 1 1 2) (B 1 1 1)
    1 2 
    (B 1 2 3) (B 1 2 2) (B 1 2 1)
    1 3
    (B 1 3 3) (B 1 3 2) (B 1 3 1)
    2 1
    (B 2 1 3) (B 2 1 2) (B 2 1 1)
    2 2
    (B 2 2 3) (B 2 2 2) (B 2 2 1)
    2 3
    (B 2 3 3) (B 2 3 2) (B 2 3 1)
    3 1
    (B 3 1 3) (B 3 1 2) (B 3 1 1)
    3 2
    (B 3 2 3) (B 3 2 2) (B 3 2 1)
    3 3
    (B 3 3 3) (B 3 3 2) (B 3 3 1)
    4 1
    (B 4 1 3) (B 4 1 2) (B 4 1 1)
    4 2
    (B 4 2 3) (B 4 2 2) (B 4 2 1)
    4 3
    (B 4 3 3) (B 4 3 2) (B 4 3 1)
    5 1
    (B 5 1 3) (B 5 1 2) (B 5 1 1)
    5 2
    (B 5 2 3) (B 5 2 2) (B 5 2 1)
    5 3
    (B 5 3 3) (B 5 3 2) (B 5 3 1)
    6 1
    (B 6 1 3) (B 6 1 2) (B 6 1 1)
    6 2
    (B 6 2 3) (B 6 2 2) (B 6 2 1)
    6 3
    (B 6 3 3) (B 6 3 2) (B 6 3 1)
    7 1
    (B 7 1 3) (B 7 1 2) (B 7 1 1)
    7 2
    (B 7 2 3) (B 7 2 2) (B 7 2 1)
    7 3
    (B 7 3 3) (B 7 3 2) (B 7 3 1)
))