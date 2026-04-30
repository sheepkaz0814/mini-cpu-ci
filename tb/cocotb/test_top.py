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

    for i in range(5):
        await RisingEdge(dut.clk)

    await Timer(1, units='ns')  # Wait for a short time after the clock edge to ensure the values are updated
    r1 = dut.u_regfile.regs[1].value
#    print(f"Cycle {i}: r1 = {r1}")
    assert r1 == 5, f"FAILED: Expected r1 to be 5, but got {r1}"