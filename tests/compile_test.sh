#!/bin/bash
PASS=0
FAIL=0

run_test() {
    name="$1"
    expected="$2"
    shift 2
    result=$(./snc "$@" 2>&1)
    if echo "$result" | grep -q "$expected"; then
        echo "PASS: $name"
        ((PASS++))
    else
        echo "FAIL: $name"
        echo "  Expected: $expected"
        echo "  Got: $result"
        ((FAIL++))
    fi
}

echo "=== String Literal Concatenation Tests ==="
echo 'fn main() { str s = "A" + "B"; print(s) }' > /tmp/t1.sn
run_test "String concat compile" "print_val_" /tmp/t1.sn

echo "=== String Var Concat Tests ==="
cat > /tmp/t2.sn << 'SN'
fn main() {
    str a = "X"
    str b = "Y"
    str c = a + b
    print(c)
}
SN
run_test "String var concat" "str_concat" /tmp/t2.sn

echo ""
echo "PASS: $PASS  FAIL: $FAIL"
