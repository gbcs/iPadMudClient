//
//  MudTranscriptDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudTranscriptDetail.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"


@implementation MudTranscriptDetail

@synthesize logSession;

@synthesize acquireArray;

@synthesize pageView, currentPage, transcriptView;

- (void)goLeft:(id)sender {
	if (self.currentPage <2) 
		return;
	
	self.currentPage--;
	
	[self PullRecordsforList:self.currentPage];
	[self populateTranscriptPage];
}

- (void)goRight:(id)sender {
			
	self.currentPage++;
	
	[self PullRecordsforList:self.currentPage];
	[self populateTranscriptPage];
}



- (void)populateTranscriptPage {
	NSMutableString *t = [NSMutableString stringWithString:@""];
	int count = [self.acquireArray count];
	
	for (int x=0;x<count;x++) {
		MudDataSessionData *sData =[self.acquireArray objectAtIndex:x];
		[t appendString:[NSString stringWithFormat:@"%@\n", [sData line]]];	
	}
	self.transcriptView.text = t;
	
	
	
	[self.pageView setTitle:[NSString stringWithFormat:@"Page %d", self.currentPage]];
}


- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectZero];
	
	
	self.navigationController.toolbarHidden = NO;
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	CGSize contentSize;
	
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.view.frame  = CGRectMake(0,0,640,640);
				contentSize.height = 640;
		contentSize.width = 640;
	} else {
		self.view.frame = CGRectMake(0,0,640,640);
		contentSize.height = 640;
		contentSize.width = 640;
	}
	
	self.preferredContentSize = contentSize;
	self.title = @"Transcript";
	
	
	UITextView *label1 = [[UITextView alloc] initWithFrame:CGRectMake(0,0,560,640)];
    label1.keyboardAppearance = UIKeyboardAppearanceDark;
	[label1 setFont:[UIFont systemFontOfSize:12.0f]];
    label1.backgroundColor = [UIColor blackColor];
    label1.textColor = [UIColor whiteColor];
	label1.delegate = self;
	
	[self PullRecordsforList:1];
	
	[self.view addSubview:label1];
	
	self.transcriptView = label1;
	
		
	UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goLeft:)];
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(goRight:)];
	UIBarButtonItem *tv = [[UIBarButtonItem alloc] initWithTitle:@"Page 1" style:UIBarButtonItemStylePlain target:nil action:nil];
	UIBarButtonItem *middle1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	UIBarButtonItem *middle2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	self.toolbarItems = [NSArray arrayWithObjects:lb, middle1, tv, middle2, rb, nil];
	self.pageView = tv;

	[self populateTranscriptPage];

}


-(void)PullRecordsforList:(int)pageNum {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];	
	[NSFetchedResultsController deleteCacheWithName:@"Root"];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataSessionData" inManagedObjectContext:myAppDelegate.context];
	[request setEntity:entity];
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"session=%@", logSession];
	

	[request setPredicate:predicate];
	 
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	static int pageSize = 40;
	int fetchOffset = (pageNum-1) *pageSize;
	
	[request setFetchLimit:pageSize];
	[request setFetchOffset:fetchOffset];
	
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[myAppDelegate.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	

	//NSLog(@"page:%d  fetchOffset:%d  FetchLimit:%d", pageNum, fetchOffset, pageSize);
	
	self.acquireArray = mutableFetchResults;
	
	self.currentPage = pageNum;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}




@end

