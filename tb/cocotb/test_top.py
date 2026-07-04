import cocotb
from cocotb.triggers import Timer
from cocotb.triggers import RisingEdge 
from cocotb.clock import Clock

@cocotb.test()
async def test_cpu(dut):
#    await Timer(20, units='ns')
#    r1 = dut.u_regfile.regs[1].value
#    assert r1 == 5, f"FAILED: Expected r1 to be 5, but got {r1}"

    clock = Clock(dut.clk, 10, units='ns')  # Create a clock with a period of 10 ns
    cocotb.start_soon(clock.start())  # Start the clock

    dut.rst.value = 1  # Assert reset
    for i in range(5):
        await RisingEdge(dut.clk)  # Wait for a few clock cycles while reset is asserted
    dut.rst.value = 0  # Deassert reset 

    for i in range(10):
        await RisingEdge(dut.clk)

    await Timer(1, units='ns')  # Wait for a short time after the clock edge to ensure the values are updated
    r1 = dut.u_regfile.regs[1].value
    r2 = dut.u_regfile.regs[2].value
    r3 = dut.u_regfile.regs[3].value
    r4 = dut.u_regfile.regs[4].value
    r5 = dut.u_regfile.regs[5].value
    r6 = dut.u_regfile.regs[6].value
    print(f"r1={int(r1)} r2={int(r2)} r3={int(r3)} r4={int(r4)} r5={int(r5)} r6={int(r6)}")
#    print(f"Cycle {i}: r1 = {r1}, r2 = {r2}")
#    assert r1 == 5, f"FAILED: Expected r1 to be 5, but got {r1}"
#    assert r2 == 3, f"FAILED: Expected r2 to be 3, but got {r2}"
#    assert r3 == 8, f"FAILED: Expected r3 to be 8, but got {r3}"
#    assert r4 == 2, f"FAILED: Expected r4 to be 2, but got {r4}"
#    assert r5 == 1, f"FAILED: Expected r5 to be 1, but got {r5}"
#    assert r6 == 7, f"FAILED: Expected r6 to be 7, but got {r6}"

    r1 = int(dut.u_regfile.regs[1].value)
    r2 = int(dut.u_regfile.regs[2].value)
    r3 = int(dut.u_regfile.regs[3].value)

    assert r1 == 5, \
        f"FAILED: Expected r1=16, got {r1}"

    assert r2 == 5, \
        f"FAILED: Expected r2=123, got {r2}"

    assert r3 == 2, \
        f"FAILED: Expected r3=123, got {r3}"