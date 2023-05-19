int test(int p) {
    int b1;
    a = 1;
    if (a) {
        int b1;
        b1 = 10;
        if (b1) {
            int f;
            int a;
//            f = 100;
            a = 100;
            b1 = 1000;
        }
    }
    return 0;
}
int test_func;

int test2() {
    int a;
    int b;
    return 0;
}

int test3() {
    int b;
    test_func = 1;
    b = 2;
    b = test_func + 1;
    return b + test_func * 3;
}
