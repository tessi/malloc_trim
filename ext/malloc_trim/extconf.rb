require "mkmf"

find_header("malloc.h")
find_header("ruby/debug.h")
have_func("malloc_trim")
abort 'error: needs ruby 2.1+' unless have_func('rb_tracepoint_new') && have_const('RUBY_INTERNAL_EVENT_GC_END_SWEEP')
create_makefile("malloc_trim/malloc_trim")
