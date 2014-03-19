//
//  MudAliasesDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import <UIKit/UIKit.h>
#import "MudAliasesDetail.h"
#import "MudDataAliases.h"
#import "MudAliases.h"

@interface MudAliasesDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *vartitle;
	UITextView *varcurrentvalue;
    int selectedVariableIndex;
    MudDataVariables *var1;
    MudDataVariables *var2;
    MudDataVariables *var3;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *vartitle;
@property (nonatomic, strong) UITextView *varcurrentvalue;
-(void)updateVariable:(MudDataVariables *)var1;
@end
