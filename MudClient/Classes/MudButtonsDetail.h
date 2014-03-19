//
//  MudButtonsDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudButtonsDetail.h"
#import "MudDataButtons.h"

@interface MudButtonsDetail : UIViewController <UITableViewDelegate, UIPopoverControllerDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableview;
	UITextField *buttitle;
	MudDataButtons *element;
	NSObject *parentView;
	NSManagedObjectContext *context;
	UIView *bPanel;
	int editLayer;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *buttitle;
@property (nonatomic, strong) MudDataButtons *element;
@property (nonatomic, strong) NSObject *parentView;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) UIView *bPanel;
@property (nonatomic) int editLayer;

@end
 