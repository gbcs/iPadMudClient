//
//  MudVariablesDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudVariablesDetail.h"
#import "MudDataVariables.h"
#import "MudVariables.h"


@interface MudVariablesDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *vartitle;
	UITextView *varcurrentvalue;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *vartitle;
@property (nonatomic, strong) UITextView *varcurrentvalue;

@end
