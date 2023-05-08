//
// Created by dcr on 23-5-7.
//
#include <iostream>
#include <memory>
#include <string>


class base {
public:
    virtual void out() const = 0;
};

class next : public base {
public:
    next();

    int a = 1;

    void out() const override {
        std::cout << "test ";
    }
};

next::next() {

}

int main() {
    base *test_1 = new next();
    test_1->out();

    next *test2 = (next *) test_1;
    std::cout << test2->a ;


    return 0;
}