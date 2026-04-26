OBJS = src/main.o src/parser.o src/vars.o src/codegen.o src/lexer.o src/utils.o src/data.o

snc: $(OBJS)
	clang $(OBJS) -o snc

src/%.o: src/%.s
	clang -c $< -o $@

run: snc
	./snc examples/math.sn

example: snc
	./snc examples/math.sn > /tmp/snc_example.s
	clang /tmp/snc_example.s -o /tmp/snc_example
	/tmp/snc_example

test: snc
	./snc examples/math.sn > /tmp/snc_math.s
	clang /tmp/snc_math.s -o /tmp/snc_math
	/tmp/snc_math
	./snc examples/grouping.sn > /tmp/snc_grouping.s
	clang /tmp/snc_grouping.s -o /tmp/snc_grouping
	/tmp/snc_grouping
	./snc examples/spec_slice.sn > /tmp/snc_spec_slice.s
	clang /tmp/snc_spec_slice.s -o /tmp/snc_spec_slice
	/tmp/snc_spec_slice
	./snc examples/if_else.sn > /tmp/snc_if_else.s
	clang /tmp/snc_if_else.s -o /tmp/snc_if_else
	/tmp/snc_if_else
	./snc examples/state_logic.sn > /tmp/snc_state_logic.s
	clang /tmp/snc_state_logic.s -o /tmp/snc_state_logic
	/tmp/snc_state_logic
	./snc examples/strings.sn > /tmp/snc_strings.s
	clang /tmp/snc_strings.s -o /tmp/snc_strings
	/tmp/snc_strings
	./snc examples/else_if.sn > /tmp/snc_else_if.s
	clang /tmp/snc_else_if.s -o /tmp/snc_else_if
	/tmp/snc_else_if
	./snc examples/while_loop.sn > /tmp/snc_while_loop.s
	clang /tmp/snc_while_loop.s -o /tmp/snc_while_loop
	/tmp/snc_while_loop
	./snc examples/runtime_vars.sn > /tmp/snc_runtime_vars.s
	clang /tmp/snc_runtime_vars.s -o /tmp/snc_runtime_vars
	/tmp/snc_runtime_vars
	./snc examples/runtime_exprs.sn > /tmp/snc_runtime_exprs.s
	clang /tmp/snc_runtime_exprs.s -o /tmp/snc_runtime_exprs
	/tmp/snc_runtime_exprs
	./snc examples/runtime_var_math.sn > /tmp/snc_runtime_var_math.s
	clang /tmp/snc_runtime_var_math.s -o /tmp/snc_runtime_var_math
	/tmp/snc_runtime_var_math
	./snc examples/runtime_target_math.sn > /tmp/snc_runtime_target_math.s
	clang /tmp/snc_runtime_target_math.s -o /tmp/snc_runtime_target_math
	/tmp/snc_runtime_target_math
	./snc examples/spec_batch.sn > /tmp/snc_spec_batch.s
	clang /tmp/snc_spec_batch.s -o /tmp/snc_spec_batch
	/tmp/snc_spec_batch
	./snc examples/for_loop.sn > /tmp/snc_for_loop.s
	clang /tmp/snc_for_loop.s -o /tmp/snc_for_loop
	/tmp/snc_for_loop

clean:
	rm -f snc src/*.o
