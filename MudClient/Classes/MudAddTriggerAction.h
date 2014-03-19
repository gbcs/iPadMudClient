//
//  MudAddTriggerAction.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudTriggersDetail.h"
#import "MudDataTriggers.h"
#import "MudDataMacros.h"
	
	
@interface MudAddTriggerAction : UIViewController  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
	UITableView *tableview;
}
@property (nonatomic, strong) UITableView *tableview;
- (void)selectNoneAsMacro:(id)sender;
@end
