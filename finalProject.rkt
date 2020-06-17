; Eduardo Badillo Á. A01020716
; Isabel Maqueda     A01652906
#lang racket
(require math)
(require math/matrix)
(require math plot)
;(require /Project5.rkt)

;;;; SIMPLE STATISTICS FUNCTIONS ;;;;;;

; function to calculate length of list
(define (len lst)
    (define (len-tail lst count)
        (if (empty? lst)
            count
            (len-tail (cdr lst) (+ count 1))))
    (len-tail lst 0))

; function to return the sum of all the elements within a list
(define (sum ls)
  (define (sum-tail ls count)
    (if (empty? ls)
        count
        (sum-tail (cdr ls) (+ count (car ls))))
    )
  (sum-tail ls 0))

; function to return average of list
(define (average ls)
  (/ (sum ls) (len ls)))

; function to get maximum number of list 
(define (max ls)
  (define (max-tail ls mx)
    (if (empty? ls)
        mx
        (if (> (car ls) mx)
            (max-tail (cdr ls) (car ls))
            (max-tail (cdr ls) mx))))
  (max-tail ls 0))

; function to get minimum number of list 
(define (min ls)
  (define (minimum lst acc)
  (cond
    ((null? lst) acc)
    ((< (car lst) acc)
     (minimum (cdr lst) (car lst)))
    (else
     (minimum (cdr lst) acc))))
  (minimum (cdr ls) (car ls)))

; function to get median number of list 
(define (median lst)
  (let ((len (length lst))
        (nlst (sort lst >)))
    (if (even? len)
        (/ (+ (list-ref nlst (/ len 2)) (list-ref nlst (- (/ len 2) 1))) 2)
        (list-ref nlst (truncate (/ len 2))))))

; function to count the number of times an element appears on a list 
(define (count n ls)
  (define (count-tail n ls ctr)
    (if (empty? ls)
        ctr
        (if (eq? (car ls) n)
            (count-tail n (cdr ls) (+ ctr 1))
            (count-tail n (cdr ls) ctr))))
  (count-tail n ls 0))

