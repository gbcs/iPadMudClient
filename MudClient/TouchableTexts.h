//
//  TouchableTexts.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MudClientIpad4ViewController.h"
#import "MudDataTouchableTexts.h"

@interface TouchableTexts  : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate> {
	UITableView *tv;
	MudDataTouchableTexts *element;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) MudDataTouchableTexts *element;

-(void)SaveEditedRecord;
@end
