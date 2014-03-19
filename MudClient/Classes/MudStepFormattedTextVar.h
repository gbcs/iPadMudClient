//
//  MudStepFormattedTextVar.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudStepFormattedTextVar : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tv;
}

@property (nonatomic, strong) UITableView *tv;

@end
