//
// Created by dcr on 23-5-7.
//
#include <iostream>
#include <memory>
#include <string>


class base{
public:
    virtual void out() const = 0;
};

class next : public base {
public:
    next();

    void out() const override {
        std::cout << "test ";
    }
};

next::next() {

}

int main() {
    base *test_1 = new next();
    test_1->out();

    delete test_1;
    auto a = new std::string("test1");
    auto test = std::unique_ptr<std::string>(a);
    return 0;
}