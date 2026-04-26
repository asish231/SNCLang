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

clean:
	rm -f snc src/*.o
