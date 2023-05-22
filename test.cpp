//
// Created by dcr on 23-5-7.
//
#include <iostream>
#include <memory>
#include <string>
using namespace std;

void test(int a[3]) {
    for (int i = 0; i < 3; ++i) {
        a[i] = i;
    }
}

int main() {
    int a[3] = {0, 0, 0};
    test(a);
    for (int i = 0; i < 3; ++i) {
        cout << a[i];
    }
    return 0;
}