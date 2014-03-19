//
//  MudMacroStepDelay.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 3/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudMacroStepDelay: UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
}

@property (nonatomic, strong) UITableView *tableview;

@end
