// (C) 1992-2011 Altera Corporation. All rights reserved.                         
// Your use of Altera Corporation's design tools, logic functions and other       
// software and tools, and its AMPP partner logic functions, and any output       
// files any of the foregoing (including device programming or simulation         
// files), and any associated documentation or information are expressly subject  
// to the terms and conditions of the Altera Program License Subscription         
// Agreement, Altera MegaCore Function License Agreement, or other applicable     
// license agreement, including, without limitation, that your use is for the     
// sole purpose of programming logic devices manufactured by Altera and sold by   
// Altera or its authorized distributors.  Please refer to the applicable         
// agreement for further details.                                                 
//
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module copyElement_basic_block_0
	(
		input 		clock,
		input 		resetn,
		input 		start,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		input [31:0] 		input_local_id_3,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_input_global_id_0,
		output [31:0] 		lvb_input_local_id_3,
		input [31:0] 		copyElement_live_thread_count,
		input [31:0] 		workgroup_size
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] _num_entry;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] _num_exit;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry - _num_exit);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry <= 32'h0;
		_num_exit <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry <= (_num_entry + 2'h1);
		end
		if (_exit)
		begin
			_num_exit <= (_num_exit + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_node_valid_out;
wire merge_stalled_by_successors;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_block_selector;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_node_valid_in_staging_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] input_global_id_0_staging_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] input_local_id_3_staging_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] local_lvm_input_global_id_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] local_lvm_input_local_id_3;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg is_merge_data_to_local_regs_valid;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg invariant_valid;

assign merge_stalled_by_successors = (|(merge_node_stall_in & merge_node_valid_out));
assign stall_out = merge_node_valid_in_staging_reg;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg | valid_in))
	begin
		merge_block_selector = 1'b0;
		is_merge_data_to_local_regs_valid = 1'b1;
	end
	else
	begin
		merge_block_selector = 1'b0;
		is_merge_data_to_local_regs_valid = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg <= 'x;
		input_local_id_3_staging_reg <= 'x;
		merge_node_valid_in_staging_reg <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg))
			begin
				input_global_id_0_staging_reg <= input_global_id_0;
				input_local_id_3_staging_reg <= input_local_id_3;
				merge_node_valid_in_staging_reg <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg)
				begin
					local_lvm_input_global_id_0 <= input_global_id_0_staging_reg;
					local_lvm_input_local_id_3 <= input_local_id_3_staging_reg;
				end
				else
				begin
					local_lvm_input_global_id_0 <= input_global_id_0;
					local_lvm_input_local_id_3 <= input_local_id_3;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out <= is_merge_data_to_local_regs_valid;
		end
		else
		begin
			if (~(merge_node_stall_in))
			begin
				merge_node_valid_out <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid <= 1'b0;
	end
	else
	begin
		invariant_valid <= (~(start) & (invariant_valid | is_merge_data_to_local_regs_valid));
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg branch_node_valid_out;
wire branch_var__output_regs_ready;
wire combined_branch_stall_in_signal;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] lvb_input_global_id_0_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] lvb_input_local_id_3_reg;

assign branch_var__inputs_ready = merge_node_valid_out;
assign branch_var__output_regs_ready = (~(stall_in) | ~(branch_node_valid_out));
assign merge_node_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign lvb_input_global_id_0 = lvb_input_global_id_0_reg;
assign lvb_input_local_id_3 = lvb_input_local_id_3_reg;
assign valid_out = branch_node_valid_out;
assign combined_branch_stall_in_signal = stall_in;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		branch_node_valid_out <= 1'b0;
		lvb_input_global_id_0_reg <= 'x;
		lvb_input_local_id_3_reg <= 'x;
	end
	else
	begin
		if (branch_var__output_regs_ready)
		begin
			branch_node_valid_out <= branch_var__inputs_ready;
			lvb_input_global_id_0_reg <= local_lvm_input_global_id_0;
			lvb_input_local_id_3_reg <= local_lvm_input_local_id_3;
		end
		else
		begin
			if (~(combined_branch_stall_in_signal))
			begin
				branch_node_valid_out <= 1'b0;
			end
		end
	end
end


endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module copyElement_basic_block_1
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		input_src,
		input [31:0] 		input_global_size_0,
		input [31:0] 		input_dst,
		input 		valid_in,
		output 		stall_out,
		input [31:0] 		input_global_id_0,
		input [31:0] 		input_local_id_3,
		output 		valid_out,
		input 		stall_in,
		output [31:0] 		lvb_input_local_id_3,
		input [31:0] 		copyElement_live_thread_count,
		input [31:0] 		workgroup_size,
		input 		start,
		input [511:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [31:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [511:0] 		avm_local_bb1_ld__writedata,
		output [63:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		output 		local_bb1_ld__active,
		input 		clock2x,
		input [511:0] 		avm_local_bb1_st__readdata,
		input 		avm_local_bb1_st__readdatavalid,
		input 		avm_local_bb1_st__waitrequest,
		output [31:0] 		avm_local_bb1_st__address,
		output 		avm_local_bb1_st__read,
		output 		avm_local_bb1_st__write,
		input 		avm_local_bb1_st__writeack,
		output [511:0] 		avm_local_bb1_st__writedata,
		output [63:0] 		avm_local_bb1_st__byteenable,
		output [4:0] 		avm_local_bb1_st__burstcount,
		output 		local_bb1_st__active
	);


// Values used for debugging.  These are swept away by synthesis.
wire _entry;
wire _exit;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] _num_entry;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] _num_exit;
wire [31:0] _num_live;

assign _entry = ((&valid_in) & ~((|stall_out)));
assign _exit = ((&valid_out) & ~((|stall_in)));
assign _num_live = (_num_entry - _num_exit);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		_num_entry <= 32'h0;
		_num_exit <= 32'h0;
	end
	else
	begin
		if (_entry)
		begin
			_num_entry <= (_num_entry + 2'h1);
		end
		if (_exit)
		begin
			_num_exit <= (_num_exit + 2'h1);
		end
	end
end



// This section defines the behaviour of the MERGE node
wire merge_node_stall_in_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_node_valid_out_0;
wire merge_node_stall_in_1;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_node_valid_out_1;
wire merge_stalled_by_successors;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_block_selector;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg merge_node_valid_in_staging_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] input_global_id_0_staging_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] input_local_id_3_staging_reg;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] local_lvm_input_global_id_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] local_lvm_input_local_id_3;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg is_merge_data_to_local_regs_valid;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg invariant_valid;

assign merge_stalled_by_successors = ((merge_node_stall_in_0 & merge_node_valid_out_0) | (merge_node_stall_in_1 & merge_node_valid_out_1));
assign stall_out = merge_node_valid_in_staging_reg;

