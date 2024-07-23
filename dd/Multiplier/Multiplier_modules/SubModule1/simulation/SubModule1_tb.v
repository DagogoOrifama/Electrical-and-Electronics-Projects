//Test Bench for SubModule1
`timescale 1 ns/100 ps

module SubModule1_tb;

//General register
    reg [4:0] testInput;

// Test Bench generated signals
	reg mk;
	reg mk1;
	reg q0;
	reg q1;
	reg cin;
	
//DUT output signals
	wire sum;
	wire cout;
	
// Device under test

SubModule1 SubModule_dut(
	.mk(testInput[0]	),
	.mk1(testInput[1]	),
	.q0(testInput[2]	),
	.q1(testInput[3]	),
	.cin(testInput[4]	),
	.sum(sum			),
	.cout(cout			)
	
);

//Test Bench generated signals
initial begin 
	
	testInput = 0;
// Print to the console that simulation has started and also thesimulation time
	$display("testInput\tsum\tcout");
// monitor te input an output signals
	$monitor("%b\tsum=%b\tcout=%b",testInput,sum,cout);
	
end
always begin 

// Testing for all 32 possible inputs
	repeat(32) #10 testInput = testInput + 1'b1;
	$stop;
	
	$display("%d ns\tSimulation completed",$time);
end 
endmodule 