number_of_tests_executed=0
number_of_tests_failed=0

trap 'exit $number_of_tests_failed' 0

plan () {
    local plan; plan=$1
    echo "1..$plan"
}

ok () {
    local cmd name; cmd=$1; name=$2
    number_of_tests_executed=$(expr $number_of_tests_executed + 1)
    if eval "$cmd"; then
        echo "ok $number_of_tests_executed $name"
    else
        echo "not ok $number_of_tests_executed $name"
        number_of_tests_failed=$(expr $number_of_tests_failed + 1)
        return 1
    fi
}

is () {
    local got expected name; got=$1; expected=$2; name=$3

    ok 'test "$got" = "$expected"' "$name"
    if [ $? -ne 0 ]; then
        printf '# got: %s\n' "$got"
        printf '# expected: %s\n' "$expected"
    fi
}

eq () {
    local got expected name; got=$1; expected=$2; name=$3

    ok 'test "$got" -eq "$expected"' "$name"
}
