//
//  TouchableTextsDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataTouchableTexts.h"
#import "TouchableTexts.h"

@interface TouchableTextsDetail : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextField *vartitle;
	UITextView *varcurrentvalue;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextField *vartitle;
@property (nonatomic, strong) UITextView *varcurrentvalue;

@end

