//
//  MudTranscriptDetail.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MudDataSessions.h"
#import "MudDataSessionData.h"
#import "MudClientIpad4AppDelegate.h"


@interface MudTranscriptDetail : UIViewController  <UITextViewDelegate, UIGestureRecognizerDelegate> {
	NSMutableArray *acquireArray;
	MudDataSessions *logSession;
	UITextView *transcriptText;
	UIBarButtonItem *pageView;
}


@property (nonatomic, strong) NSMutableArray *acquireArray;
@property (nonatomic, strong) MudDataSessions *logSession;
@property (nonatomic, strong) UIBarButtonItem *pageView;
@property (nonatomic) int currentPage;
@property (nonatomic, strong) UITextView *transcriptView;

-(void)PullRecordsforList:(int)pageNum;
- (void)populateTranscriptPage;

@end