always @(*)
begin
	if ((merge_node_valid_in_staging_reg | valid_in))
	begin
		merge_block_selector = 1'b0;
		is_merge_data_to_local_regs_valid = 1'b1;
	end
	else
	begin
		merge_block_selector = 1'b0;
		is_merge_data_to_local_regs_valid = 1'b0;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		input_global_id_0_staging_reg <= 'x;
		input_local_id_3_staging_reg <= 'x;
		merge_node_valid_in_staging_reg <= 1'b0;
	end
	else
	begin
		if (((merge_block_selector != 1'b0) | merge_stalled_by_successors))
		begin
			if (~(merge_node_valid_in_staging_reg))
			begin
				input_global_id_0_staging_reg <= input_global_id_0;
				input_local_id_3_staging_reg <= input_local_id_3;
				merge_node_valid_in_staging_reg <= valid_in;
			end
		end
		else
		begin
			merge_node_valid_in_staging_reg <= 1'b0;
		end
	end
end

always @(posedge clock)
begin
	if (~(merge_stalled_by_successors))
	begin
		case (merge_block_selector)
			1'b0:
			begin
				if (merge_node_valid_in_staging_reg)
				begin
					local_lvm_input_global_id_0 <= input_global_id_0_staging_reg;
					local_lvm_input_local_id_3 <= input_local_id_3_staging_reg;
				end
				else
				begin
					local_lvm_input_global_id_0 <= input_global_id_0;
					local_lvm_input_local_id_3 <= input_local_id_3;
				end
			end

			default:
			begin
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		merge_node_valid_out_0 <= 1'b0;
		merge_node_valid_out_1 <= 1'b0;
	end
	else
	begin
		if (~(merge_stalled_by_successors))
		begin
			merge_node_valid_out_0 <= is_merge_data_to_local_regs_valid;
			merge_node_valid_out_1 <= is_merge_data_to_local_regs_valid;
		end
		else
		begin
			if (~(merge_node_stall_in_0))
			begin
				merge_node_valid_out_0 <= 1'b0;
			end
			if (~(merge_node_stall_in_1))
			begin
				merge_node_valid_out_1 <= 1'b0;
			end
		end
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		invariant_valid <= 1'b0;
	end
	else
	begin
		invariant_valid <= (~(start) & (invariant_valid | is_merge_data_to_local_regs_valid));
	end
end


// This section implements an unregistered operation.
// 
wire local_bb1_result_i_stall_local;
wire [63:0] local_bb1_result_i;

assign local_bb1_result_i[63:32] = 32'h0;
assign local_bb1_result_i[31:0] = local_lvm_input_global_id_0;

// Register node:
//  * latency = 5
//  * capacity = 5
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to6_input_local_id_3_0_valid_out;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to6_input_local_id_3_0_stall_in;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [31:0] rnode_1to6_input_local_id_3_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to6_input_local_id_3_0_reg_6_inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [31:0] rnode_1to6_input_local_id_3_0_reg_6;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to6_input_local_id_3_0_valid_out_reg_6;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to6_input_local_id_3_0_stall_in_reg_6;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to6_input_local_id_3_0_stall_out_reg_6;

acl_data_fifo rnode_1to6_input_local_id_3_0_reg_6_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to6_input_local_id_3_0_reg_6_inputs_ready),
	.stall_in(rnode_1to6_input_local_id_3_0_stall_in_reg_6),
	.valid_out(rnode_1to6_input_local_id_3_0_valid_out_reg_6),
	.stall_out(rnode_1to6_input_local_id_3_0_stall_out_reg_6),
	.data_in(local_lvm_input_local_id_3),
	.data_out(rnode_1to6_input_local_id_3_0_reg_6)
);

defparam rnode_1to6_input_local_id_3_0_reg_6_fifo.DEPTH = 6;
defparam rnode_1to6_input_local_id_3_0_reg_6_fifo.DATA_WIDTH = 32;
defparam rnode_1to6_input_local_id_3_0_reg_6_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to6_input_local_id_3_0_reg_6_fifo.IMPL = "ll_reg";

assign rnode_1to6_input_local_id_3_0_reg_6_inputs_ready = merge_node_valid_out_1;
assign merge_node_stall_in_1 = rnode_1to6_input_local_id_3_0_stall_out_reg_6;
assign rnode_1to6_input_local_id_3_0 = rnode_1to6_input_local_id_3_0_reg_6;
assign rnode_1to6_input_local_id_3_0_stall_in_reg_6 = rnode_1to6_input_local_id_3_0_stall_in;
assign rnode_1to6_input_local_id_3_0_valid_out = rnode_1to6_input_local_id_3_0_valid_out_reg_6;

// This section implements an unregistered operation.
// 
wire local_bb1_result_i_valid_out_1;
wire local_bb1_result_i_stall_in_1;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg local_bb1_result_i_consumed_1;
wire local_bb1_arrayidx_valid_out;
wire local_bb1_arrayidx_stall_in;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg local_bb1_arrayidx_consumed_0;
wire local_bb1_arrayidx_inputs_ready;
wire local_bb1_arrayidx_stall_local;
wire [31:0] local_bb1_arrayidx;

assign local_bb1_arrayidx_inputs_ready = merge_node_valid_out_0;
assign local_bb1_arrayidx = (input_src + (local_bb1_result_i << 6'h2));
assign local_bb1_arrayidx_stall_local = ((local_bb1_result_i_stall_in_1 & ~(local_bb1_result_i_consumed_1)) | (local_bb1_arrayidx_stall_in & ~(local_bb1_arrayidx_consumed_0)));
assign local_bb1_result_i_valid_out_1 = (local_bb1_arrayidx_inputs_ready & ~(local_bb1_result_i_consumed_1));
assign local_bb1_arrayidx_valid_out = (local_bb1_arrayidx_inputs_ready & ~(local_bb1_arrayidx_consumed_0));
assign merge_node_stall_in_0 = (|local_bb1_arrayidx_stall_local);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_result_i_consumed_1 <= 1'b0;
		local_bb1_arrayidx_consumed_0 <= 1'b0;
	end
	else
	begin
		local_bb1_result_i_consumed_1 <= (local_bb1_arrayidx_inputs_ready & (local_bb1_result_i_consumed_1 | ~(local_bb1_result_i_stall_in_1)) & local_bb1_arrayidx_stall_local);
		local_bb1_arrayidx_consumed_0 <= (local_bb1_arrayidx_inputs_ready & (local_bb1_arrayidx_consumed_0 | ~(local_bb1_arrayidx_stall_in)) & local_bb1_arrayidx_stall_local);
	end
end


// Register node:
//  * latency = 2
//  * capacity = 2
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to3_bb1_result_i_0_valid_out;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to3_bb1_result_i_0_stall_in;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [63:0] rnode_1to3_bb1_result_i_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to3_bb1_result_i_0_reg_3_inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [63:0] rnode_1to3_bb1_result_i_0_reg_3;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to3_bb1_result_i_0_valid_out_reg_3;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to3_bb1_result_i_0_stall_in_reg_3;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to3_bb1_result_i_0_stall_out_reg_3;

acl_data_fifo rnode_1to3_bb1_result_i_0_reg_3_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to3_bb1_result_i_0_reg_3_inputs_ready),
	.stall_in(rnode_1to3_bb1_result_i_0_stall_in_reg_3),
	.valid_out(rnode_1to3_bb1_result_i_0_valid_out_reg_3),
	.stall_out(rnode_1to3_bb1_result_i_0_stall_out_reg_3),
	.data_in(local_bb1_result_i),
	.data_out(rnode_1to3_bb1_result_i_0_reg_3)
);

defparam rnode_1to3_bb1_result_i_0_reg_3_fifo.DEPTH = 3;
defparam rnode_1to3_bb1_result_i_0_reg_3_fifo.DATA_WIDTH = 64;
defparam rnode_1to3_bb1_result_i_0_reg_3_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to3_bb1_result_i_0_reg_3_fifo.IMPL = "ll_reg";

assign rnode_1to3_bb1_result_i_0_reg_3_inputs_ready = local_bb1_result_i_valid_out_1;
assign local_bb1_result_i_stall_in_1 = rnode_1to3_bb1_result_i_0_stall_out_reg_3;
assign rnode_1to3_bb1_result_i_0 = rnode_1to3_bb1_result_i_0_reg_3;
assign rnode_1to3_bb1_result_i_0_stall_in_reg_3 = rnode_1to3_bb1_result_i_0_stall_in;
assign rnode_1to3_bb1_result_i_0_valid_out = rnode_1to3_bb1_result_i_0_valid_out_reg_3;

// Register node:
//  * latency = 1
//  * capacity = 1
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to2_bb1_arrayidx_0_valid_out;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to2_bb1_arrayidx_0_stall_in;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [31:0] rnode_1to2_bb1_arrayidx_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to2_bb1_arrayidx_0_reg_2_inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [31:0] rnode_1to2_bb1_arrayidx_0_reg_2;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to2_bb1_arrayidx_0_valid_out_reg_2;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to2_bb1_arrayidx_0_stall_in_reg_2;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_1to2_bb1_arrayidx_0_stall_out_reg_2;

acl_data_fifo rnode_1to2_bb1_arrayidx_0_reg_2_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_1to2_bb1_arrayidx_0_reg_2_inputs_ready),
	.stall_in(rnode_1to2_bb1_arrayidx_0_stall_in_reg_2),
	.valid_out(rnode_1to2_bb1_arrayidx_0_valid_out_reg_2),
	.stall_out(rnode_1to2_bb1_arrayidx_0_stall_out_reg_2),
	.data_in(local_bb1_arrayidx),
	.data_out(rnode_1to2_bb1_arrayidx_0_reg_2)
);

