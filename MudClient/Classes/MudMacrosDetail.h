//
//  MudMacrosDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataMacroSteps.h"

@interface MudMacrosDetail : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *mactitle;
	NSMutableArray *stepList;
	MudDataMacroSteps *macroStep;
	UIBarButtonItem *buttonAddStep;
	UIBarButtonItem *buttonReorderSteps;
	int subCommand;
	NSMutableArray *tvSteps;
}
	
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *mactitle;
@property (nonatomic, strong) NSMutableArray *stepList;
@property (nonatomic, strong) MudDataMacroSteps *macroStep;
@property (nonatomic, strong) UIBarButtonItem *buttonAddStep;
@property (nonatomic, strong) UIBarButtonItem *buttonReorderSteps;
@property (nonatomic) int subCommand;
@property (nonatomic, strong) NSMutableArray *tvSteps;

-(void)addStepButtonClicked:(id)sender;	
-(void)PullRecordsforList;
-(void)addStep;
-(void)saveStep;

@end
