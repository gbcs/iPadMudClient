//
//  MudMacrosStep.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataVariables.h"

@interface MudMacrosStep  : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
}

@property (nonatomic, strong) UITableView *tableview;

@end