defparam rnode_1to2_bb1_arrayidx_0_reg_2_fifo.DEPTH = 2;
defparam rnode_1to2_bb1_arrayidx_0_reg_2_fifo.DATA_WIDTH = 32;
defparam rnode_1to2_bb1_arrayidx_0_reg_2_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_1to2_bb1_arrayidx_0_reg_2_fifo.IMPL = "ll_reg";

assign rnode_1to2_bb1_arrayidx_0_reg_2_inputs_ready = local_bb1_arrayidx_valid_out;
assign local_bb1_arrayidx_stall_in = rnode_1to2_bb1_arrayidx_0_stall_out_reg_2;
assign rnode_1to2_bb1_arrayidx_0 = rnode_1to2_bb1_arrayidx_0_reg_2;
assign rnode_1to2_bb1_arrayidx_0_stall_in_reg_2 = rnode_1to2_bb1_arrayidx_0_stall_in;
assign rnode_1to2_bb1_arrayidx_0_valid_out = rnode_1to2_bb1_arrayidx_0_valid_out_reg_2;

// This section implements an unregistered operation.
// 
wire local_bb1_arrayidx2_valid_out;
wire local_bb1_arrayidx2_stall_in;
wire local_bb1_arrayidx2_inputs_ready;
wire local_bb1_arrayidx2_stall_local;
wire [31:0] local_bb1_arrayidx2;

assign local_bb1_arrayidx2_inputs_ready = rnode_1to3_bb1_result_i_0_valid_out;
assign local_bb1_arrayidx2 = (input_dst + (rnode_1to3_bb1_result_i_0 << 6'h2));
assign local_bb1_arrayidx2_valid_out = local_bb1_arrayidx2_inputs_ready;
assign local_bb1_arrayidx2_stall_local = local_bb1_arrayidx2_stall_in;
assign rnode_1to3_bb1_result_i_0_stall_in = (|local_bb1_arrayidx2_stall_local);

// This section implements a registered operation.
// 
wire local_bb1_ld__inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg local_bb1_ld__valid_out;
wire local_bb1_ld__stall_in;
wire local_bb1_ld__output_regs_ready;
wire local_bb1_ld__fu_stall_out;
wire local_bb1_ld__fu_valid_out;
wire [31:0] local_bb1_ld__lsu_dataout;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] local_bb1_ld_;
wire local_bb1_ld__causedstall;

lsu_top lsu_local_bb1_ld_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rnode_1to2_bb1_arrayidx_0),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb1_ld__fu_stall_out),
	.i_valid(local_bb1_ld__inputs_ready),
	.i_address(rnode_1to2_bb1_arrayidx_0),
	.i_writedata(),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_stall(~(local_bb1_ld__output_regs_ready)),
	.o_valid(local_bb1_ld__fu_valid_out),
	.o_readdata(local_bb1_ld__lsu_dataout),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_ld__active),
	.avm_address(avm_local_bb1_ld__address),
	.avm_read(avm_local_bb1_ld__read),
	.avm_readdata(avm_local_bb1_ld__readdata),
	.avm_write(avm_local_bb1_ld__write),
	.avm_writeack(avm_local_bb1_ld__writeack),
	.avm_burstcount(avm_local_bb1_ld__burstcount),
	.avm_writedata(avm_local_bb1_ld__writedata),
	.avm_byteenable(avm_local_bb1_ld__byteenable),
	.avm_waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_readdatavalid(avm_local_bb1_ld__readdatavalid)
);

defparam lsu_local_bb1_ld_.AWIDTH = 32;
defparam lsu_local_bb1_ld_.WIDTH_BYTES = 4;
defparam lsu_local_bb1_ld_.MWIDTH_BYTES = 64;
defparam lsu_local_bb1_ld_.WRITEDATAWIDTH_BYTES = 64;
defparam lsu_local_bb1_ld_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_ld_.READ = 1;
defparam lsu_local_bb1_ld_.ATOMIC = 0;
defparam lsu_local_bb1_ld_.WIDTH = 32;
defparam lsu_local_bb1_ld_.MWIDTH = 512;
defparam lsu_local_bb1_ld_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_ld_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_ld_.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb1_ld_.MEMORY_SIDE_MEM_LATENCY = 83;
defparam lsu_local_bb1_ld_.USE_WRITE_ACK = 0;
defparam lsu_local_bb1_ld_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_ld_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_ld_.NUMBER_BANKS = 1;
defparam lsu_local_bb1_ld_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_ld_.USEINPUTFIFO = 0;
defparam lsu_local_bb1_ld_.USECACHING = 0;
defparam lsu_local_bb1_ld_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_ld_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_ld_.HIGH_FMAX = 1;
defparam lsu_local_bb1_ld_.ADDRSPACE = 1;
defparam lsu_local_bb1_ld_.STYLE = "BURST-COALESCED";

