//
//  MudMacroName.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudMacrosName: UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *macroName;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *macroName;

@end
