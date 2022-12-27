import os

type SpecialConsValue = enum NIL

type ConsValue = char
# type ConsValue = ( char | SpecialConsValue | Cons )

type Cons = object
  car: ConsValue
  cdr: ConsValue

#proc cons*(a: ConsValue, b: ConsValue): Cons =
  #Cons(car: a, cdr: b)

#proc readCode(filename: string): string =
  #readFile(filename)

proc parse_to_cons(s: string): Cons =
  return Cons(car: s[0], cdr: s[1])

proc main() : Cons =
  let lisp_code_string = readFile(paramStr(1))
  parse_to_cons(lisp_code_string)

main()
