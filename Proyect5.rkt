#|
    Final Proyect 

    Isabel Maqueda A01652906
    Eduardo Badillo 

    16/6/2020
|#

#lang racket
(require racket/string)


;gets the n element of a list 
(define (element-in data n-column)
    (list(list-ref data n-column))
)


;splits the line into a list
(define (split line)
    (string-split (string-trim line) ",")
)

(define (get-list n-column input-file)
    (count-different(column-maker n-column input-file))
)

;a function that gets the average of a list

(define (get-average n-column input-file)
    (map (lambda (average) (/ average 7)) (get-list n-column input-file))
    
)

(define (count-different datos)
    ;sort the data 
    (define sorted (sort datos string<?))
    (let loop
        ([lst empty]
        [count 0]
        [sorted sorted])

        (if (empty? sorted)
            lst
            (if (or (empty? (cdr sorted)) (not (equal? (first sorted) (second sorted))))
                (loop
                    (append lst (list (add1 count)))
                    0
                    (cdr sorted)
                )
                (loop 
                    lst
                    (add1 count)
                    (cdr sorted)
                )
                        
            );si la lista se acaba  
        
        )
    )
    ;loop  crea una lista diferente, que vaya haciendo un count que aumente si elementos es igual que vaya comparando el primero con el segundo y se mueva el segundo
    ;
    ;cuando sea diferente agregee 

)

(define (column-maker n-column input-file)
    (call-with-input-file input-file 
        (lambda (in)
            ;read the header
            (read-line in)
            ;iterate over the file
            (let loop
                ;creates an empty list and pases the column number as parameters 
                ([lst empty]
                [n-column n-column])
                ;iteration actions 
                (define line (read-line in))
                    (if (eof-object? line)
                        lst
                            ;split the line into a list and send it into threads
                            ;split the line into a list
                            ;gets the n element of a list
                            ;adds the element to the list 
                        (if(< 15 n-column) ; checks that the column asked is smaller that 15, if not you will automatically get the month
                            (loop 
                                (append 
                                    lst 
                                    (list (last (split line))))
                                n-column
                            )
                            (loop
                                (append 
                                    lst 
                                    (element-in (split line) n-column))
                                n-column

                            )
                            )))))
)