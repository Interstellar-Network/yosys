#include <cstdlib>
#include <iomanip>
#include <iostream>

#include "verilog_compiler.h"

int main(int argc, char *argv[])
{
	yosys::testing::VerilogHelper::CompileVerilog("/home/root/tests/deb/adder.v", "/home/root/adder.blif");
	return 0;
}