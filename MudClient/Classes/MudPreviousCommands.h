//
//  MudPreviousCommands.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"


@interface MudPreviousCommands : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {
	UITableView *tv;
	NSMutableArray *mudPreviousCommandArray;
	MudClientIpad4ViewController *topController;
	
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) NSMutableArray *mudPreviousCommandArray;
@property (nonatomic, strong) MudClientIpad4ViewController *topController;

-(void)PullRecordsforList;

@end
