#include "malloc_trim.h"

VALUE rb_mMallocTrim;

static VALUE objtracer;

static VALUE do_malloc_trim(VALUE self) {
  /* [Experimental] Explicitly free all eligible pages to the kernel.  See:
   *
   * - https://www.joyfulbikeshedding.com/blog/2019-03-14-what-causes-ruby-memory-bloat.html
   * - https://bugs.ruby-lang.org/issues/15667
   * - http://man7.org/linux/man-pages/man3/malloc_trim.3.html
   */
  #ifdef HAVE_MALLOC_TRIM
    if (malloc_trim(0) == 1) {
      return Qtrue; // it could return some memory
    } else {
      return Qfalse; // no memory was returned
    };
  #endif
  return Qnil;
}

static VALUE has_malloc_trim(VALUE self) {
  #ifdef HAVE_MALLOC_TRIM
  return Qtrue;
  #else
  return Qfalse;
  #endif
}

static void malloc_trim_gc_end_handler(VALUE tpval, void *data) {
  #ifdef HAVE_MALLOC_TRIM
  malloc_trim(0);
  #endif
}

static VALUE enable_trimming(VALUE self) {
  #ifndef HAVE_MALLOC_TRIM
    return Qnil;
  #endif

  if (!RB_TEST(objtracer)) {
    objtracer = rb_tracepoint_new(0, RUBY_INTERNAL_EVENT_GC_END_MARK, malloc_trim_gc_end_handler, 0);
  }
  rb_tracepoint_enable(objtracer);
  return Qtrue;
}

static VALUE disable_trimming(VALUE self) {
  #ifndef HAVE_MALLOC_TRIM
    return Qnil;
  #endif

  if (RB_TEST(objtracer)) {
    rb_tracepoint_disable(objtracer);
  }
  objtracer = Qnil;
  return Qtrue;
}

void
Init_malloc_trim(void)
{
  rb_mMallocTrim = rb_define_module("MallocTrim");
  rb_define_singleton_method(rb_mMallocTrim, "trim", do_malloc_trim, 0);
  rb_define_singleton_method(rb_mMallocTrim, "trimming_possible?", has_malloc_trim, 0);
  rb_define_singleton_method(rb_mMallocTrim, "enable_trimming", enable_trimming, 0);
  rb_define_singleton_method(rb_mMallocTrim, "disable_trimming", disable_trimming, 0);
}
