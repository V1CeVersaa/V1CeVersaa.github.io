`include"core_struct.vh"
module Cmp (
    input CorePack::data_t a,
    input CorePack::data_t b,
    input CorePack::cmp_op_enum cmp_op,
    output cmp_res
);

    import CorePack::*;

    // fill your code
    always_comb begin
        case (cmp_op)
            CMP_NO: cmp_res = 0;
            CMP_EQ: cmp_res = (a == b) ? 1 : 0;
            CMP_NE: cmp_res = (a != b) ? 1 : 0;
            CMP_LT: cmp_res = ($signed(a) < $signed(b)) ? 1 : 0;
            CMP_GE: cmp_res = ($signed(a) >= $signed(b)) ? 1 : 0;
            CMP_LTU: cmp_res = (a < b) ? 1 : 0;
            CMP_GEU: cmp_res = (a >= b) ? 1 : 0;
            default: cmp_res = 0;
        endcase
    end
    
endmodule