int main() {
    int a = 10;
    while (a > 0) {
        a = a - 1;
        if (a == 5) {
            break;
        } else {
            return a + 1;
        }
    }
    return a;
}