#!/bin/bash
PASS=0
FAIL=0

run_test() {
    name="$1"
    expected="$2"
    shift 2
    ./snc "$@" > /tmp/out.s 2>&1 || return 1
    cc -o /tmp/out /tmp/out.s 2>&1 || return 1
    result=$(/tmp/out 2>&1)
    if [ "$result" = "$expected" ]; then
        echo "PASS: $name"
        ((PASS++))
    else
        echo "FAIL: $name"
        echo "  Expected: '$expected'"
        echo "  Got: '$result'"
        ((FAIL++))
    fi
}

echo "=== Literal String Concatenation ==="
echo 'fn main() { str s = "AB" + "CD"; print(s) }' > /tmp/t1.sn
run_test "Two literals concat" "ABCD" /tmp/t1.sn

echo 'fn main() { str s = "Hello" + " " + "World"; print(s) }' > /tmp/t2.sn
run_test "Three literals concat" "Hello World" /tmp/t2.sn

echo "=== Variable String Concatenation ==="
cat > /tmp/t3.sn << 'SN'
fn main() {
    str a = "Hello"
    str b = "World"
    str c = a + b
    print(c)
}
SN
run_test "Var + var concat" "HelloWorld" /tmp/t3.sn

echo "=== Mixed String Concatenation ==="
cat > /tmp/t4.sn << 'SN'
fn main() {
    str a = "X"
    str c = a + "Y"
    print(c)
}
SN
run_test "Var + literal concat" "XY" /tmp/t4.sn

cat > /tmp/t5.sn << 'SN'
fn main() {
    str a = "Y"
    str c = "X" + a
    print(c)
}
SN
run_test "Literal + var concat" "XY" /tmp/t5.sn

echo ""
echo "Summary: PASS=$PASS FAIL=$FAIL"
