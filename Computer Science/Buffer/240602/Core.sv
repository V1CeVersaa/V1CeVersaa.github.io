`include "core_struct.vh"
module Core (
    input clk,
    input rst,

    Mem_ift.Master imem_ift,
    Mem_ift.Master dmem_ift,

    output cosim_valid,
    output CorePack::CoreInfo cosim_core_info
);
    import CorePack::*;
    
    // fill your code
    logic [63:0] next_pc;
    logic [63:0] pc;
    logic [31:0] inst;
    logic [63:0] inst_unselected;
    logic        cmp_res;           // assigned with br_taken to be used in PC
    logic        br_taken;          // 1 for take the branch

    logic [63:0] alu_res;           // the output of the alu_unit
    logic [63:0] ro_addr;
    logic [63:0] ro_rdata;

    logic        we_reg;
    logic        we_mem;
    logic        re_mem;
    logic        npc_sel;           // 1 for branch or jump instruction
    logic [2 :0] immgen_op;
    logic [3 :0] alu_op;
    logic [2 :0] cmp_op;
    logic [1 :0] alu_asel;
    logic [1 :0] alu_bsel;
    logic [1 :0] wb_sel;
    logic [2 :0] mem_op;
    logic [4 :0] memdata_width;
    logic [63:0] wb_val;

    parameter    pc_increment = 4;


    // Part PC
    always_comb begin
        br_taken = cmp_res;
        if (br_taken | npc_sel) begin
            next_pc = alu_res;
        end else begin
            next_pc = pc + pc_increment;
        end
        ro_addr = pc;
    end

    always @(posedge clk) begin
        if (rst) begin 
            pc <= 64'b0;
        end else begin
            pc <= next_pc;
        end
    end

    // Part IMEM
    always_comb begin
        imem_ift.r_request_valid        = 1;
        imem_ift.r_request_bits.raddr   = ro_addr;
        imem_ift.r_reply_ready          = 1;
        imem_ift.w_request_bits.wdata   = 0;
        imem_ift.w_request_bits.waddr   = 0;
        imem_ift.w_request_bits.wmask   = 0;
        imem_ift.w_request_valid        = 0;
        imem_ift.w_reply_ready          = 0;
        ro_rdata                        = imem_ift.r_reply_bits.rdata;
        inst_unselected                 = ro_rdata;
    end

    // Part Inst Selector
    always_comb begin
        if (pc[2] == 1) begin
            inst = inst_unselected[63:32];
        end else begin
            inst = inst_unselected[31:0];
        end
    end

    // Part RegFile
    logic [4 :0] rs1;
    logic [4 :0] rs2;
    logic [4 :0] rd;
    logic [63:0] read_data_1;
    logic [63:0] read_data_2;

    always_comb begin
        rs1 = inst[19:15];
        rs2 = inst[24:20];
        rd  = inst[11:7];
    end

    RegFile regf(.clk(clk),
                .rst(rst),
                .we(we_reg),
                .read_addr_1(rs1),
                .read_addr_2(rs2),
                .write_addr(rd),
                .write_data(wb_val),
                .read_data_1(read_data_1),
                .read_data_2(read_data_2)

    );

    // Part Imm Gen
    logic [63:0] Imm;
    always_comb begin
        case(immgen_op)
            IMM0: Imm = 64'b0;
            I_IMM: Imm = {{52{inst[31]}}, inst[31:20]};
            S_IMM: Imm = {{52{inst[31]}}, inst[31:25], inst[11:7]};
            B_IMM: Imm = {{51{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0};
            U_IMM: Imm = {{32{inst[31]}}, inst[31:12], 12'b0};
            UJ_IMM: Imm = {{43{inst[31]}}, inst[31], inst[19:12], inst[20], inst[30:21], 1'b0};
            default: Imm = 64'b0;
        endcase
    end

    // Part Branch Comparator
    Cmp cmp(.a(read_data_1),
            .b(read_data_2),
            .cmp_op(cmp_op),
            .cmp_res(cmp_res)
    );

    // ALU A Selector: ASEL0 for 0, REG for RS1, PC for PC
    logic [63:0] alu_a;
    always_comb begin
        case(alu_asel)
            ASEL0:     alu_a = 64'b0;
            ASEL_REG:  alu_a = read_data_1;
            ASEL_PC:   alu_a = pc;
            default:   alu_a = 64'b0;
        endcase
    end
    // ALU B Selector: BSEL0 for 0, REG for RS2, IMM for Imm
    logic [63:0] alu_b;
    always_comb begin
        case(alu_bsel)
            BSEL0:     alu_b = 64'b0;
            BSEL_REG:  alu_b = read_data_2;
            BSEL_IMM:  alu_b = Imm;
            default:   alu_b = 64'b0;
        endcase
    end
    // Part ALU
    ALU alu_unit(.a(alu_a),
                 .b(alu_b),
                 .alu_op(alu_op),
                 .res(alu_res)
    );

    // Data Package with mask
    logic [63:0] wdata_data;
    logic [7 :0] wdata_mask;
    integer location = {29'b0, alu_res[2:0]};
    integer mask_width;
    
    always_comb begin
        mask_width = {27'b0, memdata_width[4:0]};
        mask_width = mask_width * 8;
        for (integer i = 0; i < 8; i = i + 1) begin
            if (i < location + mask_width / 8 && i >= location) begin
                wdata_mask[i] = 1;
            end else begin
                wdata_mask[i] = 0;
            end
        end
        for (integer i = 0; i < 64; i = i + 1) begin
            if (i < location * 8) begin
                wdata_data[i] = 0;
            end else begin
                wdata_data[i] = read_data_2[i - location * 8];
            end
        end
    end

    // Part DMEM
    logic [63:0] read_data;
    always_comb begin
        // read_data       = 0;
        dmem_ift.r_request_bits.raddr = alu_res;
        if (re_mem)begin
            dmem_ift.r_request_valid = 1;
            dmem_ift.r_reply_ready = 1;
        end else begin
            dmem_ift.r_request_valid = 0;
            dmem_ift.r_reply_ready = 0;
        end
        read_data = dmem_ift.r_reply_bits.rdata;
        dmem_ift.w_request_bits.waddr = alu_res;
        dmem_ift.w_request_bits.wdata = wdata_data;
        dmem_ift.w_request_bits.wmask = wdata_mask;
        if (we_mem)begin
            dmem_ift.w_request_valid = 1;
            dmem_ift.w_reply_ready = 1;
        end else begin
            dmem_ift.w_request_valid = 0;
            dmem_ift.w_reply_ready = 0;
        end
    end

    // Part Data Truncation
    logic [63:0] trunc_data;
    always_comb begin
        for (integer i = 0; i < 64; i = i + 1)begin
            if(i >= mask_width)begin
                case(mem_op)
                    MEM_UW: trunc_data[i] = 0;
                    MEM_UH: trunc_data[i] = 0;
                    MEM_UB: trunc_data[i] = 0;
                    default: trunc_data[i] = read_data[location * 8 + mask_width - 1];      // signed extension
                endcase
            end else begin
                trunc_data[i] = read_data[location * 8 + i];
            end
        end
    end


    // Part WB
    always_comb begin
        case(wb_sel)
            WB_SEL0: wb_val = 64'b0;
            WB_SEL_ALU: wb_val = alu_res;
            WB_SEL_MEM: wb_val = trunc_data;
            WB_SEL_PC: wb_val = pc + 4;
        endcase
    end

    // Part Controller
    controller ctrl(.inst(inst),
                    .we_reg(we_reg),
                    .we_mem(we_mem),
                    .re_mem(re_mem),
                    .is_b(),
                    .is_j(),
                    .npc_sel(npc_sel),
                    .immgen_op(immgen_op),
                    .alu_op(alu_op),
                    .cmp_op(cmp_op),
                    .alu_asel(alu_asel),
                    .alu_bsel(alu_bsel),
                    .wb_sel(wb_sel),
                    .mem_op(mem_op),
                    .memdata_width(memdata_width)
    );



    assign cosim_valid = 1'b1;
    assign cosim_core_info.pc        = pc;
    assign cosim_core_info.inst      = {32'b0,inst};   
    assign cosim_core_info.rs1_id    = {59'b0, rs1};
    assign cosim_core_info.rs1_data  = read_data_1;
    assign cosim_core_info.rs2_id    = {59'b0, rs2};
    assign cosim_core_info.rs2_data  = read_data_2;
    assign cosim_core_info.alu       = alu_res;
    assign cosim_core_info.mem_addr  = dmem_ift.r_request_bits.raddr;
    assign cosim_core_info.mem_we    = {63'b0, dmem_ift.w_request_valid};
    assign cosim_core_info.mem_wdata = dmem_ift.w_request_bits.wdata;
    assign cosim_core_info.mem_rdata = dmem_ift.r_reply_bits.rdata;
    assign cosim_core_info.rd_we     = {63'b0, we_reg};
    assign cosim_core_info.rd_id     = {59'b0, rd}; 
    assign cosim_core_info.rd_data   = wb_val;
    assign cosim_core_info.br_taken  = {63'b0, npc_sel};
    assign cosim_core_info.npc       = next_pc;

endmodule

module MultiFSM(
    input clk,
    input rst,
    Mem_ift.Master imem_ift,
    Mem_ift.Master dmem_ift,
    input we_mem,
    input re_mem,
    input CorePack::addr_t pc,
    input CorePack::addr_t alu_res,
    input CorePack::data_t data_package,
    input CorePack::mask_t mask_package,
    output stall
);
    import CorePack::*;

    // fill your code for bonus

endmodule