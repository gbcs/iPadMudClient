//
//  MudMacrosStepRun.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudClientIpad4ViewController.h"
#import "MudDataMacros.h"

@interface MudMacrosStepRun : UITableViewController <UITableViewDelegate, UIPopoverControllerDelegate, UITableViewDataSource>  {
	UITableView *tv;
}

@property (nonatomic, strong) UITableView *tv;

@end
