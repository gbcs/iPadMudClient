//
//  MudStepFormattedText.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudStepFormattedText: UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate> {
	UITableView *tableview;
	UITextView *formattedText;
	NSMutableArray *formatVariables;
	int selectedVariable;
	int delay;
}

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UITextView *formattedText;
@property (nonatomic, strong) NSMutableArray *formatVariables;
@property (nonatomic) int selectedVariable;
@property (nonatomic) int delay;

@end
