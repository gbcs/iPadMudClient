//
//  MudMacrosStepVarAssMac.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudMacrosStepVarAssMac: UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	BOOL appendFlag;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic) BOOL appendFlag;
@end
