//Test Bench for SubModule1
`timescale 1 ns/100 ps

module SubModule2_tb;

//General register
    reg [3:0] testInput;

// Test Bench generated signals
	reg mk;
	reg q2;
	reg cin;
	reg ppi;
	
//DUT output signals
	wire sum;
	wire cout;
	
// Device under test

SubModule2 SubModule_dut(
	.mk(testInput[0]	),
	.q2(testInput[1]	),
	.cin(testInput[2]	),
	.ppi(testInput[3]	),
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
	repeat(16) #10 testInput = testInput + 1'b1;
	$stop;
	
	$display("%d ns\tSimulation completed",$time);
end 
endmodule 