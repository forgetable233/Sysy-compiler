//
// Created by dcr on 23-5-7.
//
#include <iostream>
#include <memory>
#include <string>
#include <llvm/IR/BasicBlock.h>
using namespace std;

void test(int a[3]) {
    for (int i = 0; i < 3; ++i) {
        a[i] = i;
    }
}