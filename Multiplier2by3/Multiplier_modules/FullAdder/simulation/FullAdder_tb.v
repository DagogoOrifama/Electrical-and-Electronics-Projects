
//Test Bench of full adder
`timescale 1 ns/100 ps


module FullAdder_tb;

//Test Bench generated signal 
// a - reg[0], b - reg[1], cin - reg[2]
reg [2:0] test_input;

// DUT output signal
wire sum;
wire cout;
integer counter;



//device under test
FullAdder FullAdder_dut(
	.a(test_input[0]		),
	.b(test_input[1]		),
	.cin(test_input[2]		),
	.sum(sum				),
	.cout(cout				)
);

//Test Bench genrated signal
initial begin 
	//initialise the inputs
	test_input = 1'b0;
	// print to console that simulation has started and output the current time
	$display("test_input\tSum\tcout");
	// monitor the input an output signals
	$monitor("%b\tsum=%b\tcout=%b",test_input,sum,cout);
end

always begin
	
	 //10 nanosecond for each alteration
	repeat(8) #10 test_input = test_input + 1'b1;  
	$stop;

	$display("%d nd\tSimulation completed", $time);

end
	
endmodule 