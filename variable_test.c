#include "variable.h"
#include <stdio.h>

int main() {
    hash_add(var_new("abc", 10));
    hash_add(var_new("fdsa", 20.9));
    var_t *fdsa = hash_find("fdsa");
    var_t *abc = hash_find("abc");
    
    printf("%s %g\n", abc->name, abc->val);
    printf("%s %g\n", fdsa->name, fdsa->val);

    hash_delete("abc");
    abc = hash_find("abc");
    if (abc != NULL)
        printf("%s %g\n", abc->name, abc->val);
    
}
