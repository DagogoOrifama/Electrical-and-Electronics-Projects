/*
 * 2-bit by 3-bit Multiplier Test Bench
 * ----------------------------
 * By:   Dagogo Orifama
 * SID: 201177661
 * Date: 05/02/2017
 *
 * Description
 * ------------
 * This is a test bench module to test the 2-bit by 3-but multiplier.
 *
 */

/* Timescale indicates unit of delays.
  `timescale  unit / precision
   Where delays are given as:
   #unit.precision
*/

`timescale 1 ns/100 ps
// Test bench module declaration
//  There is no port list for a test bench
module MultCal_tb;
//Test bench generated signal 
reg [1:0] m;    // 2-bit signal
reg [2:0] q;	// 3-bit signal

//DUT Output Signal
wire [4:0] p;	// 5-bit signal

// device Under test
MultCal MultCal_dut (
	.m(m		),
	.q(q		),
	.p(p		)
);

// Test bench logic
initial begin 
   //Print to console that the simulation has started. $time is the current simulation time.
    $display("%d ns\tSimulation Started",$time);  
    //Monitor any changes to any values listed, and print to the console when they change.
    //There can only be one $monitor per simulation.
    $monitor("%d ns\tm=%b\tq=%b\tp=%b",$time,m,q,p);
	
// Generate the testbench signals
q = 2'b0;  // initialise q=0
//increase the value of m from 0 to 3
for(m = 2'b0; m < 2'b11; m = m + 2'b1)

case(m)
// generate 7 more values of of q based on current value of m
	2'd00: repeat(8) #10 q = q + 2'b01;	//when m =0, increase q from 0 to 7 
	2'b01: repeat(8) #10 q = q + 2'b01;	//when m =1, increase q from 0 to 7
	2'b10: repeat(8) #10 q = q + 2'b01;	//when m =2, increase q from 0 to 7
endcase
	if(m==2'b11)
	repeat(8) #10 q = q + 2'b01;	//when m =3, increase q from 0 to 7
	$stop;
	
 $display("%d ns\tSimulation Finished",$time);
    //There are no other processes running in this testbench, so "run -all" in ModelSim
    //will finish the simulation automatically now.
    //We can also use $stop(); to finish the simulation whenever we want.
end


endmodule
