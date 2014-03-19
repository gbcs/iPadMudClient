//
//  MudMacrosBranchLocation.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudMacrosBranchLocation : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *branchLocation;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *branchLocation;

@end
