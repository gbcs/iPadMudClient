//
//  MudTranscriptList.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MudTranscriptList : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate> {
	UITableView *tv;
	NSMutableArray *sessionArray;
}

@property (nonatomic, strong) UITableView *tv;
@property (nonatomic, strong) NSMutableArray *sessionArray;

-(void)PullRecordsforList;

@end