assign local_bb1_ld__inputs_ready = rnode_1to2_bb1_arrayidx_0_valid_out;
assign local_bb1_ld__output_regs_ready = (&(~(local_bb1_ld__valid_out) | ~(local_bb1_ld__stall_in)));
assign rnode_1to2_bb1_arrayidx_0_stall_in = (local_bb1_ld__fu_stall_out | ~(local_bb1_ld__inputs_ready));
assign local_bb1_ld__causedstall = (local_bb1_ld__inputs_ready && (local_bb1_ld__fu_stall_out && !(~(local_bb1_ld__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_ld_ <= 'x;
		local_bb1_ld__valid_out <= 1'b0;
	end
	else
	begin
		if (local_bb1_ld__output_regs_ready)
		begin
			local_bb1_ld_ <= local_bb1_ld__lsu_dataout;
			local_bb1_ld__valid_out <= local_bb1_ld__fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_ld__stall_in))
			begin
				local_bb1_ld__valid_out <= 1'b0;
			end
		end
	end
end


// Register node:
//  * latency = 1
//  * capacity = 1
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_3to4_bb1_arrayidx2_0_valid_out;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_3to4_bb1_arrayidx2_0_stall_in;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [31:0] rnode_3to4_bb1_arrayidx2_0;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_3to4_bb1_arrayidx2_0_reg_4_inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic [31:0] rnode_3to4_bb1_arrayidx2_0_reg_4;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_3to4_bb1_arrayidx2_0_valid_out_reg_4;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_3to4_bb1_arrayidx2_0_stall_in_reg_4;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) logic rnode_3to4_bb1_arrayidx2_0_stall_out_reg_4;

acl_data_fifo rnode_3to4_bb1_arrayidx2_0_reg_4_fifo (
	.clock(clock),
	.resetn(resetn),
	.valid_in(rnode_3to4_bb1_arrayidx2_0_reg_4_inputs_ready),
	.stall_in(rnode_3to4_bb1_arrayidx2_0_stall_in_reg_4),
	.valid_out(rnode_3to4_bb1_arrayidx2_0_valid_out_reg_4),
	.stall_out(rnode_3to4_bb1_arrayidx2_0_stall_out_reg_4),
	.data_in(local_bb1_arrayidx2),
	.data_out(rnode_3to4_bb1_arrayidx2_0_reg_4)
);

defparam rnode_3to4_bb1_arrayidx2_0_reg_4_fifo.DEPTH = 2;
defparam rnode_3to4_bb1_arrayidx2_0_reg_4_fifo.DATA_WIDTH = 32;
defparam rnode_3to4_bb1_arrayidx2_0_reg_4_fifo.ALLOW_FULL_WRITE = 0;
defparam rnode_3to4_bb1_arrayidx2_0_reg_4_fifo.IMPL = "ll_reg";

assign rnode_3to4_bb1_arrayidx2_0_reg_4_inputs_ready = local_bb1_arrayidx2_valid_out;
assign local_bb1_arrayidx2_stall_in = rnode_3to4_bb1_arrayidx2_0_stall_out_reg_4;
assign rnode_3to4_bb1_arrayidx2_0 = rnode_3to4_bb1_arrayidx2_0_reg_4;
assign rnode_3to4_bb1_arrayidx2_0_stall_in_reg_4 = rnode_3to4_bb1_arrayidx2_0_stall_in;
assign rnode_3to4_bb1_arrayidx2_0_valid_out = rnode_3to4_bb1_arrayidx2_0_valid_out_reg_4;

// This section implements a staging register.
// 
wire rstag_4to4_bb1_ld__valid_out;
wire rstag_4to4_bb1_ld__stall_in;
wire rstag_4to4_bb1_ld__inputs_ready;
wire rstag_4to4_bb1_ld__stall_local;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg rstag_4to4_bb1_ld__staging_valid;
wire rstag_4to4_bb1_ld__combined_valid;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] rstag_4to4_bb1_ld__staging_reg;
wire [31:0] rstag_4to4_bb1_ld_;

assign rstag_4to4_bb1_ld__inputs_ready = local_bb1_ld__valid_out;
assign rstag_4to4_bb1_ld_ = (rstag_4to4_bb1_ld__staging_valid ? rstag_4to4_bb1_ld__staging_reg : local_bb1_ld_);
assign rstag_4to4_bb1_ld__combined_valid = (rstag_4to4_bb1_ld__staging_valid | rstag_4to4_bb1_ld__inputs_ready);
assign rstag_4to4_bb1_ld__valid_out = rstag_4to4_bb1_ld__combined_valid;
assign rstag_4to4_bb1_ld__stall_local = rstag_4to4_bb1_ld__stall_in;
assign local_bb1_ld__stall_in = (|rstag_4to4_bb1_ld__staging_valid);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_4to4_bb1_ld__staging_valid <= 1'b0;
		rstag_4to4_bb1_ld__staging_reg <= 'x;
	end
	else
	begin
		if (rstag_4to4_bb1_ld__stall_local)
		begin
			if (~(rstag_4to4_bb1_ld__staging_valid))
			begin
				rstag_4to4_bb1_ld__staging_valid <= rstag_4to4_bb1_ld__inputs_ready;
			end
		end
		else
		begin
			rstag_4to4_bb1_ld__staging_valid <= 1'b0;
		end
		if (~(rstag_4to4_bb1_ld__staging_valid))
		begin
			rstag_4to4_bb1_ld__staging_reg <= local_bb1_ld_;
		end
	end
end


// This section implements a registered operation.
// 
wire local_bb1_st__inputs_ready;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg local_bb1_st__valid_out;
wire local_bb1_st__stall_in;
wire local_bb1_st__output_regs_ready;
wire local_bb1_st__fu_stall_out;
wire local_bb1_st__fu_valid_out;
wire local_bb1_st__causedstall;   
   
