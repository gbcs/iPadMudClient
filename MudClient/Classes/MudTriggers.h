//
//  MudTriggers.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"
#import "MudDataTriggers.h"
#import "MudTriggersDetail.h"

@interface MudTriggers : UIViewController <UITableViewDelegate, UIPopoverControllerDelegate, UITableViewDataSource>  {
	UITableView *tv;
	MudDataTriggers	*element;
	UIView *triggerDisableView;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) MudDataTriggers *element;
-(void)saveEditedRecord;
- (void)buildToolbarButtons;
@end
