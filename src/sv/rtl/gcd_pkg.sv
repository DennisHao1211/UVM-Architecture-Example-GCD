package gcd_pkg;
typedef enum logic [1:0] {
        IDLE = 2'b00,
        LOADING = 2'b01,
        COMPUTING = 2'b10,
        DONE = 2'b11,
        STATEX = 2'bxx
} state_struct;
endpackage