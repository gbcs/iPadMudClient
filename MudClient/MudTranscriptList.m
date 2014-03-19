//
//  MudTranscriptList.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudTranscriptList.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudSession.h"
#import "MudDataSessions.h"
#import "MudClientIpad4ViewController.h"
#import "MudTranscriptDetail.h"
#import "MudInputFooter.h"

@implementation MudTranscriptList


@synthesize tv, sessionArray;


-(void)viewWillAppear:(BOOL)animated {
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	
	CGSize contentSize;
	
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		contentSize.height = 250;
		self.tv.frame = CGRectMake(0,0,560,290);
		
	} else {
		contentSize.height = 620;;
		self.tv.frame = CGRectMake(0,0,560,600);
		
	}
	
	
	contentSize.width = 560;
	self.preferredContentSize = contentSize;
	self.navigationController.toolbarHidden = YES;
	[self PullRecordsforList];
	[self.tv reloadData];
}

-(void)PullRecordsforList {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudClientIpad4ViewController *displayView = myAppDelegate.viewController;

	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataSessions" inManagedObjectContext:myAppDelegate.context];
	[request setEntity:entity];
	
	MudDataCharacters *tmpChar = nil;
	switch (displayView.MudActiveIndex) {
		case 1:
			tmpChar = displayView.mudSession1.connectionData;
			break;
		case 2:
			tmpChar = displayView.mudSession2.connectionData;
			break;
		case 3:
			tmpChar =  displayView.mudSession3.connectionData;
			break;
		case 4:
			tmpChar = displayView.mudSession4.connectionData;
			break;
	}
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"character=%@", tmpChar];
	[request setPredicate:predicate];	
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[myAppDelegate.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	self.sessionArray = mutableFetchResults;
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	//MudClientIpad4ViewController *displayView = myAppDelegate.viewController;
	
	MudDataSessions *logSession = [self.sessionArray objectAtIndex:indexPath.row];
	
	
	MudTranscriptDetail *logDetail = [[MudTranscriptDetail alloc] init];
	logDetail.logSession = logSession;
	logDetail.title = [NSString stringWithFormat:@"%@", [logSession startDate]];
	[self.navigationController pushViewController:logDetail animated:YES];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 1;
	
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
   
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.sessionArray count];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
				
		MudSession *session = [myAppDelegate getActiveSessionRef];
		MudDataSessions *sessionToDelete = (MudDataSessions *)[sessionArray objectAtIndex:indexPath.row];
		if (session.sessionRecord == sessionToDelete)  {
			return;
		}
		
        // Delete the managed object at the given index path.
		
		[myAppDelegate.context deleteObject:sessionToDelete];
		
		
		[myAppDelegate saveCoreData];	
	
		[self PullRecordsforList];
		[tableView reloadData];
		
    }   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
	MudDataSessions *logSession = (MudDataSessions *)[self.sessionArray objectAtIndex:indexPath.row];
	
	NSString *activeFlag = nil;
	
	if (logSession == session.sessionRecord) {
		//cell.editingAccessoryType = UITableViewCellEditingStyleNone;
		activeFlag = @"(active)";
	} else {
		//cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
		activeFlag = @"";
	}
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [logSession startDate], activeFlag];
	
	return cell;
}





- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	
	self.navigationItem.title = @"Session Transcript(s)";
	
	self.navigationController.toolbarHidden = YES;
	
		
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	
	UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearHistoryButtonClicked:)];
	self.navigationItem.rightBarButtonItem = lb;
	
	tv.dataSource = self;
	tv.delegate = self;
	
	
	[self.view addSubview:tv];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
				 
	if (buttonIndex == 0) {
		
		for (NSManagedObject *object in self.sessionArray) {
			if ((MudDataSessions *)object != session.sessionRecord) {
				[myAppDelegate.context deleteObject:object];
			}
		}

		[myAppDelegate saveCoreData];			
		[self PullRecordsforList];
		[self.tv reloadData];
	}
	
}

-(void)clearHistoryButtonClicked:(id)sender {
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:@"Clear ALL Transcripts"
								 otherButtonTitles:nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
	
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}





@end

