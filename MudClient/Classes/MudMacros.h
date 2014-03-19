//
//  MudMacros.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"
#import "MudDataMacros.h"
#import "MudMacrosDetail.h"

@interface MudMacros : UIViewController <UITableViewDelegate, UIPopoverControllerDelegate, UITableViewDataSource>  {
	UITableView *tv;
	MudDataMacros *element;
    UITextField *prefixChar;
    BOOL noEntriesCurrentlyExists;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) MudDataMacros *element;

-(void)SaveEditedRecord;

@end
