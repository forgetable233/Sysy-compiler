int a[10][10];
int q[10];

int test2(int a[10]) {
    a[0] = 1;
    return 0;
}

int test3(int a[10]) {
    a[0] = 1;
    return 0;
}

int test (int c[10][10], int m[10]) {
    int b[10][10];
    int n[10];
    int d;
//    int f[10];
//    d = test2(a[0] + 1);
//    d = test2(b[0] + 1);
    d = test2((1 + c[0]) - 1);
//    d = test2(n + 1);
//    d = test2(q + 1);
//    d = test2(m + 1);
//    d = test3(f);
    return 0;
}
