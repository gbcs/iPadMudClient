//
//  MudButtonSendText.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudButtonsDetail.h"

@interface MudButtonSendText : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableview;
	NSObject *parentView;
	UITextView *textView;
	BOOL appendFlag;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSObject *parentView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic) BOOL appendFlag;

@end
