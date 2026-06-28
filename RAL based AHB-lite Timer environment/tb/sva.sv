// module SVA_module ( IF.DUT IF );
// // //___________________________________________________________________________________________________________
// property lfsr_res;
// @(posedge IF.CLK) disable iff((!IF.RST_n) )
// (IF.Comparison_Type==0)&&(IF.Comparison_EN)&&(TOP.DUT.Test_Processing==0) 
// |->
// ##(256*16) (IF.Comparison_Done==1'b1);
// endproperty
// lfsr_res_ass:assert property (lfsr_res);
// lfsr_res_cov: cover property(lfsr_res);
// // //___________________________________________________________________________________________________________
// property id_res;
// @(posedge IF.CLK) disable iff((!IF.RST_n) )
// (IF.Comparison_Type==1)&&(IF.Comparison_EN)&&(TOP.DUT.Test_Processing==0) 
// |->
// ##(32*16) (IF.Comparison_Done==1'b1);
// endproperty
// id_res_ass:assert property (id_res);
// id_res_cov: cover property(id_res);
// // //______________________________________________________________________________________________________
// // always_comb begin 
// // if(!IF.RST_n ) 
// // reset_assertion: assert final((IF.Done==1'b0) && (TOP.DUT.LFSR_REG==Seed)&& (TOP.DUT.Count=='b0));
// // reset_cov: cover final((IF.Done==1'b0) && (TOP.DUT.LFSR_REG==Seed)&& (TOP.DUT.Count=='b0));   
// // end 
// // //______________________________________________________________________________________________________
// always_comb begin 
// if(!IF.RST_n ) 
// reset_assertion: assert final( (IF.Comparison_Done=='b0)&& (IF.Faulty_Lanes=='b0));
// reset_cov: cover final( (IF.Comparison_Done=='b0)&& (IF.Faulty_Lanes=='b0));   
// end 

// endmodule