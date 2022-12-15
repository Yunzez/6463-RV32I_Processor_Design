`timescale 1ns / 1ps

module data(
    input wire          clk,
    input wire [31:0]   addr,
    input wire [2:0]    func3,   
    input wire          we_en,
    input wire          re,
    input wire [31:0]   dmem_in,
    input wire [15:0]   board_switches,
    output wire [15:0]   board_LEDs,
    output wire [31:0]   dmem_out
    );
    
    reg     [31:0]  dmem [1023:0];
//    reg     [31:0]  rom  [0:7];
    wire    [9:0]   dmem_addr;
    wire    [31:0]  dmem_out_tmp;
    wire    [31:0]  dmem_tmp;
    reg     [31:0]  data_out;

    reg [15:0] switch_values;
    
    //initialize data memory, set all 1024 memory to zero 
    initial begin
        $readmemh("initialize.txt",dmem);
    end

    (*rom_style = "block" *) reg [32:0] rom_data;
    always @(posedge clk) begin
        if(re)
            case(addr[3:2])
                //load N number
                2'b00: rom_data <=32'd13000639;
                2'b01: rom_data <=32'd10923038;
                2'b10: rom_data <=32'd19039807;        
                2'b11: rom_data <=32'd00000000;
            endcase
    end
                     
    reg [15:0] LED_temp = 16'hF000;
    // testing 
    reg [2:0] checkAddr;
    // testing end
   (*rom_style = "block" *) reg [31:0] board; 
    always @(posedge clk) begin
        checkAddr = addr[4:2];
            case(addr[4:2])
                3'b100: if(re) begin board <= {16'b0, board_switches}; end // switches
                3'b101: 
                    if(re) begin board <=  dmem[addr[11:2]]; end // leds
            endcase
    end
    
    //store decode
    reg [7:0] dmem_in_0_temp;
    reg [7:0] dmem_in_1_temp;
    reg [7:0] dmem_in_2_temp;
    reg [7:0] dmem_in_3_temp;
    assign dmem_addr = addr[11:2]; // 000000001101 will be 0000000011
    
    always @(posedge clk) begin
        case(func3)
            3'b000:
            begin// load byte
                dmem_in_0_temp = dmem_in[7:0];
                dmem_in_1_temp = dmem[dmem_addr][15:8];
                dmem_in_2_temp = dmem[dmem_addr][23:16];
                dmem_in_3_temp = dmem[dmem_addr][31:24];
            end
            
            3'b100: 
            begin// load byte
                dmem_in_0_temp = dmem_in[7:0];
                dmem_in_1_temp = dmem[dmem_addr][15:8];
                dmem_in_2_temp = dmem[dmem_addr][23:16];
                dmem_in_3_temp = dmem[dmem_addr][31:24];
            end
            
            3'b001 || 3'b101: // load half, 2 bytes
            begin 
                dmem_in_0_temp = dmem_in[7:0];
                dmem_in_1_temp = dmem_in[15:8];
                dmem_in_2_temp = dmem[dmem_addr][23:16];
                dmem_in_3_temp = dmem[dmem_addr][31:24];
            end
            
            3'b010: // load word, 4 byte
            begin
                dmem_in_0_temp = dmem_in[7:0];
                dmem_in_1_temp = dmem_in[15:8];
                dmem_in_2_temp = dmem_in[23:16];
                dmem_in_3_temp = dmem_in[31:24];
            end
        endcase 
    end
//    assign dmem_in_0 = we[0] ? dmem_in[7:0] : dmem[dmem_addr][7:0];
//    assign dmem_in_1 = we[1] ? dmem_in[15:8] : dmem[dmem_addr][15:8];
//    assign dmem_in_2 = we[2] ? dmem_in[23:16] : dmem[dmem_addr][23:16];
//    assign dmem_in_3 = we[3] ? dmem_in[31:24] : dmem[dmem_addr][31:24];
    assign dmem_tmp  = {dmem_in_3_temp,dmem_in_2_temp,dmem_in_1_temp,dmem_in_0_temp};

    
    
    //data memory 
    always@(posedge clk) begin
        if(we_en) begin
            if (addr[4:2] == 3'b101) begin 
                dmem[dmem_addr] <=  dmem_in; 
                LED_temp <= dmem_in;
            end
            dmem[dmem_addr]    <= dmem_tmp;
        end
    end

    always@(posedge clk) begin
        if(re) begin 
            data_out <= dmem[dmem_addr];
        end
    end
    assign board_LEDs = LED_temp;
    assign dmem_out = addr[31]? data_out
                    : addr[20]? (addr[4]? board : rom_data)
                    : 'hz;
endmodule
