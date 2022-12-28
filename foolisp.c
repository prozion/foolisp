#include <stdio.h>
#include <stdlib.h>

// void print_chars_table(char start, char end) {
//   for (char c=start; c<=end; c++) {
//     printf("%d: %c\n", c, c);
//   }
// }

typedef enum {CONS, CHAR} cons_cell_type;

char NIL = 0;

struct Cons {
  cons_cell_type cartype;
  void* car;
  cons_cell_type cdrtype;
  void* cdr;
};

typedef struct Cons* Cptr;

#define cons(T1, T2) _Generic((T1), \
  int: _Generic((T2), \
  int: cons_char_char, \
  char: cons_char_char, \
  Cptr: cons_char_cons), \
  char: _Generic((T2), \
  int: cons_char_char, \
  char: cons_char_char, \
  Cptr: cons_char_cons), \
  Cptr: _Generic((T2), \
  int: cons_cons_char, \
  char: cons_cons_char, \
  Cptr: cons_cons_cons) \
)(T1, T2)

struct Cons* cons_char_char(char a, char b) {
  struct Cons *cp = malloc(sizeof(struct Cons));
  cp->cartype = CHAR;
  cp->car = malloc(sizeof(char));
  *(char*)cp->car = a;
  cp->cdrtype = CHAR;
  cp->cdr = malloc(sizeof(char));
  *(char*)cp->cdr = b;
  return cp;
}

struct Cons* cons_cons_cons(struct Cons* a, struct Cons* b) {
  struct Cons *cp = malloc(sizeof(struct Cons));
  cp->cartype = CONS;
  cp->car = a;
  cp->cdrtype = CONS;
  cp->cdr = b;
  return cp;
}

struct Cons* cons_char_cons(char a, struct Cons* b) {
  struct Cons *cp = malloc(sizeof(struct Cons));
  cp->cartype = CHAR;
  cp->car = malloc(sizeof(char));
  *(char*)cp->car = a;
  cp->cdrtype = CONS;
  cp->cdr = b;
  return cp;
}

struct Cons* cons_cons_char(struct Cons* a, char b) {
  struct Cons *cp = malloc(sizeof(struct Cons));
  cp->cartype = CONS;
  cp->car = a;
  cp->cdrtype = CHAR;
  cp->cdr = malloc(sizeof(char));
  *(char*)cp->cdr = b;
  return cp;
}

void print_cons(struct Cons* acons, int is_beginning) {
  if (is_beginning)
    printf("(");
  if (acons->cartype == CHAR)
    printf(" %c ", *(char*)acons->car);
  else {
    print_cons(acons->car, 1);
  }
  if (acons->cdrtype == CHAR && *(char*)acons->cdr == NIL) {
    printf(")");
    return;
  }
  else if (acons->cdrtype == CONS) {
    print_cons((struct Cons*)acons->cdr, 0);
  }
  else {
    printf(". %c )", *(char*)acons->cdr);
  }
}  

int main() {
  // print_cons(cons('a', cons(cons('d', 'e'), cons('c', cons('f', NIL)))), 1);
  print_cons(deep_reverse(cons('a', cons(cons('d', 'e'), cons('c', cons('f', NIL))))), 1);
  printf("\n");
  /*print_cons(cons_char_char('a', NIL));*/
  return 0;
}
