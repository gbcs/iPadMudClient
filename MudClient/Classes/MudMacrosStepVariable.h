//
//  MudMacrosStepVariable.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudMacrosStepVariable : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tv;
}

@property (nonatomic, strong) UITableView *tv;

@end
