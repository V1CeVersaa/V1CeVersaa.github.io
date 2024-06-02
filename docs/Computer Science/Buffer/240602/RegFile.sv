`include "core_struct.vh"
module RegFile (
  input clk,
  input rst,
  input we,
  input CorePack::reg_ind_t  read_addr_1,
  input CorePack::reg_ind_t  read_addr_2,
  input CorePack::reg_ind_t  write_addr,
  input  CorePack::data_t write_data,
  output CorePack::data_t read_data_1,
  output CorePack::data_t read_data_2
);
  import CorePack::*;

  integer i;
  data_t register [1:31]; // x1 - x31, x0 keeps zero
  
  // fill your code
  data_t reg_0;
  assign reg_0 = 0;
  always_ff @(posedge clk) begin
    if (rst) begin
      for (i = 1; i <= 31; i = i + 1) begin
        register[i] <= 0;
      end
    end else begin
      if (we) begin
        register[write_addr] <= write_data;
      end
    end
  end
  always_comb begin
    read_data_1 = (read_addr_1 == 0) ? reg_0 : register[read_addr_1];
    read_data_2 = (read_addr_2 == 0) ? reg_0 : register[read_addr_2];
  end
endmodule

/*
  typedef logic [ADDR_WIDTH-1:0] addr_t;
  typedef logic [DATA_WIDTH-1:0] data_t;
  typedef logic [MASK_WIDTH-1:0] mask_t;
  typedef logic [31:0] inst_t;
  typedef logic [4:0] reg_ind_t;
*/