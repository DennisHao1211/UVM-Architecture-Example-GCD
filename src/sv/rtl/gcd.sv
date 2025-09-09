/******************************************************************************
 Module Name : gcd
 Description :
	 Great Common Division
	 ! gcd( 6, 2) = 2
	 ! gcd( 9,12) = 3
	 ! gcd(18,12) = 6
*******************************************************************************/



module gcd 
    #(
        parameter    WIDTH = 8
    )
    (
	    input  logic            clk_i, rst_i,   // global
	    input  logic            valid_i,        // start
	    input  logic [WIDTH-1:0]a_i, b_i,       // operands
	    output logic [WIDTH-1:0]gcd_o,          // gcd output
	    output logic            valid_o         // valid_o
    );
    
    //=========================================================================//
    //   Start of Your Code                                                    //
    //=========================================================================//

    timeunit 1ns;
    timeprecision 100ps;

    import gcd_pkg::*;
    logic [WIDTH-1:0] a_reg, b_reg;
    state_struct state_r, next_state_r;

    // Clocked present state logic
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            state_r <= IDLE;
        end else begin
            state_r <= next_state_r;
        end
    end 

    // Combinational next state logic
    always_comb begin
        //default values
        next_state_r = STATEX;
        case (state_r)
            IDLE: next_state_r = (valid_i) ? LOADING : IDLE;
            LOADING: next_state_r = COMPUTING;
            COMPUTING: next_state_r = (a_reg == b_reg) ? DONE : COMPUTING;
            DONE: next_state_r = IDLE;
            default: next_state_r = STATEX;
        endcase
    end

    //  Next-state output logic & sequential state registers
    always_ff @(posedge clk_i or posedge rst_i) begin
        if (rst_i) begin
            a_reg <= '0;
            b_reg <= '0;
            gcd_o <= '0;
            valid_o <= 1'b0;
        end else begin
            gcd_o <= '0;
            valid_o <= 1'b0;
            case (next_state_r)
                IDLE: begin
                    valid_o <= 1'b0;
                    a_reg <= '0;
                    b_reg <= '0;
                end
                LOADING: begin
                    a_reg <= a_i;
                    b_reg <= b_i;
                end
                COMPUTING: begin
                    if (a_reg > b_reg) begin
                        a_reg <= a_reg - b_reg;
                    end else if (b_reg > a_reg) begin
                        b_reg <= b_reg - a_reg;
                    end
                end
                DONE: begin
                    gcd_o <= 1'b1;
                    valid_o <= 1'b1;
                end
                default: begin
                    gcd_o <= 'x;
                    valid_o <= 1'bx;
                end
            endcase
        end
    end

    //=========================================================================//
    //   End of Your Code                                                      //
    //=========================================================================//

endmodule


