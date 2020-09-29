#include "variable.h"
#include <stdio.h>

int main() {
    var_t *v1 = var_new("abc", 10);

    hash_add(v1);

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
