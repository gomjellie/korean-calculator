#include "variable.h"
#include "uthash.h"

#include <stdlib.h>
#include <string.h>

extern var_t *hash_head;

var_t *var_new(char *name, double val) {
    var_t *this = malloc(sizeof(var_t));
    strcpy(this->name, name);
    this->val = val;

    return this;
}

void var_del(var_t *this) {
    free(this);
}

void hash_add(var_t *this) {
    HASH_ADD_STR(hash_head, name, this);
}

var_t *hash_find(char *key) {
    var_t *ret;
    HASH_FIND_STR(hash_head, key, ret);

    return ret;
}

void hash_delete(char *key) {
    var_t *search = hash_find(key);
    HASH_DEL(hash_head, search);
    var_del(search);
}
