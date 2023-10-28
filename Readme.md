# My simple understanding of scheme programming. 

Scheme is a functional language.

![scheme-language-logo](./scheme_image.png)

## Installation.

You will be using the Racket programming environment for your Scheme programming. Although the Racket environment supports richer languages than the standard (R5RS) Scheme language, you will need to use the R5RS version of Scheme. To install Racket:

1. Go to http://racket-lang.org and click "Download" to download and install the Racket environment for your computer.

2. The IDE application is called "Dr. Racket".  The first time you run it, you must choose the right language, i.e. R5RS Scheme, for it to support.  To do so, click on the drop-down menu at the very bottom left of the Dr. Racket window. Click "Choose Language > Other Languages > R5RS", and then "OK".  At the bottom left of the Dr. Racket window, you should now see "R5RS".  If you don't see "R5RS" at the bottom of the Dr. Racket window, you will not be able to do your Scheme assignment (since we will only grade programs written in R5RS Scheme).

## Notes on Scheme Programming language

### Comments
we use semi-colon for comments.
```
;;; comments follow a semicolon.
```

### Numbers
Basic types of scheme.
```
> 452
452
```

Numbers can be large and can represent floating numbers too.
```
> 43253452535345324545
43253452535345324545

> 4543.24523
4543.24523
```
### Strings
strings are enclosed by double quotes, and are used to represent char arrays.

```
> "strings are basic types too"
"strings are basic types too"
```

### Symbols
A symbol is a basic data type. Its only characteristic is its name.
```
> 'hello
hello
```

### Boolean
True is written as `#t` and False is written as `#f`. 
```
> #t
#t

> #f
#f
```

### Expressions.
Expressions are all of the form `( ... )` with always prefix notation, operator or keyword is first. eg:
```
> (+ 3 4)
7
```

- Defining variables (these are not storage locations)
```
(define x (* 3 4))

> x
12
```


- Defining functions. The function calls are of the form: (function arg1 ... argN).
```
(define (f x y) (+ x y))

> (f 10 15)  
25
```
The scheme follows dynamic type checking, if the values cannot be operated due to type mismatch, it will throw a runtime error.

### List
Aggregate type is a list. It represents array of objects.
```
> '(1 2 3 4 5)
(1 2 3 4 5)
```

List can have heterogenous types, i.e. it need not be homogeneous.
```
> '("hello world" henry (4 5 6) #f)
("hello world" henry (4 5 6) #f)
```

Empty list can be represented as
```
> '() ;;; this is the empty list (also pronounced "NIL")
()
```

- List Operations:
Defining list: 
```
(define mylist '(1 2 3))
> mylist
(1, 2, 3)
```

`car`: Returns first element of the list:
```
(define mylist '(1 2 3))
> (car mylist)

1
```

`cdr`: Returns all the elements, except the first element.
```
(define mylist '(1 2 3))
> (cdr mylist)

(2 3)
```

`list`: Another way to create list, this operation `(list ....)` evaluates its arguments and puts them in a list. Example:
```
> (list 1 2 (+ 4 5) (string-append "hello" "world"))
(1 2 9 "helloworld")
```

`(cons x L)`: Cons is a list operation, that takes two arguments, it creates a new list with x as first element and subsequent elements come from L.
```
> (cons 1 '(1 2 3))
(1 1 2 3)
```

`(append L1 L2)`: returns a new list containing all the elements of L1 followed by the elements of L2.

```
(append '(5 6 7) '(1 2 3))
(5 6 7 1 2 3)
```

`(reverse L1)`: returns reverse of version of list L1. Example:
```
(reverse  '(1 2 3))
(3 2 1)
```

### Conditionals
There are two types of conditionals: i) `if` ii) `cond`
- `If` : It is of the form (if exp then-exp else-exp). Example:
```
(if (= 2 4) "yes" "no")
```
- `cond`: cond is the equivalent to switch-case in C++, there are multiple branches for a condition. It is of the form:
```
(cond (condition1-exp result1)
	  (condition2-exp result2)
	  ....
	  (conditionN-exp resultN)
	  (else default result))
```
Example:
```
(define (compare x y)(
            cond ((< x y) "lesser")
                 ((> x y) "greater")
                 (else "equal")
                      ))

> (compare 5 4)
"greater"
```

### Functions as parameters
Functions are "first class" - they can be passed as parameters, returned as result, put in list, etc.

```
(define (f g) (g 3))
(define (double x) (* x 2))

> (f double)
6
```

### Maps
`(map f L)`: call the function f on each element of the list L, returns a list of results.
```
(define (f g) (g 3))
(define (double x) (* x 2))

> (map double '(1 2 3 4))
(2 4 6 8)
```

### Lambda functions
It is a function that has no name, but has parameters and bodies like a normal function. It has uses in passing custom function in maps.
`(lambda (x1, x2 ... , xn) body)`

Example:
```
> (map (lambda (x) (* x 3)) '(1 2 3 4 5))
(3 6 9 12 15)
```

### Let functionality
local variables are defined using LET. Syntax is 
`(let ((x1 val1) ... (xn valn)) body)`

```
> (let ((a 3) (b 4)) (+ a b)) 
7
```

Note: we cannot make b dependent on a, it is not allowed in let expression. example, this will give error:
```
> (let ((a 3) (b (+ a 1))) (+ a b)) 
a: undefined;
cannot reference an identifier before its definition
```

This is because the scope of variables `x1, x2 .... , xn` is `body`.

we can nest lets.
Example:
```
(let ((a 3)) (let ((b (+ a 1))) (+ a b)))
```

Shortcut for nesting lets, is using let*.
```
> (let* ((a 3) (b (+ a 1))) (+ a b))
7
```

Both let and let* does not allow for recursion, for that we use letrec

```
(letrec ((fact (lambda (n) (cond((= n 0) 1)
                        (else (* n (fact (- n 1))))))))
  (fact 4))

24
```

we can define multiple recursive function using let, and they are mutually exclusive to each other, i.e. they can call each other.

```
(letrec ((fac1 (lambda (n) (if (= n 0) 1 (* n (fac2 (- n 1))))))
         (fac2 (lambda (n) (if (= n 0) 1 (* n (fac1 (- n 1)))))))
  (fac1 5))
120
```

### Predicates for lists

need to explore more.

null?
pair?
equal?
