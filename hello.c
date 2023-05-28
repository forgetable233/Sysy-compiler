// TODO 函数返回值有问题

int test2(int a, int n[10]) {
    return a + n[0];
}

int test(int f, int m[100]) {
    int a = 10;
    int d[10];
    f = a;
    a = f;
    f = test2(a + f, d[10]);
    return 0;
}