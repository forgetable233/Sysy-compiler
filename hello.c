int test() {
    int a;
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
int a;

int test2() {
    int a;
    int b;
    return 0;
}

int test3() {
    int b;
    a = 1;
    b = 2;
    b = a + 1;
    return b + a * 3;
}
