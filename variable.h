#ifndef __VARIABLE_H__
#define __VARIABLE_H__

#include "uthash.h"

typedef struct _var {
    int id;
    UT_hash_handle hh;
    
    char name[64];
    double val;
} var_t;

var_t *hash_head;

var_t *var_new(char *name, double val);

void var_del(var_t *this);

void hash_add(var_t *this);

var_t *hash_find(char *key);

void hash_delete(char *key);

#endif /* __VARIABLE_H__ */
