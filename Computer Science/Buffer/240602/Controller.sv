// `include "core_struct.vh"
// module controller (
//     input CorePack::inst_t inst,
//     output we_reg,
//     output we_mem,
//     output re_mem,
//     output is_b,
//     output is_j,
//     output npc_sel,
//     output CorePack::imm_op_enum immgen_op,
//     output CorePack::alu_op_enum alu_op,
//     output CorePack::cmp_op_enum cmp_op,
//     output CorePack::alu_asel_op_enum alu_asel,
//     output CorePack::alu_bsel_op_enum alu_bsel,
//     output CorePack::wb_sel_op_enum wb_sel,
//     output CorePack::mem_op_enum mem_op,
//     output [4:0] memdata_width
// );

//     import CorePack::*;
    
//     // fill your code
//     logic [6:0] opcode;
//     logic [3:0] funct3;
//     logic [6:0] funct7;
//     logic [4:0] rs1;
//     logic [4:0] rs2;
//     logic [4:0] rd;



// endmodule
`include "core_struct.vh"
module controller (
    input CorePack::inst_t inst,
    output we_reg,
    output we_mem,
    output re_mem,
    output is_b,
    output is_j,
    output CorePack::imm_op_enum immgen_op,
    output CorePack::alu_op_enum alu_op,
    output CorePack::cmp_op_enum cmp_op,
    output CorePack::alu_asel_op_enum alu_asel,
    output CorePack::alu_bsel_op_enum alu_bsel,
    output CorePack::wb_sel_op_enum wb_sel,
    output CorePack::mem_op_enum mem_op,
    output [4:0] memdata_width, //用于package , mask ,truncation
    output npc_sel
);

    import CorePack::*;
    // fill your code
    opcode_t opcode = inst[6:0];
    wire inst_reg=opcode==REG_OPCODE;
    wire inst_regw=opcode==REGW_OPCODE;
    wire inst_load=opcode==LOAD_OPCODE;
    wire inst_lui=opcode==LUI_OPCODE;
    wire inst_imm=opcode==IMM_OPCODE;
    wire inst_immw=opcode==IMMW_OPCODE;
    wire inst_store=opcode==STORE_OPCODE;
    wire inst_branch=opcode==BRANCH_OPCODE;
    wire inst_jalr=opcode==JALR_OPCODE;
    wire inst_jal=opcode==JAL_OPCODE;
    wire inst_auipc=opcode==AUIPC_OPCODE;

    assign we_reg= inst_reg|inst_load|inst_imm|inst_lui|inst_immw|inst_regw|inst_auipc|inst_jalr|inst_jal;
    assign we_mem= inst_store;
    assign re_mem= inst_load;
    assign is_b= inst_branch;
    assign is_j= inst_jalr | inst_jal; // npc_sel can displace the is_j
    assign npc_sel = inst_jalr | inst_jal; // branch is not in here but in cor.sv:branch_res
    funct3_t funct3;
    funct7_t funct7;

    always_comb begin
        //immgen_op
        funct3=inst[14:12];
        funct7=inst[31:25];
            if(inst_load | inst_imm | inst_immw | inst_jalr)begin
                // if((funct3 == 3'b101) && (inst_imm || inst_immw)) immgen_op = S_IMM; // srli for func3 = 101 and inst_imm = 1
                // else immgen_op=I_IMM;
                immgen_op = I_IMM;
            end else if(inst_store) immgen_op=S_IMM; // although ld is I type,but it's imm is S type
            else if(inst_branch) immgen_op=B_IMM;
            else if(inst_lui | inst_auipc) immgen_op=U_IMM;
            else if(inst_jal) immgen_op=UJ_IMM;
            else immgen_op=IMM0;
        //alu_op
            if(inst_reg | inst_imm)begin
                case(funct3)
                    3'b000:begin
                        if(inst_imm) alu_op = ALU_ADD; //I Type 没有funct7
                        else if(funct7 == 7'b0000000) alu_op=ALU_ADD;
                        else  alu_op=ALU_SUB;
                    end
                    3'b101:begin
                        if(funct7 == 7'b0000000) begin alu_op=ALU_SRL; alu_bsel = BSEL_REG; end
                        else  alu_op=ALU_SRA;
                    end
                    SLL_FUNCT3:alu_op=ALU_SLL;
                    SLT_FUNCT3:alu_op=ALU_SLT;
                    SLTU_FUNCT3:alu_op=ALU_SLTU;
                    XOR_FUNCT3:alu_op=ALU_XOR;
                    OR_FUNCT3:alu_op=ALU_OR;
                    AND_FUNCT3:alu_op=ALU_AND;
                endcase
            end else if(inst_immw | inst_regw)begin
                case(funct3)
                    3'b000:begin
                        if (funct7 == 7'b0000000) begin
                            alu_op = ALU_ADDW;
                        end else if (funct7 == 7'b0100000) begin
                            alu_op = ALU_SUBW;
                        end else begin alu_op = ALU_ADDW; end
                    end
                    3'b101:begin
                        if(funct7 == 7'b0000000) alu_op=ALU_SRLW;
                        else  alu_op=ALU_SRAW;
                    end
                    SLL_FUNCT3:alu_op=ALU_SLLW;
                    default:alu_op=ALU_ADDW;
                endcase
            end else if(inst_auipc | inst_load | inst_store | inst_jalr | inst_jal) begin
                alu_op = ALU_ADD;
            end else alu_op = ALU_ADD; //defaul
        //cmp_op
            if(inst_branch)begin
                case(funct3)
                    BEQ_FUNCT3:cmp_op=CMP_EQ;
                    BNE_FUNCT3:cmp_op=CMP_NE;
                    BLT_FUNCT3:cmp_op=CMP_LT;
                    BGE_FUNCT3:cmp_op=CMP_GE;
                    BLTU_FUNCT3:cmp_op=CMP_LTU;
                    BGEU_FUNCT3:cmp_op=CMP_GEU;
                    default:cmp_op=CMP_NO;
                endcase
            end else cmp_op=CMP_NO;
        //alu_asel
            if(inst_reg | inst_regw | inst_load | inst_imm | inst_immw | inst_store | inst_jalr) alu_asel = ASEL_REG;
            else if(inst_auipc | inst_jal | inst_branch) alu_asel = ASEL_PC;
            else alu_asel = ASEL0;
        //alu_bsel
            if(inst_reg | inst_regw) alu_bsel = BSEL_REG;
            else if (inst_load | inst_imm | inst_immw | inst_store | inst_branch | inst_jalr | inst_jal | inst_auipc | inst_lui) alu_bsel = BSEL_IMM;
            else if (inst_imm && alu_op == ALU_SRL) alu_bsel = BSEL_REG;
            else alu_bsel = BSEL0;
        //wb_sel
            if(inst_load) wb_sel = WB_SEL_MEM;
            else if(inst_imm | inst_immw | inst_reg | inst_regw | inst_auipc | inst_lui) wb_sel = WB_SEL_ALU;
            else if(inst_jalr | inst_jal) wb_sel = WB_SEL_PC;
            else wb_sel = WB_SEL0; //branch store

        //mem_op and memdata_width
            if(inst_load | inst_store) begin
                case(funct3)
                    3'b000:begin
                        mem_op = MEM_B;
                        memdata_width = 1;
                    end
                    3'b001:begin
                        mem_op = MEM_H;
                        memdata_width = 2;
                    end
                    3'b010:begin
                        mem_op = MEM_W;
                        memdata_width = 4;
                    end
                    3'b011:begin
                        mem_op = MEM_D;
                        memdata_width = 8;
                    end
                    3'b100:begin
                        mem_op = MEM_UB;
                        memdata_width = 1;
                    end
                    3'b101:begin
                        mem_op = MEM_UH;
                        memdata_width = 2;
                    end
                    3'b110:begin
                        mem_op = MEM_UW;
                        memdata_width = 4;
                    end
                    default:begin
                        mem_op = MEM_NO;
                        memdata_width = 0;
                    end
                endcase
            end else begin
                mem_op = MEM_NO;
                memdata_width = 0;
            end
    end
endmodule