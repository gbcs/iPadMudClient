//
//  MudTriggersDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import	"MudTriggers.h"
#import	"MudDataTriggers.h"
#import "MudDataMacros.h"


@interface MudTriggersDetail : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *trigtitle;
	UITextView *trigvalue;
	MudDataMacros *trigmacro;
	UISwitch *trigenabled;
	UISwitch *trigautodisable;
	UIButton *showTriggerHelp;
	UIButton *autoCreateTrigger;
	UIButton *triggerLibrary;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *trigtitle;
@property (nonatomic, strong) UITextView *trigvalue;	
@property (nonatomic, strong) MudDataMacros *trigmacro;
@property (nonatomic, strong) UISwitch *trigenabled;
@property (nonatomic, strong) UISwitch *trigautodisable;
	
-(void)triggerEnabledSwitch:(id)sender;

@end
