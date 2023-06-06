// TODO 函数返回值有问题
// TODO if和while的设置
int test(int f, int m[100]) {
    int a = 0;
    int b = 0;
    while (a <= 10) {
        a += 1;
        b += 1;
        if (a == 1) {
            break;
        } else {
            continue;
        }
    }
    return b;
}