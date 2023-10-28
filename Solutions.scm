;;; Problem1: Count-numbers
;;; Solution
;;; Base Case: when the list is 0, we return count as 0
;;; Assumption: (count-numbers M) returns count of numbers of list smaller than L
;;; Step: if the (car L) is list then return sum of (count-numbers of (car L)) and (count-numbers of (cdr L))
;;;       if the (car L) is a number then return sum of 1 and (count-numbers of (cdr L))
;;;       then else case is the (car L) is not a number and list, so return (count-numbers of (cdr L))
(define (count-numbers L) (cond ((null? L) 0)
                                (else (cond((list? (car L)) (+ (count-numbers (car L)) (count-numbers (cdr L))))
                                           ((number? (car L)) (+ 1 (count-numbers (cdr L))))
                                           (else (count-numbers (cdr L)))))))
;;; test-case
(count-numbers '(11 (22 (a 33 44) 55) (6 (b 7 8 (9 c) 100 d))))
(count-numbers '(2 (a b 3) (1 (a 2)) 33 (4)))


;;; Problem2: Insert
;;; Solution
;;; Base case: when L is empty list, we create list of the element x and return.
;;; Assumption: the insert function works on list M, which has size less than L.
;;; Step: when we find a (car L) greater than x, we cons x to that list and return it.
;;;       else we have not found the right position, so we cons the car of L to the recursive
;;;       call of insert of x to the cdr of L.
(define (insert x L) (cond ((null? L) (list x))
                           ((< x (car L)) (cons x L))
                           (else (cons (car L) (insert x (cdr L))))))
;;; test-case
(insert 5 '(1 2 3 4 6 7 8))
(insert 9 '(1 2 3 4 5 6 7 8))
(insert 0 '(1 2 3 4 5 6 7 8))
(insert 6 '(1 2 3 4 5 6 7 8))


;;; Problem3: Insert-all
;;; Solution
;;; Base case: when L is empty list, we return M.
;;; Assumption: Insert-all works for a list S, where length of S is less than L.
;;; Step: we insert-all the cdr L and insert car of L to M, (basically inserting the first
;;;       element of L, and insert it and then 
(define (insert-all L M)(cond ((null? L) M)
                              (else (insert-all (cdr L) (insert (car L) M)))))
;;; test-case
(insert-all '(2 4) '(1 3 5))


;;; Problem4: Sort
;;; Solution
;;; The induction proof for insert and insertall holds true from problem2 and problem3
;;; we use define two recursive function insert and insert-all using LETREC
;;; we insert all the elements in L, insorted way (like insertion sort) using insert-all
;;; on L and an empty result set.
(define (sort L)
  (letrec ((insert (lambda (x S) (cond ((null? S) (list x))
                                 ((< x (car S)) (cons x S))
                                 (else (cons (car S) (insert x (cdr S)))))))
           (insert-all (lambda (L M) (cond ((null? L) M)
                                           (else (insert-all (cdr L) (insert (car L) M)))))))
           (insert-all L '())))
;;; test-case
(sort '(3 6 1 5 2 7 4))


;;; Problem5: translate
;;; Solution
;;; There are no recusive part to this solution, using cond to return four kinds of lambda fucntion.
(define (translate x) (cond ((eq? x '+) (lambda (a b) (+ a b)))
                            ((eq? x '-) (lambda (a b) (- a b)))
                            ((eq? x '*) (lambda (a b) (* a b)))
                            ((eq? x '/) (lambda (a b) (/ a b)))
                            (else (lambda (a b) "illegal operator symbol"))))
;;; test-case
((translate '*) 3 4)
(translate '-)

;;; Problem6: Postfix-eval
;;; Solution
;;; Base Case: when expression is number, then we return the number.
;;;            i.e whern number of elements in exp = 1, if it is a list then it must have three elements.
;;; Assumption: The postfix-eval exp, works on all any exp smaller than the exp given.
;;; Step: If it is not base case, then the exp must be a nest list with 3 elements, with first two elements
;;; as list (or nested list) and last element as op. We get the lambda function of 3rd element through 'caddr'
;;; then we pass the result of first element (postfix-eval (car exp)) and second element(postfix-eval (cadr exp))
;;; correctness of postfix-eval of first and second element is true from assumption.
(define (postfix-eval exp)
  (cond ((number? exp) exp)
        (else ((translate (caddr exp)) (postfix-eval (car exp)) (postfix-eval (cadr exp))))))
;;; test-case
(postfix-eval '((16 12 *) ((2 6 +) (9 1 -) *) /))


;;; Problem7: Powerset.
;;; Solution:
;;; (powerset L)
;;; Base Case: when the list L is null, we return list containing empty list '(())
;;; Assumption: (powerset M) returns powerset of M, where M has number of elements less than L.
;;; Step: Logc: we calculate the power set of (cdr L) then we we need to create two sets and append them
;;; -> set1: is powerset of (cdr L)
;;; -> set2: with (car L) inserted into all the list present inside powerset of (cdr L)
;;; -> result is appending of set1 and set2.

;;; we use p-insert to insert one element into all the list-element present in a list
;;; i.e (p-insert 1 '((2 3) (3 4) (9 2) (4 5 6)) = ((1 2 3) (1 3 4) (1 9 2) (1 4 5 6))
;;; the p-insert is implemented as letrec variable through recursive lambda function which takes
;;; two arguments: element x and list of lists S.

;;; (p-insert x S)
;;; Base Case: when S is null, we return empty list '().
;;; Assumption: (p-insert x M) returns inserted x into list of list M, where M has lesser elements than S
;;; Step: insert x into car S, through cons [inserting x at the beginning of the first element list]. Then
;;; append it with the result of insert x with (p-insert x (cdr S)). p-insert on cdr S is true because of
;;; inductive assumption.
(define (powerset L)
  (letrec ((p-insert (lambda (x S) (cond((null? S) '())
                                        (else (append (list (cons x (car S))) (p-insert x (cdr S))))))))
      (cond((null? L) (list '()))
           (else (append (p-insert (car L) (powerset (cdr L))) (powerset (cdr L)))))))
;;; test-casee
(powerset '(1 2 3))