;6 Adjacency lists. Number of adjacency list. Index of the list -> Value.
(declare-fun Adj (Int Int) Int)
;Step. Level (1->Sum, 2->Predecessor).
(declare-fun Result (Int) Int)

(define-fun isPrime ((Input Int)) (Bool)
    (and 
        (> Input 0)
        (not 
            (exists ((y Int) (x Int)) 
                (and 
                (= Input (* x y)) 
                (< x Input) 
                (< y Input)  
                (> x 1) (> y 1) 
                )
            ) 
        ) 
    ) 
)

(assert
(and

(= (Adj 1 1) 2) (= (Adj 1 2) 3)  (= (Adj 1 3) 4) 
(= (Adj 2 1) 2) (= (Adj 2 2) 8)  (= (Adj 2 3) 4) 
(= (Adj 3 1) 2) (= (Adj 3 2) 8)  (= (Adj 3 3) 10) 
(= (Adj 4 1) 2) (= (Adj 4 2) 10)  (= (Adj 4 3) 6) 
(= (Adj 5 1) 2) (= (Adj 5 2) 20)  (= (Adj 5 3) 6) 
(= (Adj 6 1) 2) (= (Adj 6 2) 3)  (= (Adj 6 3) 20) 

(= (Result 1) 3)
(= (Result 12) 79)

(forall ((step Int))
    (=> (<= 1 step 11)
            (exists ((adjList Int) (element1 Int) (element2 Int))
                (and
                    (<= 1 adjList 6)
                    (<= 1 element1 3)
                    (<= 1 element2 3)
                    (distinct element1 element2)

                    (= (Adj adjList element1) (- (Result (+ step 1)) (Result step)))

                    (= (Result (+ step 1)) (+ (Result step) (Adj adjList element2)))
                    (isPrime (Result (+ step 1)))
                )
            )
    )
    
    )
)
)

(check-sat)
(get-value(
    (Result 1)
    (Result 2)
    (Result 3)
    (Result 4)
    (Result 5)
    (Result 6)
    (Result 7)
    (Result 8)
    (Result 9)
    (Result 10)
    (Result 11)
    (Result 12)
    
))
