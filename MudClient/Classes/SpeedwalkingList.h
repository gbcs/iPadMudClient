//
//  SpeedwalkingList.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"
#import "SpeedwalkingDetail.h"
#import "MudDataSpeedwalking.h"

@interface SpeedwalkingList : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate> {
	UITableView *tv;
	MudDataSpeedwalking *element;
    UITextField *prefixChar;
    UITextField *seperatorChar;
    BOOL noEntriesCurrentlyExists;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) MudDataSpeedwalking *element;

-(void)SaveEditedRecord;
@end
