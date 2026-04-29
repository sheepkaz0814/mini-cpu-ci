#include "Vtop.h"
#include "verilated.h"

int main() {
    Vtop* top = new Vtop;
    while (!Verilated::gotFinish()) {
        top->eval();
    }
    delete top;
    return 0;
}