import os
import strutils

type CellType = enum INT STR CNS NIL

type
  Cons = ref object
    is_nil: bool
    car_type: CellType
    car_value: string
    car_ptr: Cons
    cdr_type: CellType
    cdr_value: string
    cdr_ptr: Cons

proc is_value(v: CellType): bool =
  v == INT or v == STR

let empty = Cons(is_nil: true)

proc is_nil(cns: Cons): bool =
  cns.is_nil

# proc parse_to_cons(s: string): Cons =
#   return Cons(car: s[0], cdr: s[1])

proc cons_to_string(v: Cons, is_beginning = true): string =
  let
    initial_value = if is_beginning: "(" else: ""
    pad_space = if is_beginning: "" else: " "
    car = if v.car_type == CNS:
            format("$1$2", pad_space, cons_to_string(v.car_ptr, true))
            # format("666")
          else:
            format("$1$2", pad_space, v.car_value)
            # format("222")
    cdr = if v.cdr_type == NIL:
            format(")")
            # format("333")
          elif v.cdr_type == CNS:
            cons_to_string(v.cdr_ptr, false)
            # format("555")
          else:
            format(" . $1)", v.cdr_value)
            # format("444")
  format("$1$2$3", initial_value, car, cdr)

proc cons(a: string, b: string): Cons =
  Cons(car_type: STR, car_value: a, cdr_type: STR, cdr_value: b)

proc cons(a: string, b: Cons): Cons =
  if is_nil b:
    Cons(car_type: STR, car_value: a, cdr_type: NIL)
  else:
    Cons(car_type: STR, car_value: a, cdr_type: CNS, cdr_ptr: b)

proc cons(a: Cons, b: string): Cons =
  Cons(car_type: CNS, car_ptr: a, cdr_type: STR, cdr_value: b)

proc cons(a: Cons, b: Cons): Cons =
  if is_nil b:
    Cons(car_type: CNS, car_ptr: a, cdr_type: NIL)
  else:
    Cons(car_type: CNS, car_ptr: a, cdr_type: CNS, cdr_ptr: b)

proc cons(a: int, b: int): Cons = cons(a.int_to_str, b.int_to_str)
proc cons(a: int, b: Cons): Cons = cons(a.int_to_str, b)
proc cons(a: Cons, b: int): Cons = cons(a, b.int_to_str)

let my_cons = cons(cons(3, cons("foo", empty)), cons(15, cons(cons(13, 17), empty)))
echo cons_to_string(my_cons)

# proc main() : Cons =
#   let lisp_code_string = readFile(paramStr(1))
#   parse_to_cons(lisp_code_string)
#
# main()
