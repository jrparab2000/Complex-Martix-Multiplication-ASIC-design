
`include "defines.vh"
//---------------------------------------------------------------------------
// DUT 
//---------------------------------------------------------------------------
module MyDesign(
//---------------------------------------------------------------------------
//System signals
  input wire reset_n                      ,  
  input wire clk                          ,

//---------------------------------------------------------------------------
//Control signals
  input wire dut_valid                    , 
  output wire dut_ready                   ,

//---------------------------------------------------------------------------
//q_state_input SRAM interface
  output wire                                               q_state_input_sram_write_enable  ,
  output wire [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_input_sram_write_address ,
  output wire [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_input_sram_write_data    ,
  output wire [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_input_sram_read_address  , 
  input  wire [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_input_sram_read_data     ,

//---------------------------------------------------------------------------
//q_state_output SRAM interface
  output wire                                                q_state_output_sram_write_enable  ,
  output wire [`Q_STATE_OUTPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_write_address ,
  output wire [`Q_STATE_OUTPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_output_sram_write_data    ,
  output wire [`Q_STATE_OUTPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_read_address  , 
  input  wire [`Q_STATE_OUTPUT_SRAM_DATA_UPPER_BOUND-1:0]    q_state_output_sram_read_data     ,

//---------------------------------------------------------------------------
//scratchpad SRAM interface                                                       
  output wire                                                scratchpad_sram_write_enable        ,
  output wire [`SCRATCHPAD_SRAM_ADDRESS_UPPER_BOUND-1:0]     scratchpad_sram_write_address       ,
  output wire [`SCRATCHPAD_SRAM_DATA_UPPER_BOUND-1:0]        scratchpad_sram_write_data          ,
  output wire [`SCRATCHPAD_SRAM_ADDRESS_UPPER_BOUND-1:0]     scratchpad_sram_read_address        , 
  input  wire [`SCRATCHPAD_SRAM_DATA_UPPER_BOUND-1:0]        scratchpad_sram_read_data           ,

//---------------------------------------------------------------------------
//q_gates SRAM interface                                                       
  output wire                                                q_gates_sram_write_enable           ,
  output wire [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]        q_gates_sram_write_address          ,
  output wire [`Q_GATES_SRAM_DATA_UPPER_BOUND-1:0]           q_gates_sram_write_data             ,
  output wire [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]        q_gates_sram_read_address           ,  
  input  wire [`Q_GATES_SRAM_DATA_UPPER_BOUND-1:0]           q_gates_sram_read_data              
);

  localparam inst_sig_width = 52;
  localparam inst_exp_width = 11;
  localparam inst_ieee_compliance = 1;

  /*reg  [inst_sig_width+inst_exp_width : 0] inst_a_1;
  reg  [inst_sig_width+inst_exp_width : 0] inst_b_1;
  reg  [inst_sig_width+inst_exp_width : 0] inst_c_1;
  reg  [inst_sig_width+inst_exp_width : 0] inst_a_2;
  reg  [inst_sig_width+inst_exp_width : 0] inst_b_2;
  reg  [inst_sig_width+inst_exp_width : 0] inst_c_2;*/
  reg  [2 : 0] inst_rnd;
 // wire [inst_sig_width+inst_exp_width : 0] z_inst_1;
  //wire [inst_sig_width+inst_exp_width : 0] z_inst_2;
  wire [7 : 0] status_inst_11;
  wire [7 : 0] status_inst_12;
  wire [7 : 0] status_inst_21;
  wire [7 : 0] status_inst_22;
  wire [7 : 0] status_inst_31;
  wire [7 : 0] status_inst_32;
  wire [7 : 0] status_inst_41;
  wire [7 : 0] status_inst_42;
  wire [7 : 0] status_inst_add_1;
  wire [7 : 0] status_inst_add_2;
  wire [7 : 0] status_inst_sub_1;
  wire [7 : 0] status_inst_sub_2;

  reg Real_R_control;
  reg Imaginary_I_control;
  reg Real_R_control_S;
  reg Imaginary_I_control_S;
  reg [1:0] load_MN;
  reg [1 : 0] load_M;
  reg [1 : 0] load_2_Q;
  reg [1 : 0] Q_gates_control;
  reg [1 : 0] Q_input_control;
  reg [1 : 0] Counter_control;
  reg [1 : 0] Counter_M_control;
  reg [1 : 0] SW_control;
  reg [2 : 0] SW_Control_R;
  reg [1 : 0] Output_Control;
  reg [1 : 0] Output_Count_Control;
  reg Dut_ready_Control;
  reg q_gates_sram_write_enable_control;
  reg scratchpad_sram_write_enable_control;
  reg q_state_output_sram_write_enable_control;
  reg q_state_input_sram_write_enable_control;

  reg [`Q_STATE_INPUT_SRAM_DATA_UPPER_BOUND-1:0] value_MN;
  reg [inst_sig_width+inst_exp_width : 0] value_M;
  reg [inst_sig_width+inst_exp_width : 0] value_2_Q;
  reg [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]Counter;
  reg [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]Counter_M;

  reg [inst_sig_width+inst_exp_width : 0] R_1;
  reg [inst_sig_width+inst_exp_width : 0] R_2;
  wire [inst_sig_width+inst_exp_width : 0] R_mux_1;
  wire [inst_sig_width+inst_exp_width : 0] R_mux_2;
  wire [inst_sig_width+inst_exp_width : 0] Real;

  reg [inst_sig_width+inst_exp_width : 0] I_1;
  reg [inst_sig_width+inst_exp_width : 0] I_2;
  wire [inst_sig_width+inst_exp_width : 0] I_mux_1;
  wire [inst_sig_width+inst_exp_width : 0] I_mux_2;
  wire [inst_sig_width+inst_exp_width : 0] Imaginary;

  reg [inst_sig_width+inst_exp_width : 0] R_1_s;
  reg [inst_sig_width+inst_exp_width : 0] R_2_s;
  wire [inst_sig_width+inst_exp_width : 0] R_mux_1_s;
  wire [inst_sig_width+inst_exp_width : 0] R_mux_2_s;
  wire [inst_sig_width+inst_exp_width : 0] Real_s;

  reg [inst_sig_width+inst_exp_width : 0] I_1_s;
  reg [inst_sig_width+inst_exp_width : 0] I_2_s;
  wire [inst_sig_width+inst_exp_width : 0] I_mux_1_s;
  wire [inst_sig_width+inst_exp_width : 0] I_mux_2_s;
  wire [inst_sig_width+inst_exp_width : 0] Imaginary_s;

  reg [`SCRATCHPAD_SRAM_ADDRESS_UPPER_BOUND-1:0]     scratchpad_sram_write_address_reg;
  reg [`SCRATCHPAD_SRAM_ADDRESS_UPPER_BOUND-1:0]     scratchpad_sram_read_address_reg;
  reg [`SCRATCHPAD_SRAM_DATA_UPPER_BOUND-1:0] scratchpad_sram_write_data_reg;

  reg [`Q_STATE_OUTPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_output_sram_write_address_reg;
  reg [`Q_STATE_OUTPUT_SRAM_DATA_UPPER_BOUND-1:0] Q_State_Output_data_reg;

  reg [`Q_STATE_INPUT_SRAM_ADDRESS_UPPER_BOUND-1:0] q_state_input_sram_read_address_reg;

  reg [`Q_GATES_SRAM_ADDRESS_UPPER_BOUND-1:0]        q_gates_sram_read_address_reg;

  reg [`Q_STATE_OUTPUT_SRAM_DATA_UPPER_BOUND-1:0] Output_Count;

  reg [3:0] Next_State, Current_State;
/*
  real fraction_Real_final;
  real  fraction_Imaginary_final;
  real  fraction_Real_1;
  real  fraction_Imaginary_1;
  real  fraction_Real_2;
  real fraction_Imaginary_2;
  real Input_data_R;
  real Input_data_I;
  real Gate_data_R;
  real Gate_data_I;
  real scratchpad_data_R;
  real scratchpad_data_I;
  real Sfraction_Real_final;
  real  Sfraction_Imaginary_final;
  real  Sfraction_Real_1;
  real  Sfraction_Imaginary_1;
  real  Sfraction_Real_2;
  real Sfraction_Imaginary_2;
*/
  always @(*)
  begin
    inst_rnd = 3'b000;
  end
/*
  always @(*)
  begin
    assign fraction_Real_1 = $bitstoreal(R_1);
    assign fraction_Imaginary_1 = $bitstoreal(I_1);
    assign fraction_Real_2 = $bitstoreal(R_2);
    assign fraction_Imaginary_2 = $bitstoreal(I_2);
    assign fraction_Real_final = $bitstoreal(Real);
    assign fraction_Imaginary_final = $bitstoreal(Imaginary);
    assign Input_data_R = $bitstoreal(q_state_input_sram_read_data[127:64]);
    assign Input_data_I = $bitstoreal(q_state_input_sram_read_data[63:0]);
    assign Gate_data_R = $bitstoreal(q_gates_sram_read_data[127:64]);
    assign Gate_data_I = $bitstoreal(q_gates_sram_read_data[63:0]);
    assign scratchpad_data_R = $bitstoreal(scratchpad_sram_read_data[127:64]);
    assign scratchpad_data_I = $bitstoreal(scratchpad_sram_read_data[63:0]);
    assign Sfraction_Real_final = $bitstoreal(Real_s);
    assign  Sfraction_Imaginary_final = $bitstoreal(Imaginary_s);
    assign  Sfraction_Real_1 = $bitstoreal(R_1_s);
    assign  Sfraction_Imaginary_1 = $bitstoreal(I_1_s);
    assign  Sfraction_Real_2 = $bitstoreal(R_2_s);
    assign Sfraction_Imaginary_2 = $bitstoreal(I_2_s);
  end
*/
  parameter s0 = 4'b0000,
  s1 = 4'b0001,
  s2 = 4'b0010,
  s3 = 4'b0011,
  s4 = 4'b0100,
  s5 = 4'b0101,
  s6 = 4'b0110,
  s7 = 4'b0111,
  s8 = 4'b1000,
  s9 = 4'b1001,
  s10 = 4'b1010,
  s11 = 4'b1011,
  s12 = 4'b1100,
  s13 = 4'b1101,
  s14 = 4'b1110,
  s15 = 4'b1111;

  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
      Current_State = s0;
    else
      Current_State = Next_State;
  end

  always @(*)
  begin
    case (Current_State)
    s0: 
    begin
      load_MN = 0;
      load_2_Q = 0;
      load_M = 0;
      Counter_control = 0;
      Counter_M_control = 0;
      Q_gates_control = 0;
      Q_input_control = 0;
      SW_Control_R = 0;
      SW_control = 0;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 1;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      if (dut_valid == 1)
        Next_State = s1;
      else
        Next_State = s0;
    end
    s1:
    begin
      load_MN = 1;
      load_2_Q = 0;
      load_M = 0;
      Counter_control = 0;
      Counter_M_control = 2;
      Q_gates_control = 0;
      Q_input_control = 0;
      SW_Control_R = 0;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s2;
    end
    s2:
    begin
      load_MN = 3;
      load_2_Q = 1;
      load_M = 1;
      Counter_control = 0;
      Counter_M_control = 2;
      Q_gates_control = 0;
      Q_input_control = 3;
      SW_Control_R = 0;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s3;
    end
    s3:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 1;
      Counter_M_control = 2;
      Q_gates_control = 1;
      Q_input_control = 3;
      SW_Control_R = 0;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      if (value_2_Q == 2)
        Next_State = s5;
      else
        Next_State = s4;
    end
    s4:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 1;
      Counter_M_control = 2;
      Q_gates_control = 1;
      Q_input_control = 3;
      SW_Control_R = 0;
      SW_control = 2;
      Real_R_control = 1;
      Imaginary_I_control = 1;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      if(value_2_Q == 2)
        Next_State = s5;
      else
        Next_State = s4;
    end
    s5:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 2;
      Counter_M_control = 2;
      Q_gates_control = 2;
      Q_input_control = 0;
      SW_Control_R = 0;
      SW_control = 2;
      Real_R_control = 1;
      Imaginary_I_control = 1;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s6;
    end
    s6:
    begin
      load_MN = 3;
      load_2_Q = 1;
      load_M = 3;
      Counter_control = 1;
      Counter_M_control = 2;
      Q_gates_control = 1;
      Q_input_control = 0;
      SW_Control_R = 0;
      SW_control = 2;
      Real_R_control = 1;
      Imaginary_I_control = 1;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      if(Counter == ((2**(value_MN[127 : 64]))*((2**(value_MN[127 : 64])))-1))
        Next_State = s8;
      else
        Next_State = s7;
    end
    s7:
    begin
      load_MN = 3;
      load_2_Q = 1;
      load_M = 3;
      Counter_control = 2;
      Counter_M_control = 2;
      Q_gates_control = 2;
      Q_input_control = 3;
      SW_Control_R = 0;
      SW_control = 1;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 1;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s3;
    end
    s8:
    begin
      load_MN = 3;
      load_2_Q = 1;
      load_M = 2;
      Counter_control = 0;
      Counter_M_control = 1;
      Q_gates_control = 2;
      Q_input_control = 3;
      SW_Control_R = 2;
      SW_control = 1;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 1;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s9;
    end
    s9:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 1;
      Counter_M_control = 2;
      Q_gates_control = 1;
      Q_input_control = 3;
      SW_Control_R = 1;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      if(value_M == 0)
        Next_State = s14;
      else if (value_2_Q == 2)
        Next_State = s11;
      else
        Next_State = s10;
    end
    s10:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 1;
      Counter_M_control = 2;
      Q_gates_control = 1;
      Q_input_control = 3;
      SW_Control_R = 1;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 1;
      Imaginary_I_control_S = 1;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      if(value_2_Q == 2)
        Next_State = s11;
      else
        Next_State = s10;
    end
    s11:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 1;
      Counter_M_control = 2;
      Q_gates_control = 2;
      Q_input_control = 3;
      SW_Control_R = 2;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 1;
      Imaginary_I_control_S = 1;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s12;
    end
    s12:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 3;
      Counter_control = 2;
      Counter_M_control = 2;
      Q_gates_control = 2;
      Q_input_control = 3;
      SW_Control_R = 3;
      SW_control = 2;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 1;
      Imaginary_I_control_S = 1;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      if(Counter == ((2**(value_MN[127:64]))*((2**(value_MN[127:64])))))
      begin
        Q_gates_control = 1;
        SW_Control_R = 4;
        Next_State = s8;
      end
      else
        Next_State = s13;
    end
    s13:
    begin
      load_MN = 3;
      load_2_Q = 1;
      load_M = 3;
      Counter_control = 2;
      Counter_M_control = 2;
      Q_gates_control = 1;
      Q_input_control = 3;
      SW_Control_R = 2;
      SW_control = 1;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 1;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s9;
    end
    s14:
    begin
      load_MN = 3;
      load_2_Q = 2;
      load_M = 2;
      Counter_control = 0;
      Counter_M_control = 2;
      Q_gates_control = 0;
      Q_input_control = 0;
      SW_Control_R = 1;
      SW_control = 0;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control =1;
      Output_Control = 1;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 1;
      if(Output_Count == 1)
        Next_State = s14;
      else
        Next_State = s15;
    end
    s15:
    begin
      load_MN = 3;
      load_2_Q = 3;
      load_M = 2;
      Counter_control = 0;
      Counter_M_control = 2;
      Q_gates_control = 0;
      Q_input_control = 0;
      SW_Control_R = 1;
      SW_control = 0;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 0;
      Output_Count_Control = 1;
      Output_Control = 1;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control = 0;
      q_state_output_sram_write_enable_control = 1;
      if(Output_Count == (2**(value_MN[127:64])))
        Next_State = s0;
      else
        Next_State = s15;
    end
    default:
    begin
      load_MN = 0;
      load_2_Q = 0;
      load_M = 0;
      Counter_control = 0;
      Counter_M_control = 0;
      Q_gates_control = 0;
      Q_input_control = 0;
      SW_Control_R = 0;
      SW_control = 0;
      Real_R_control = 0;
      Imaginary_I_control = 0;
      Real_R_control_S = 0;
      Imaginary_I_control_S = 0;
      Dut_ready_Control = 1;
      Output_Count_Control = 0;
      Output_Control = 0;
      q_gates_sram_write_enable_control = 0;
      scratchpad_sram_write_enable_control = 0;
      q_state_input_sram_write_enable_control =0;
      q_state_output_sram_write_enable_control = 0;
      Next_State = s0;
    end
    endcase
  end
  /*
  ===================================================
  Get the M and Q value form the SRAM and stores the 
  value till the end of program
  ===================================================
  */
  always @(posedge clk)
  begin
    if(load_MN == 2'b00)
    begin
      value_MN <= 0;
    end
    else if(load_MN == 2'b01)
    begin
      value_MN <= q_state_input_sram_read_data;
    end
    else if(load_MN == 2'b10)
    begin
      value_MN <= value_M - 1;
    end
  end
  /*
  ===================================================
  Get the M and stores the Value of M and uses it has
  a down counter
  ===================================================
  */
  always @(posedge clk)
  begin
    if(load_M == 2'b00)
    begin
      value_M <= 0;
    end
    else if(load_M == 2'b01)
    begin
      value_M <= value_MN[63:0];
    end
    else if(load_M == 2'b10)
    begin
      value_M <= value_M - 1;
    end
  end
  /*
  ===================================================
  Get the value of 2^Q and stores it and then decrement
  the value till zero
  ===================================================
  */
  always @(posedge clk)
  begin
    if(load_2_Q == 2'b00)
    begin
      value_2_Q <= 0;
    end
    else if(load_2_Q == 2'b01)
    begin
      value_2_Q <= 2**(value_MN[127:64]);
    end
    else if(load_2_Q == 2'b10)
    begin
      value_2_Q <= value_2_Q - 1;
    end
  end
/*
  ===================================================
  Up counter with increment of one to check if we complete
  one row
  ===================================================
  */
  always @(posedge clk)
  begin
    if(Counter_control == 2'b00)
    begin
      Counter <= 0;
    end
    else if(Counter_control == 2'b01)
    begin
      Counter <= Counter + 1;
    end
  end

  always @(posedge clk)
  begin
    if(Counter_M_control == 2'b00)
    begin
      Counter_M <= 0;
    end
    else if(Counter_M_control == 2'b01)
    begin
      Counter_M <= Counter_M + 1;
    end
  end
/*
  ===================================================
  outputs the read address of Q gates sram
  ===================================================
  */
  always @(posedge clk)
  begin
    if(Q_gates_control == 2'b00)
    begin
      q_gates_sram_read_address_reg <= 0;
    end
    else if(Q_gates_control == 2'b01)
    begin
      q_gates_sram_read_address_reg <= q_gates_sram_read_address_reg + 1;
    end
  end
/*
  ===================================================
  outputs the read address of the Q input sram 
  ===================================================
  */
  always @(posedge clk)
  begin
    if(Q_input_control == 2'b00)
    begin
      q_state_input_sram_read_address_reg <= 0;
    end
    else if(Q_input_control == 2'b11)
    begin
      q_state_input_sram_read_address_reg <= q_state_input_sram_read_address_reg + 1;
    end
  end

  /*
  ===================================================
  outputs the output SRAM write address
  ===================================================
  */
  always @(posedge clk)
  begin
    if(Output_Control == 2'b00)
    begin
      q_state_output_sram_write_address_reg <= 0;
    end
    else if(Output_Control == 2'b01)
    begin
      q_state_output_sram_write_address_reg <= q_state_output_sram_write_address_reg +1;
    end
  end
  /*
  ===================================================
  outputs the output SRAM write address
  ===================================================
  */
  always @(posedge clk)
  begin
    if(Output_Count_Control == 2'b00)
    begin
      Output_Count <= 0;
    end
    else if(Output_Count_Control == 2'b01)
    begin
      Output_Count <= Output_Count +1;
    end
  end
/*
  ===================================================
  This is the write address for the scrach pad
  ===================================================
  */
  always @(posedge clk)
  begin
    if(SW_control == 2'b00)
    begin
      scratchpad_sram_write_address_reg <= 0;
    end
    else if (SW_control == 2'b01)
    begin
      scratchpad_sram_write_address_reg <= scratchpad_sram_write_address_reg + 1;
    end
  end

/*
  ===================================================
  This is the read address for the scrach pad
  ===================================================
  */
  always @(posedge clk)
  begin
    if(SW_Control_R == 3'b000)
    begin
      scratchpad_sram_read_address_reg <= 0;
    end
    else if (SW_Control_R == 3'b001)
    begin
      scratchpad_sram_read_address_reg <= scratchpad_sram_read_address_reg + 1;
    end
    else if (SW_Control_R == 3'b011)
    begin
      scratchpad_sram_read_address_reg <= ((2**(value_MN[127:64]))*(Counter_M - 1));
    end
    else if (SW_Control_R == 3'b100)
    begin
      scratchpad_sram_read_address_reg <= ((2**(value_MN[127:64]))*(Counter_M));
    end
  end

/*
  ===================================================
  process of real multiplication using the MAC module
  ===================================================
  */
  always @(posedge clk) begin
    if (Real_R_control == 0) 
    begin
      R_1 <= 0;
      R_2 <= 0;
    end
    else
    begin
      R_1 <= R_mux_1;
      R_2 <= R_mux_2;
    end
  end
/*
  ===================================================
  process of imaginary multiplication using MAC module
  ===================================================
  */
  always @(posedge clk) begin
    if (Imaginary_I_control == 0) 
    begin
      I_1 <= 0;
      I_2 <= 0;
    end
    else
    begin
      I_1 <= I_mux_1;
      I_2 <= I_mux_2;
    end
  end
    
  always @(posedge clk) begin
    if (Real_R_control_S == 0) 
    begin
      R_1_s <= 0;
      R_2_s <= 0;
    end
    else
    begin
      R_1_s <= R_mux_1_s;
      R_2_s <= R_mux_2_s;
    end
  end
/*
  ===================================================
  process of imaginary multiplication using MAC module
  ===================================================
  */
  always @(posedge clk) begin
    if (Imaginary_I_control_S == 0) 
    begin
      I_1_s <= 0;
      I_2_s <= 0;
    end
    else
    begin
      I_1_s <= I_mux_1_s;
      I_2_s <= I_mux_2_s;
    end
  end

  assign q_gates_sram_read_address = q_gates_sram_read_address_reg;
  assign q_state_input_sram_read_address = q_state_input_sram_read_address_reg;
  assign q_state_output_sram_write_address = q_state_output_sram_write_address_reg;
  assign q_state_output_sram_write_data = Q_State_Output_data_reg;
  assign scratchpad_sram_read_address = scratchpad_sram_read_address_reg;
  assign scratchpad_sram_write_address = scratchpad_sram_write_address_reg;
  assign scratchpad_sram_write_enable = scratchpad_sram_write_enable_control;
  assign scratchpad_sram_write_data = scratchpad_sram_write_data_reg;
  assign q_state_output_sram_write_enable = q_state_output_sram_write_enable_control;
  assign q_state_input_sram_write_enable = q_state_input_sram_write_enable_control;
  assign q_gates_sram_write_enable = q_gates_sram_write_enable_control;
  assign q_gates_sram_write_data = 0;
  assign q_state_input_sram_write_data = 0;
  assign q_gates_sram_write_address = 0;
  assign q_state_input_sram_write_address = 0;
  assign dut_ready = Dut_ready_Control;

  always @(*)
  begin
    if(value_M < value_MN[63:0])
      scratchpad_sram_write_data_reg = {Real_s,Imaginary_s};
    else
      scratchpad_sram_write_data_reg = {Real,Imaginary};
    if(Output_Count_Control == 1)
      Q_State_Output_data_reg = scratchpad_sram_read_data;
    else
      Q_State_Output_data_reg = scratchpad_sram_read_data;
  end

  DW_fp_mac_inst FP_MAC1 ( 
    q_state_input_sram_read_data[127 : 64],
    q_gates_sram_read_data[127 : 64],
    R_1,
    q_state_input_sram_read_data[63 : 0],
    q_gates_sram_read_data[63 : 0],
    R_2,
    3'b000,
    R_mux_1,
    R_mux_2,
    status_inst_11,
    status_inst_12
  );

DW_fp_mac_inst FP_MAC2 ( 
    q_state_input_sram_read_data[127 : 64],
    q_gates_sram_read_data[63 : 0],
    I_1,
    q_state_input_sram_read_data[63 : 0],
    q_gates_sram_read_data[127 : 64],
    I_2,
    3'b000,
    I_mux_1,
    I_mux_2,
    status_inst_21,
    status_inst_22
  );

DW_fp_mac_inst FP_MAC3 ( 
    scratchpad_sram_read_data[127 : 64],
    q_gates_sram_read_data[127 : 64],
    R_1_s,
    scratchpad_sram_read_data[63 : 0],
    q_gates_sram_read_data[63 : 0],
    R_2_s,
    3'b000,
    R_mux_1_s,
    R_mux_2_s,
    status_inst_31,
    status_inst_32
  );

DW_fp_mac_inst FP_MAC4 ( 
    scratchpad_sram_read_data[127 : 64],
    q_gates_sram_read_data[63 : 0],
    I_1_s,
    scratchpad_sram_read_data[63 : 0],
    q_gates_sram_read_data[127 : 64],
    I_2_s,
    3'b000,
    I_mux_1_s,
    I_mux_2_s,
    status_inst_41,
    status_inst_42
  );

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U1 (
  .a(I_1),
  .b(I_2),
  .z(Imaginary),
  .rnd(3'b000),
  .status(status_inst_add_1)
);

DW_fp_sub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U2 (
  .a(R_1),
  .b(R_2),
  .z(Real),
  .rnd(3'b000),
  .status(status_inst_sub_1)
);

DW_fp_add #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U3 (
  .a(I_1_s),
  .b(I_2_s),
  .z(Imaginary_s),
  .rnd(3'b000),
  .status(status_inst_add_2)
);

DW_fp_sub #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U4 (
  .a(R_1_s),
  .b(R_2_s),
  .z(Real_s),
  .rnd(3'b000),
  .status(status_inst_sub_2)
);
endmodule


module DW_fp_mac_inst #(
  parameter inst_sig_width = 52,
  parameter inst_exp_width = 11,
  parameter inst_ieee_compliance = 1 // These need to be fixed to decrease error
) ( 
  input wire [inst_sig_width+inst_exp_width : 0] inst_a_1,
  input wire [inst_sig_width+inst_exp_width : 0] inst_b_1,
  input wire [inst_sig_width+inst_exp_width : 0] inst_c_1,
  input wire [inst_sig_width+inst_exp_width : 0] inst_a_2,
  input wire [inst_sig_width+inst_exp_width : 0] inst_b_2,
  input wire [inst_sig_width+inst_exp_width : 0] inst_c_2,
  input [2 : 0] inst_rnd,
  output wire [inst_sig_width+inst_exp_width : 0] z_inst_1,
  output wire [inst_sig_width+inst_exp_width : 0] z_inst_2,
  output wire [7 : 0] status_inst_1,
  output wire [7 : 0] status_inst_2
);

  // Instance of DW_fp_mac
  DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U1 (
    .a(inst_a_1),
    .b(inst_b_1),
    .c(inst_c_1),
    .rnd(3'b000),
    .z(z_inst_1),
    .status(status_inst_1) 
  );

  DW_fp_mac #(inst_sig_width, inst_exp_width, inst_ieee_compliance) U2 (
    .a(inst_a_2),
    .b(inst_b_2),
    .c(inst_c_2),
    .rnd(3'b000),
    .z(z_inst_2),
    .status(status_inst_2) 
  );

endmodule

