//full adder
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
