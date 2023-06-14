int a[10][10];


int test2(int a[10][10]) {
    a[0][10] = 1;
    return 0;
}

int test (int c[10][10]) {
    int b[10][10];
    int d;
    d = test2(a);
    d = test2(b);
    d = test2(c);
    return 0;
}
