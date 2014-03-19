//
//  MudVariables.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"
#import "MudDataVariables.h"
#import "MudVariablesDetail.h"

@interface MudVariables : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate> {
	UITableView *tv;
	MudDataVariables *element;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) MudDataVariables *element;

-(void)SaveEditedRecord;
@end
