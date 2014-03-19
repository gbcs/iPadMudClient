//
//  MudAddButtonAction.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudButtonsDetail.h"

@interface MudAddButtonAction : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableview;
	NSObject *parentView;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSObject *parentView;


@end
 