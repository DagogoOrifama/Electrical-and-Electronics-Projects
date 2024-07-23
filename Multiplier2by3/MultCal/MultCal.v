/*
 * 2-bit by 3-bit Multiplier in Gate-Level Verilog HDL
 * ----------------------------
 * By:   Dagogo Orifama
 * SID: 201177661
 * Date: 05/02/2017
 *
 * Description
 * ------------
 * The module is a 2-bit by 3-bit multiplier which has been
 * built in Verilog using Gate-Level 1-bit full adders.
 *
 */

module MultCal(
//Declearing input and output ports
	input [1:0] m,
	input[2:0] q,
	output[4:0] p
);
Multiplier2by3 inner(
	.m(m  ),
	.q(q  ),
	.p(p  )
);
endmodule

/*
 * 2-bits by 3-bits multiplier
 * ----------------------------------
 * The module is a 2-bit by 3-bit multiplier which has been
 * built in Verilog using Gate-Level 1-bit full adders.
 *
 */

module Multiplier2by3(
//Declearing input and output ports
	input [1:0] m, 	// 2-bit input port, made up of m1,m0
	input[2:0] q,	// 3-bit input port, made up of q2,q1,q0
	output[4:0] p	// 5-bits output port, made up of p4,p3,p,p1,p0
);
and(p[0],q[0],m[0]);	// evaluating the value of p0
 wire [2:0] carry;		//carry signal between each module
 wire ppSum;

 // computing the value of p1
 SubModule1 compute_P1(
	.mk(m[0]),
	.mk1(m[1]),
	.q0(q[0]),
	.q1(q[1]),
	.cin (0),
	.sum(p[1]),
	.cout(carry[0])
 );
 // working towards computing the value of p2
 SubModule1 compute_p2a(
	.mk(m[1]),
	.mk1(0),
	.q0(q[0]),
	.q1(q[1]),
	.cin (carry[0]),
	.sum(ppSum),
	.cout(carry[1])
 
 );
 // computing the value of p2
 SubModule2 compute_p2b(
	.mk(m[0]),
	.q2(q[2]),
	.cin(0),
	.ppi(ppSum),
	.sum(p[2]),
	.cout(carry[2])
);
// computing the values of p3 and p4
 SubModule2 compute_P3_P4(
	.mk(m[1]),
	.q2(q[2]),
	.cin(carry[2]),
	.ppi(carry[1]),
	.sum(p[3]),
	.cout(p[4])
);
  
endmodule

module SubModule1(
	input mk,
	input mk1,
	input q0,
	input q1,
	input cin,
	output sum,
	output cout
);
	wire linka, linkb;
	and(linka,q1,mk);
	and(linkb,q0,mk1);
	
	FullAdder top(
		.a(linka),
		.b(linkb),
		.cin(cin),
		.sum(sum),
		.cout(cout)
	
	);
	
endmodule

module SubModule2(
	input mk,
	input q2,
	input cin,
	input ppi,
	output sum,
	output cout
);
	wire linka;
	and(linka,q2,mk);
	
	FullAdder bottom(
		.a(linka),
		.b(ppi),
		.cin(cin),
		.sum(sum),
		.cout(cout)
	);
endmodule

module FullAdder (
    // Declare input and output ports
    input  a,
    input  b,
    input  cin,
    output cout,
    output sum
);

//wires used to connect the gates 
    wire [2:0] link;

    // Instantiate gates to calculate sum output
    xor(link[0],a,b);
    xor(sum,link[0],cin);

    // Instantiate gates to calculate carry (cout) output
    and(link[1],a,b);
    and(link[2],cin,link[0]);
    or (cout,link[1],link[2]);

endmodule
