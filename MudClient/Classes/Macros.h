/*
 *  Macros.h
 *  MudClientIpad4
 *
 *  Created by Gary Barnett on 9/7/10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */


#define mMacroCommandModVarMacroArgument			1	// 1~var_obj_id~macro_arg_num
#define mMacroCommandModVarSetConstant				2	// 2~var_obj_id~value
#define mMacroCommandModVarAddConstant				3	// ""
#define mMacroCommandModVarSubtractConstant			4	// ""
#define mMacroCommandModVarMultiplyConstant			5	// ""
#define mMacroCommandModVarDivideConstant			6	// ""
#define mMacroCommandModVarAddVariable				7	// 7~var_obj_id~var_obj_id
#define mMacroCommandModVarSubtractVariable			8	// ""
#define mMacroCommandModVarMultiplyVariable			9	// ""
#define mMacroCommandModVarDivideVariable			10	// ""
#define mMacroCommandModVarSetFormattedText			11	// 11~var_obj_id~text~var_obj_id_list
#define mMacroCommandLabelAssign					12	// 12~labeltext
#define mMacroCommandBranchUnconditional			13	// 13~labeltext
#define mMacroCommandBranchEquality					14	// 14~labeltext~var_obj_id~var_obj_id
#define mMacroCommandBranchInequality				15	// ""
#define mMacroCommandBranchGreaterThan				16	// ""
#define mMacroCommandBranchLessThan					17	// ""
#define mMacroCommandSendFormattedTextServer		18	// 18~text~var_obj_id_list
#define mMacroCommandSendFormattedTextLocal			19	// ""
#define mMacroCommandEndMacro						20  // 
#define mMacroCommandRunMacro						21  // 
#define mMacroCommandModVarMacroArgumentAppend		22	// 1~var_obj_id~macro_arg_num


