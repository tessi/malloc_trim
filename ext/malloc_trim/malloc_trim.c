#include "malloc_trim.h"

VALUE rb_mMallocTrim;

void
Init_malloc_trim(void)
{
  rb_mMallocTrim = rb_define_module("MallocTrim");
}