; function to get the mode of a list
(define (mode lnum)
  (let loop ((lst lnum)         
             (max-counter 0)   
             (max-current #f))  
    (if (null? lst)             
        max-current             
        (let ((n (count (car lst) lnum))) 
          (if (> n max-counter) 
              (loop (cdr lst) n (car lst)) 
              (loop (cdr lst) max-counter max-current)))))) 

; function to get the standard deviation of a set
; auxiliary function to calculate a list of elements subtracted its mean
(define (subtract lst)
  (map (lambda (x) (- x (average lst))) lst)
  )

; auxiliary function to square each element in a list
(define (square lst)
  (map (lambda (x) (* x x)) lst)
  )

; function to calculate standard deviation of a set
(define (standard-deviation lst)
  (if (empty? lst)
      0
  (expt (average (square (subtract lst))) 0.5)
  ) 
  )

; function to calculate factorial of x 
(define (factorial x)
  (if (zero? x)
      1
      (* x (factorial (- x 1)))))

;;;; Poisson Distribution Function ;;;;;

; function to calculate Poisson Probability Distribution
(define (PoissPdf l x)
  (let ([e 2.71828])
    (/ (* (expt e (- l)) (expt l x)) (factorial x))))

; function to calculate Poisson Cumulative Distribution 
(define (PoissCdf l low high)
  (define (cdf x ctr)
    (if(>= x (+ high 1))
     ctr
     (cdf (+ x 1) (+ ctr (PoissPdf l x)))))
  (cdf low 0))

;(count 1 '(1 1 2 3))
;(PoissPdf 1.6 3)
;(PoissCdf 1.6 1 3)


;;;;; Linear Least Squares Regression ;;;;;;;

; auxiliary function to multiply two lists 
(define (mult-list x y)
  (if (empty? x)
      empty
      (cons (* (car x) (car y)) (mult-list (cdr x) (cdr y)))))

; auxiliary function to get slope 
(define (b1 ind dep)
  (/ (sum (mult-list (subtract ind) (subtract dep))) (sum(square (subtract ind)))))

; auxilary function to get y offset
(define (b0 b1 ind dep)
  (- (average dep) (*(average ind) b1)))

; LSR Main Function 
(define (LSR ind dep x)
  (let* ([m (b1 ind dep)] ; train model
         [b (b0 m ind dep)])
    (define (tail-lsr x) ; recursive prediction
      (if (empty? x)
          empty
          (cons (exact->inexact (+ b (* m (car x)))) (tail-lsr (cdr x)))))
    (if (list? x)
        (tail-lsr x)
        (exact->inexact (+ (* m x) b)) ; point prediction
        )))

;;;;; Polynomial Least Squares Regression ;;;;;;

; auxilary function to transpose matrix
(define (matrix-transpose M)
  (if (null? (car M))
      '()
      (cons (map car M)
            (matrix-transpose (map cdr M)))))

; auxiliary function to convert exact to inexact list
(define (inexactly ls)
  (if (empty? ls)
      empty
      (cons (exact->inexact(car ls)) (inexactly (cdr ls))))
  )

; accumulate for lists
(define (accumulate op initial items)
  (if (null? items)
      initial
      (op (car items) (accumulate op initial (cdr items)))))

; accumulate for rows
(define (accumulate-n op init seqs)
  (if (null? (car seqs))
      null
      (cons (accumulate op init (map (lambda (x) (car x)) seqs))
            (accumulate-n op init (map (lambda (x) (cdr x)) seqs)))))

; dot product for matrix * vector
(define (dot-product v w)
  (accumulate + 0 (map * v w)))

(define (matrix-*-vector m v)
  (map (lambda (row) (dot-product v row)) m))

; training function
(define (trainPLSR ind dep)
  (let* ([xy (map (lambda (x y) (* x y)) ind dep)] ; train phase
         [x2 (map (lambda (x y) (* x y)) ind ind)]
         [x3 (map (lambda (x y) (* x y)) x2 ind)]
         [x4 (map (lambda (x y) (* x y)) x3 ind)]
         [x5 (map (lambda (x y) (* x y)) x4 ind)]
         [x6 (map (lambda (x y) (* x y)) x5 ind)]
         [x2y (map (lambda (x y) (* x y)) x2 dep)]
         [x3y (map (lambda (x y) (* x y)) x3 dep)]
         [n (len ind)]
         [sumX (sum ind)]
         [sumX2 (sum x2)]
         [sumX3 (sum x3)]
         [sumX4 (sum x4)]
         [sumX5 (sum x5)]
         [sumX6 (sum x6)]
         [mat (list n sumX sumX2 sumX3 ;Sum Matrix
                sumX sumX2 sumX3 sumX4
                sumX2 sumX3 sumX4 sumX5
                sumX3 sumX4 sumX5 sumX6)]
         [MTRX (list->matrix 4 4 mat)]
         [invMTRX (matrix-inverse MTRX)] ; Inverse Matrix
         [RHS (list (sum dep) (sum xy) (sum x2y) (sum x3y))]) ; Against products vector
    (matrix-*-vector(matrix->list* (list->matrix 4 4 (inexactly(matrix->list invMTRX)))) RHS) ; produce coefficient vector
    ))

; function to use coefficients of model
(define (PLSR model x)
  (let* ([a0 (car model)]
         [a1 (car (cdr model))]
         [a2 (car (cdr (cdr model)))]
         [a3 (car (cdr (cdr (cdr model))))]
         )
    (define (tail-plsr x) ; recursive prediction
      (if (empty? x)
          empty
          (cons (exact->inexact (+ (+ (+ a0 (* a1 (car x))) (* a2 (expt (car x) 2))) (* a3 (expt (car x) 3)))) (tail-plsr (cdr x)))))
    (if (list? x)
        (tail-plsr x)
        (+ (+ (+ a0 (* a1 x)) (* a2 (expt x 2))) (* a3 (expt x 3)))) ; point prediction
    ))

; Provided a list, displays a statistical summary of it
(define (overview ls)
    (display (list "SUMMARY:\n"
             "length " (len ls) "\n"
             "Expected value" (exact->inexact(average ls)) "\n"
             "Min value " (exact->inexact(min ls)) "\n"
             "Max value " (exact->inexact (max ls)) "\n"
             "Median value " (exact->inexact (median ls)) "\n"
             "Mode " (exact->inexact (mode ls)) "\n"
             "Standard Deviation " (exact->inexact (standard-deviation ls)) "\n"
             "Variance " (exact->inexact (expt (standard-deviation ls) 2)) "\n"
             ) 
     )
  )

; test 
(define independent '(1 2 3 4 5 6 7 8 9 10 11 12))
(define dependent '(15490 13810 14804 13159 14503 14481 13929 15356 15333 17000 16436 16802))

(overview dependent)

(define months '(jan feb mar apr may jun jul aug sep oct nov dic))

; display predictions

; train polynomial model with data
(define modelPLSR (trainPLSR independent dependent))

; use polynomial model, store result in list
(define polyList (PLSR modelPLSR independent))

; function to visualize prediction results
(define (visualizePredict listx listy mon)
  (define (cycle x m x2)
    (if (empty? x)
        empty
        (begin
          (display (car m))
          (display "    " )
          (display (LSR listx listy (car x)))
          (display "    ")
          (display (car x2))
          (display "\n")
          (cycle(cdr x) (cdr m) (cdr x2))))
    )
  (display "\nmonth  linear prediction     polynomial prediction (3rd deg)\n")
  (cycle listx mon polyList)
  )
(visualizePredict independent dependent months)

; Plot the predictions and average values
(plot (list (points(map vector independent dependent))
            (function (λ (x) (PLSR modelPLSR x)) (min independent) (max independent) #:label "Polynomial") 
            (function (λ (x) (LSR independent dependent x)) (min independent) (max independent) #:color 0 #:style 'dot #:label "Linear"))
        #:x-min (min independent) #:x-max (max independent) #:y-min (- (min polyList) (standard-deviation polyList)) #:y-max (+ (max polyList) (standard-deviation polyList)))