lsu_top lsu_local_bb1_st_ (
	.clock(clock),
	.clock2x(clock2x),
	.resetn(resetn),
	.flush(start),
	.stream_base_addr(rnode_3to4_bb1_arrayidx2_0),
	.stream_size(input_global_size_0),
	.stream_reset(valid_in),
	.o_stall(local_bb1_st__fu_stall_out),
	.i_valid(local_bb1_st__inputs_ready),
	.i_address(rnode_3to4_bb1_arrayidx2_0),
	.i_writedata(rstag_4to4_bb1_ld_),
	.i_cmpdata(),
	.i_predicate(1'b0),
	.i_bitwiseor(64'h0),
	.i_stall(~(local_bb1_st__output_regs_ready)),
	.o_valid(local_bb1_st__fu_valid_out),
	.o_readdata(),
	.o_input_fifo_depth(),
	.o_writeack(),
	.i_atomic_op(3'h0),
	.o_active(local_bb1_st__active),
	.avm_address(avm_local_bb1_st__address),
	.avm_read(avm_local_bb1_st__read),
	.avm_readdata(avm_local_bb1_st__readdata),
	.avm_write(avm_local_bb1_st__write),
	.avm_writeack(avm_local_bb1_st__writeack),
	.avm_burstcount(avm_local_bb1_st__burstcount),
	.avm_writedata(avm_local_bb1_st__writedata),
	.avm_byteenable(avm_local_bb1_st__byteenable),
	.avm_waitrequest(avm_local_bb1_st__waitrequest),
	.avm_readdatavalid(avm_local_bb1_st__readdatavalid)
);

defparam lsu_local_bb1_st_.AWIDTH = 32;
defparam lsu_local_bb1_st_.WIDTH_BYTES = 4;
defparam lsu_local_bb1_st_.MWIDTH_BYTES = 64;
defparam lsu_local_bb1_st_.WRITEDATAWIDTH_BYTES = 64;
defparam lsu_local_bb1_st_.ALIGNMENT_BYTES = 4;
defparam lsu_local_bb1_st_.READ = 0;
defparam lsu_local_bb1_st_.ATOMIC = 0;
defparam lsu_local_bb1_st_.WIDTH = 32;
defparam lsu_local_bb1_st_.MWIDTH = 512;
defparam lsu_local_bb1_st_.ATOMIC_WIDTH = 3;
defparam lsu_local_bb1_st_.BURSTCOUNT_WIDTH = 5;
defparam lsu_local_bb1_st_.KERNEL_SIDE_MEM_LATENCY = 2;
defparam lsu_local_bb1_st_.MEMORY_SIDE_MEM_LATENCY = 16;
defparam lsu_local_bb1_st_.USE_WRITE_ACK = 1;
defparam lsu_local_bb1_st_.ENABLE_BANKED_MEMORY = 0;
defparam lsu_local_bb1_st_.ABITS_PER_LMEM_BANK = 0;
defparam lsu_local_bb1_st_.NUMBER_BANKS = 1;
defparam lsu_local_bb1_st_.LMEM_ADDR_PERMUTATION_STYLE = 0;
defparam lsu_local_bb1_st_.USEINPUTFIFO = 0;
defparam lsu_local_bb1_st_.USECACHING = 0;
defparam lsu_local_bb1_st_.USEOUTPUTFIFO = 1;
defparam lsu_local_bb1_st_.FORCE_NOP_SUPPORT = 0;
defparam lsu_local_bb1_st_.HIGH_FMAX = 1;
defparam lsu_local_bb1_st_.ADDRSPACE = 1;
defparam lsu_local_bb1_st_.STYLE = "BURST-COALESCED";

assign local_bb1_st__inputs_ready = (rnode_3to4_bb1_arrayidx2_0_valid_out & rstag_4to4_bb1_ld__valid_out);
assign local_bb1_st__output_regs_ready = (&(~(local_bb1_st__valid_out) | ~(local_bb1_st__stall_in)));
assign rnode_3to4_bb1_arrayidx2_0_stall_in = (local_bb1_st__fu_stall_out | ~(local_bb1_st__inputs_ready));
assign rstag_4to4_bb1_ld__stall_in = (local_bb1_st__fu_stall_out | ~(local_bb1_st__inputs_ready));
assign local_bb1_st__causedstall = (local_bb1_st__inputs_ready && (local_bb1_st__fu_stall_out && !(~(local_bb1_st__output_regs_ready))));

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		local_bb1_st__valid_out <= 1'b0;
	end
	else
	begin
		if (local_bb1_st__output_regs_ready)
		begin
			local_bb1_st__valid_out <= local_bb1_st__fu_valid_out;
		end
		else
		begin
			if (~(local_bb1_st__stall_in))
			begin
				local_bb1_st__valid_out <= 1'b0;
			end
		end
	end
end


// This section implements a staging register.
// 
wire rstag_6to6_bb1_st__valid_out;
wire rstag_6to6_bb1_st__stall_in;
wire rstag_6to6_bb1_st__inputs_ready;
wire rstag_6to6_bb1_st__stall_local;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg rstag_6to6_bb1_st__staging_valid;
wire rstag_6to6_bb1_st__combined_valid;

assign rstag_6to6_bb1_st__inputs_ready = local_bb1_st__valid_out;
assign rstag_6to6_bb1_st__combined_valid = (rstag_6to6_bb1_st__staging_valid | rstag_6to6_bb1_st__inputs_ready);
assign rstag_6to6_bb1_st__valid_out = rstag_6to6_bb1_st__combined_valid;
assign rstag_6to6_bb1_st__stall_local = rstag_6to6_bb1_st__stall_in;
assign local_bb1_st__stall_in = (|rstag_6to6_bb1_st__staging_valid);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		rstag_6to6_bb1_st__staging_valid <= 1'b0;
	end
	else
	begin
		if (rstag_6to6_bb1_st__stall_local)
		begin
			if (~(rstag_6to6_bb1_st__staging_valid))
			begin
				rstag_6to6_bb1_st__staging_valid <= rstag_6to6_bb1_st__inputs_ready;
			end
		end
		else
		begin
			rstag_6to6_bb1_st__staging_valid <= 1'b0;
		end
	end
end


// This section describes the behaviour of the BRANCH node.
wire branch_var__inputs_ready;
wire branch_var__output_regs_ready;

assign branch_var__inputs_ready = (rnode_1to6_input_local_id_3_0_valid_out & rstag_6to6_bb1_st__valid_out);
assign branch_var__output_regs_ready = ~(stall_in);
assign rnode_1to6_input_local_id_3_0_stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign rstag_6to6_bb1_st__stall_in = (~(branch_var__output_regs_ready) | ~(branch_var__inputs_ready));
assign valid_out = branch_var__inputs_ready;
assign lvb_input_local_id_3 = rnode_1to6_input_local_id_3_0;

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module shiftSignal1( clock, resetn, valid_in, ready_out, din, dout );

   parameter WIDTH=32;
   parameter CYCLES=6;

   input clock;
   input resetn;
   input valid_in;
   input ready_out;
   input [WIDTH-1:0] din;
   output [WIDTH-1:0] dout;

   integer t;

   reg [WIDTH-1:0] my_shift_reg[0:CYCLES-1];

   assign dout = my_shift_reg[CYCLES-1];

   always@(posedge clock or negedge resetn)
     begin
        if (!resetn) begin
           my_shift_reg[0] <= {WIDTH{1'b0}};
        end
        else if(valid_in && ready_out) begin
           my_shift_reg[0] <= din;
        end
        else if(ready_out) begin
           my_shift_reg[0] <= {WIDTH{1'b0}};
        end
     end
   
   always@(posedge clock or negedge resetn)
     begin
        for (t=1; t<CYCLES; t=t+1) begin
           if (!resetn) begin
              my_shift_reg[t] <= {WIDTH{1'b0}};
           end
           else if(ready_out) begin
              my_shift_reg[t] <= my_shift_reg[t-1];
           end
        end
     end
endmodule 

module copyElement_function
	(
		input 		clock,
		input 		resetn,
		input [31:0] 		m_input_global_id_0,
		input [31:0] 		m_input_local_id_3,
		output 		m_ready_out,
		input 		m_valid_in,
		output [31:0] 		m_output_0,
		output 		m_valid_out,
		input 		m_ready_in,
		input [31:0] 		copyElement_live_thread_count,
		input [31:0] 		m_workgroup_size,
		input [511:0] 		avm_local_bb1_ld__readdata,
		input 		avm_local_bb1_ld__readdatavalid,
		input 		avm_local_bb1_ld__waitrequest,
		output [31:0] 		avm_local_bb1_ld__address,
		output 		avm_local_bb1_ld__read,
		output 		avm_local_bb1_ld__write,
		input 		avm_local_bb1_ld__writeack,
		output [511:0] 		avm_local_bb1_ld__writedata,
		output [63:0] 		avm_local_bb1_ld__byteenable,
		output [4:0] 		avm_local_bb1_ld__burstcount,
		input [511:0] 		avm_local_bb1_st__readdata,
		input 		avm_local_bb1_st__readdatavalid,
		input 		avm_local_bb1_st__waitrequest,
		output [31:0] 		avm_local_bb1_st__address,
		output 		avm_local_bb1_st__read,
		output 		avm_local_bb1_st__write,
		input 		avm_local_bb1_st__writeack,
		output [511:0] 		avm_local_bb1_st__writedata,
		output [63:0] 		avm_local_bb1_st__byteenable,
		output [4:0] 		avm_local_bb1_st__burstcount,
		input 		m_start,
		input 		clock2x,
		input [31:0] 		m_input_src,
		input [31:0] 		m_input_global_size_0,
		input [31:0] 		m_input_dst,
		output reg 		has_a_write_pending,
		output reg 		has_a_lsu_active
	);


wire [31:0] cur_cycle;
wire bb_0_stall_out;
wire bb_0_valid_out;
wire [31:0] bb_0_lvb_input_global_id_0;
wire [31:0] bb_0_lvb_input_local_id_3;
wire bb_1_stall_out;
wire bb_1_valid_out;
wire [31:0] bb_1_lvb_input_local_id_3;
wire bb_1_local_bb1_ld__active;
wire bb_1_local_bb1_st__active;
wire writes_pending;
wire [1:0] lsus_active;

   // utku:
wire start;
reg [3:0] r_start;
   
wire stall_out;  
wire stall_in;
wire valid_in;
wire valid_out;

wire [31:0] output_0;
wire [31:0] input_global_id_0;
wire [31:0] input_local_id_3;
wire [31:0] input_global_size_0;
wire [31:0] workgroup_size;
wire [31:0] input_src;
wire [31:0] input_dst;

// keep track if writeack was received for store lsu, 
// when we receive the writeack once, we are done with all the threads
reg reg_st__writeack;   
always_ff@(posedge clock or negedge resetn) begin
  if ( !resetn) begin
     reg_st__writeack <= 1'b0;
  end
  else begin
     if( avm_local_bb1_st__writeack )
       reg_st__writeack <= 1'b1;
  end
end
   
assign m_output_0 = output_0;   
assign start = (r_start == 4'b0100 || r_start == 4'b0010);   
assign m_ready_out  = ~stall_out;
assign stall_in = ~m_ready_in;
assign m_valid_out = valid_out;

always_ff@(posedge clock or negedge resetn)
  if ( !resetn)
    r_start <= 4'b0001;
  else if( m_valid_in && r_start != 4'b1000)
    r_start <= (r_start << 1);

   shiftSignal1 shiftValidIn(clock, resetn, m_valid_in, m_ready_out, m_valid_in, valid_in);
   defparam shiftValidIn.WIDTH = 1;
   
   shiftSignal1 shiftLocalId3(clock, resetn, m_valid_in, m_ready_out, m_input_local_id_3, input_local_id_3);
   defparam shiftLocalId3.WIDTH = 32;
   
   shiftSignal1 shiftWorkGroupSize(clock, resetn, m_valid_in, m_ready_out, m_workgroup_size, workgroup_size);
   defparam shiftWorkGroupSize.WIDTH = 32;

   assign input_src = m_input_src;
   
   assign input_dst = m_input_dst;
   
   shiftSignal1 shiftGlobalId(clock, resetn, m_valid_in, m_ready_out, m_input_global_id_0, input_global_id_0);
   defparam shiftGlobalId.WIDTH = 32;
   
   shiftSignal1 shiftGlobalSize(clock, resetn, m_valid_in, m_ready_out, m_input_global_size_0, input_global_size_0);
   defparam shiftGlobalSize.WIDTH = 32;

   assign input_global_size_0 = m_input_global_size_0;
   
copyElement_basic_block_0 copyElement_basic_block_0 (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.valid_in(valid_in),
	.stall_out(bb_0_stall_out),
	.input_global_id_0(input_global_id_0),
	.input_local_id_3(input_local_id_3),
	.valid_out(bb_0_valid_out),
	.stall_in(bb_1_stall_out),
	.lvb_input_global_id_0(bb_0_lvb_input_global_id_0),
	.lvb_input_local_id_3(bb_0_lvb_input_local_id_3),
	.copyElement_live_thread_count(copyElement_live_thread_count),
	.workgroup_size(workgroup_size)
);


copyElement_basic_block_1 copyElement_basic_block_1 (
	.clock(clock),
	.resetn(resetn),
	.input_src(input_src),
	.input_global_size_0(input_global_size_0),
	.input_dst(input_dst),
	.valid_in(bb_0_valid_out),
	.stall_out(bb_1_stall_out),
	.input_global_id_0(bb_0_lvb_input_global_id_0),
	.input_local_id_3(bb_0_lvb_input_local_id_3),
	.valid_out(bb_1_valid_out),
	.stall_in(stall_in),
	.lvb_input_local_id_3(bb_1_lvb_input_local_id_3),
	.copyElement_live_thread_count(copyElement_live_thread_count),
	.workgroup_size(workgroup_size),
	.start(start),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__burstcount),
	.local_bb1_ld__active(bb_1_local_bb1_ld__active),
	.clock2x(clock2x),
	.avm_local_bb1_st__readdata(avm_local_bb1_st__readdata),
	.avm_local_bb1_st__readdatavalid(avm_local_bb1_st__readdatavalid),
	.avm_local_bb1_st__waitrequest(avm_local_bb1_st__waitrequest),
	.avm_local_bb1_st__address(avm_local_bb1_st__address),
	.avm_local_bb1_st__read(avm_local_bb1_st__read),
	.avm_local_bb1_st__write(avm_local_bb1_st__write),
	.avm_local_bb1_st__writeack(avm_local_bb1_st__writeack),
	.avm_local_bb1_st__writedata(avm_local_bb1_st__writedata),
	.avm_local_bb1_st__byteenable(avm_local_bb1_st__byteenable),
	.avm_local_bb1_st__burstcount(avm_local_bb1_st__burstcount),
	.local_bb1_st__active(bb_1_local_bb1_st__active)
);


copyElement_sys_cycle_time system_cycle_time_module (
	.clock(clock),
	.resetn(resetn),
	.cur_cycle(cur_cycle)
);


assign valid_out = bb_1_valid_out;
assign output_0 = bb_1_lvb_input_local_id_3;
assign stall_out = bb_0_stall_out;
assign writes_pending = bb_1_local_bb1_st__active;
assign lsus_active[0] = bb_1_local_bb1_ld__active;
assign lsus_active[1] = bb_1_local_bb1_st__active;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		has_a_write_pending <= 1'b0;
		has_a_lsu_active <= 1'b0;
	end
	else
	begin
		has_a_write_pending <= (|writes_pending);
		has_a_lsu_active <= (|lsus_active);
	end
end

endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module copyElement_function_wrapper
	(
		input 		clock,
		input 		resetn,
		input 		clock2x,
		input 		local_router_hang,
		input 		avs_cra_read,
		input 		avs_cra_write,
		input [3:0] 		avs_cra_address,
		input [63:0] 		avs_cra_writedata,
		input [7:0] 		avs_cra_byteenable,
		output 		avs_cra_waitrequest,
		output reg [63:0] 		avs_cra_readdata,
		output reg 		avs_cra_readdatavalid,
		output 		cra_irq,
		input [511:0] 		avm_local_bb1_ld__inst0_readdata,
		input 		avm_local_bb1_ld__inst0_readdatavalid,
		input 		avm_local_bb1_ld__inst0_waitrequest,
		output [31:0] 		avm_local_bb1_ld__inst0_address,
		output 		avm_local_bb1_ld__inst0_read,
		output 		avm_local_bb1_ld__inst0_write,
		input 		avm_local_bb1_ld__inst0_writeack,
		output [511:0] 		avm_local_bb1_ld__inst0_writedata,
		output [63:0] 		avm_local_bb1_ld__inst0_byteenable,
		output [4:0] 		avm_local_bb1_ld__inst0_burstcount,
		input [511:0] 		avm_local_bb1_st__inst0_readdata,
		input 		avm_local_bb1_st__inst0_readdatavalid,
		input 		avm_local_bb1_st__inst0_waitrequest,
		output [31:0] 		avm_local_bb1_st__inst0_address,
		output 		avm_local_bb1_st__inst0_read,
		output 		avm_local_bb1_st__inst0_write,
		input 		avm_local_bb1_st__inst0_writeack,
		output [511:0] 		avm_local_bb1_st__inst0_writedata,
		output [63:0] 		avm_local_bb1_st__inst0_byteenable,
		output [4:0] 		avm_local_bb1_st__inst0_burstcount
	);

// Responsible for interfacing a kernel with the outside world. It comprises a
// slave interface to specify the kernel arguments and retain kernel status. 

// This section of the wrapper implements the slave interface.
// twoXclock_consumer uses clock2x, even if nobody inside the kernel does. Keeps interface to acl_iface consistent for all kernels.
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg start;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg started;
wire finish;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] status;
wire has_a_write_pending;
wire has_a_lsu_active;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [63:0] kernel_arguments;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg twoXclock_consumer /* synthesis  preserve  noprune  */;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] workgroup_size;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] global_size[2:0];
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] num_groups[2:0];
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] local_size[2:0];
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] work_dim;
(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] global_offset[2:0];
wire dispatched_all_groups;
wire [31:0] group_id_tmp[2:0];
wire [31:0] global_id_base_out[2:0];
wire start_out;
wire [31:0] local_id[0:0][2:0];
wire [31:0] global_id[0:0][2:0];
wire [31:0] group_id[0:0][2:0];
wire iter_valid_in;
wire iter_stall_out;
wire stall_in;
wire stall_out;
wire valid_in;
wire valid_out;

always @(posedge clock2x or negedge resetn)
begin
	if (~(resetn))
	begin
		twoXclock_consumer <= 1'b0;
	end
	else
	begin
		twoXclock_consumer <= 1'b1;
	end
end



// Work group dispatcher is responsible for issuing work-groups to id iterator(s)
acl_work_group_dispatcher group_dispatcher (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.num_groups(num_groups),
	.local_size(local_size),
	.stall_in(iter_stall_out),
	.valid_out(iter_valid_in),
	.group_id_out(group_id_tmp),
	.global_id_base_out(global_id_base_out),
	.start_out(start_out),
	.dispatched_all_groups(dispatched_all_groups)
);

defparam group_dispatcher.NUM_COPIES = 1;
defparam group_dispatcher.RUN_FOREVER = 0;


// This section of the wrapper implements an Avalon Slave Interface used to configure a kernel invocation.
// The few words words contain the status and the workgroup size registers.
// The remaining addressable space is reserved for kernel arguments.
wire [63:0] bitenable;

assign bitenable[7:0] = (avs_cra_byteenable[0] ? 8'hFF : 8'h0);
assign bitenable[15:8] = (avs_cra_byteenable[1] ? 8'hFF : 8'h0);
assign bitenable[23:16] = (avs_cra_byteenable[2] ? 8'hFF : 8'h0);
assign bitenable[31:24] = (avs_cra_byteenable[3] ? 8'hFF : 8'h0);
assign bitenable[39:32] = (avs_cra_byteenable[4] ? 8'hFF : 8'h0);
assign bitenable[47:40] = (avs_cra_byteenable[5] ? 8'hFF : 8'h0);
assign bitenable[55:48] = (avs_cra_byteenable[6] ? 8'hFF : 8'h0);
assign bitenable[63:56] = (avs_cra_byteenable[7] ? 8'hFF : 8'h0);
assign avs_cra_waitrequest = 1'b0;
assign cra_irq = (status[1] | status[3]);

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		start <= 1'b0;
		started <= 1'b0;
		kernel_arguments <= 64'h0;
		status <= 32'h10000;
		work_dim <= 32'h0;
		workgroup_size <= 32'h0;
		global_size[0] <= 32'h0;
		global_size[1] <= 32'h0;
		global_size[2] <= 32'h0;
		num_groups[0] <= 32'h0;
		num_groups[1] <= 32'h0;
		num_groups[2] <= 32'h0;
		local_size[0] <= 32'h0;
		local_size[1] <= 32'h0;
		local_size[2] <= 32'h0;
		global_offset[0] <= 32'h0;
		global_offset[1] <= 32'h0;
		global_offset[2] <= 32'h0;
	end
	else
	begin
		if (avs_cra_write)
		begin
			case (avs_cra_address)
				4'h0:
				begin
					status[31:16] <= 16'h1;
					status[15:0] <= ((status[15:0] & ~(bitenable[15:0])) | (avs_cra_writedata[15:0] & bitenable[15:0]));
				end

				4'h1:
				begin
					work_dim <= ((work_dim & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h2:
				begin
					workgroup_size <= ((workgroup_size & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_size[0] <= ((global_size[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h3:
				begin
					global_size[1] <= ((global_size[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_size[2] <= ((global_size[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h4:
				begin
					num_groups[0] <= ((num_groups[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					num_groups[1] <= ((num_groups[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h5:
				begin
					num_groups[2] <= ((num_groups[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					local_size[0] <= ((local_size[0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h6:
				begin
					local_size[1] <= ((local_size[1] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					local_size[2] <= ((local_size[2] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h7:
				begin
					global_offset[0] <= ((global_offset[0] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					global_offset[1] <= ((global_offset[1] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h8:
				begin
					global_offset[2] <= ((global_offset[2] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
					kernel_arguments[31:0] <= ((kernel_arguments[31:0] & ~(bitenable[63:32])) | (avs_cra_writedata[63:32] & bitenable[63:32]));
				end

				4'h9:
				begin
					kernel_arguments[63:32] <= ((kernel_arguments[63:32] & ~(bitenable[31:0])) | (avs_cra_writedata[31:0] & bitenable[31:0]));
				end

				default:
				begin
				end

			endcase
		end
		else
		begin
			if (status[0])
			begin
				start <= 1'b1;
			end
			if (start)
			begin
				status[0] <= 1'b0;
				started <= 1'b1;
			end
			if (started)
			begin
				start <= 1'b0;
			end
			if (finish)
			begin
				status[1] <= 1'b1;
				started <= 1'b0;
			end
		end
		status[11] <= local_router_hang;
		status[12] <= (|has_a_lsu_active);
		status[13] <= (|has_a_write_pending);
		status[14] <= (|valid_in);
		status[15] <= started;
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdata <= 64'h0;
	end
	else
	begin
		case (avs_cra_address)
			4'h0:
			begin
				avs_cra_readdata[31:0] <= status;
				avs_cra_readdata[63:32] <= 32'h0;
			end

			4'h1:
			begin
				avs_cra_readdata[31:0] <= 'x;
				avs_cra_readdata[63:32] <= work_dim;
			end

			4'h2:
			begin
				avs_cra_readdata[31:0] <= workgroup_size;
				avs_cra_readdata[63:32] <= global_size[0];
			end

			4'h3:
			begin
				avs_cra_readdata[31:0] <= global_size[1];
				avs_cra_readdata[63:32] <= global_size[2];
			end

			4'h4:
			begin
				avs_cra_readdata[31:0] <= num_groups[0];
				avs_cra_readdata[63:32] <= num_groups[1];
			end

			4'h5:
			begin
				avs_cra_readdata[31:0] <= num_groups[2];
				avs_cra_readdata[63:32] <= local_size[0];
			end

			4'h6:
			begin
				avs_cra_readdata[31:0] <= local_size[1];
				avs_cra_readdata[63:32] <= local_size[2];
			end

			4'h7:
			begin
				avs_cra_readdata[31:0] <= global_offset[0];
				avs_cra_readdata[63:32] <= global_offset[1];
			end

			4'h8:
			begin
				avs_cra_readdata[31:0] <= global_offset[2];
				avs_cra_readdata[63:32] <= kernel_arguments[31:0];
			end

			4'h9:
			begin
				avs_cra_readdata[31:0] <= kernel_arguments[63:32];
				avs_cra_readdata[63:32] <= 32'h0;
			end

			default:
			begin
				avs_cra_readdata <= status;
			end

		endcase
	end
end

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		avs_cra_readdatavalid <= 1'b0;
	end
	else
	begin
		avs_cra_readdatavalid <= avs_cra_read;
	end
end


// Handshaking signals used to control data through the pipeline

// Determine when the kernel is finished.
acl_kernel_finish_detector kernel_finish_detector (
	.clock(clock),
	.resetn(resetn),
	.start(start),
	.wg_size(workgroup_size),
	.wg_dispatch_valid_out(iter_valid_in),
	.wg_dispatch_stall_in(iter_stall_out),
	.dispatched_all_groups(dispatched_all_groups),
	.kernel_copy_valid_out(valid_out),
	.kernel_copy_stall_in(stall_in),
	.pending_writes(has_a_write_pending),
	.finish(finish)
);

defparam kernel_finish_detector.NUM_COPIES = 1;
defparam kernel_finish_detector.WG_SIZE_W = 32;

assign stall_in = 1'b0;

// Creating ID iterator and kernel instance for every requested kernel copy

// ID iterator is responsible for iterating over all local ids for given work-groups
acl_id_iterator id_iter_inst0 (
	.clock(clock),
	.resetn(resetn),
	.start(start_out),
	.valid_in(iter_valid_in),
	.stall_out(iter_stall_out),
	.stall_in(stall_out),
	.valid_out(valid_in),
	.group_id_in(group_id_tmp),
	.global_id_base_in(global_id_base_out),
	.local_size(local_size),
	.global_size(global_size),
	.local_id(local_id[0]),
	.global_id(global_id[0]),
	.group_id(group_id[0])
);



// This section instantiates a kernel function block
copyElement_function copyElement_function_inst0 (
	.clock(clock),
	.resetn(resetn),
	.input_global_id_0(global_id[0][0]),
	.input_local_id_3(),
	.stall_out(stall_out),
	.valid_in(valid_in),
	.output_0(),
	.valid_out(valid_out),
	.stall_in(stall_in),
	.copyElement_live_thread_count(),
	.workgroup_size(workgroup_size),
	.avm_local_bb1_ld__readdata(avm_local_bb1_ld__inst0_readdata),
	.avm_local_bb1_ld__readdatavalid(avm_local_bb1_ld__inst0_readdatavalid),
	.avm_local_bb1_ld__waitrequest(avm_local_bb1_ld__inst0_waitrequest),
	.avm_local_bb1_ld__address(avm_local_bb1_ld__inst0_address),
	.avm_local_bb1_ld__read(avm_local_bb1_ld__inst0_read),
	.avm_local_bb1_ld__write(avm_local_bb1_ld__inst0_write),
	.avm_local_bb1_ld__writeack(avm_local_bb1_ld__inst0_writeack),
	.avm_local_bb1_ld__writedata(avm_local_bb1_ld__inst0_writedata),
	.avm_local_bb1_ld__byteenable(avm_local_bb1_ld__inst0_byteenable),
	.avm_local_bb1_ld__burstcount(avm_local_bb1_ld__inst0_burstcount),
	.avm_local_bb1_st__readdata(avm_local_bb1_st__inst0_readdata),
	.avm_local_bb1_st__readdatavalid(avm_local_bb1_st__inst0_readdatavalid),
	.avm_local_bb1_st__waitrequest(avm_local_bb1_st__inst0_waitrequest),
	.avm_local_bb1_st__address(avm_local_bb1_st__inst0_address),
	.avm_local_bb1_st__read(avm_local_bb1_st__inst0_read),
	.avm_local_bb1_st__write(avm_local_bb1_st__inst0_write),
	.avm_local_bb1_st__writeack(avm_local_bb1_st__inst0_writeack),
	.avm_local_bb1_st__writedata(avm_local_bb1_st__inst0_writedata),
	.avm_local_bb1_st__byteenable(avm_local_bb1_st__inst0_byteenable),
	.avm_local_bb1_st__burstcount(avm_local_bb1_st__inst0_burstcount),
	.start(start_out),
	.clock2x(clock2x),
	.input_src(kernel_arguments[63:32]),
	.input_global_size_0(global_size[0]),
	.input_dst(kernel_arguments[31:0]),
	.has_a_write_pending(has_a_write_pending),
	.has_a_lsu_active(has_a_lsu_active)
);



endmodule

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

module copyElement_sys_cycle_time
	(
		input 		clock,
		input 		resetn,
		output [31:0] 		cur_cycle
	);


(* altera_attribute = "-name auto_shift_register_recognition OFF" *) reg [31:0] cur_count;

assign cur_cycle = cur_count;

always @(posedge clock or negedge resetn)
begin
	if (~(resetn))
	begin
		cur_count <= 32'h0;
	end
	else
	begin
		cur_count <= (cur_count + 32'h1);
	end
end

endmodule

