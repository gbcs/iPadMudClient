    //
//  MudPreviousCommands.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudPreviousCommands.h"
#import "MudDataPreviousCommands.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudPreviousCommands

@synthesize tv;


@synthesize mudPreviousCommandArray;


@synthesize topController;




-(void)clearHistoryButtonClicked:(id)sender {
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc]
								 initWithTitle:nil
								 delegate:self
								 cancelButtonTitle:@"Cancel"
								 destructiveButtonTitle:@"Clear Previous Command History"
								 otherButtonTitles:nil];
	
    popupQuery.actionSheetStyle = UIActionSheetStyleDefault;
    [popupQuery showInView:self.view];
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	//Confirmed
	
	if (buttonIndex == 0) {
		
		for (NSManagedObject *object in self.mudPreviousCommandArray) {
			[self.topController.context deleteObject:object];
		}
		MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
		//NSLog(@"%d", [self.mudPreviousCommandArray count]);
		[myAppDelegate saveCoreData];			
		[self PullRecordsforList];
		[self.tv reloadData];
	}
	
}



-(void)NewRecordTableviewUpdate {
	[self PullRecordsforList];
	[self.tv reloadData];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudDataPreviousCommands *event = (MudDataPreviousCommands *)[mudPreviousCommandArray objectAtIndex:indexPath.row];
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	
			
	[session sendLineToMud:[event commandText] fromUser:YES fromMacro:NO shallDisplay:NO LogPrevCommands:NO];
	
	[self.topController.mudPreviousCommandsPopoverController dismissPopoverAnimated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 1;
	
}

- (void)viewWillAppear:(BOOL)animated {
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tv.frame = CGRectMake(0,0,560,290);
		} else {
		self.tv.frame = CGRectMake(0,0,560,600);
	}
	[self.tv reloadData];
	self.navigationController.toolbarHidden = YES;
	self.navigationController.navigationBarHidden = NO;
	
	MudDataCharacters *selectedCharacter = nil;
	switch (self.topController.MudActiveIndex) {
		case 1:
			selectedCharacter = self.topController.mudSession1.connectionData;
			break;
		case 2:
			selectedCharacter = self.topController.mudSession2.connectionData;
			break;
		case 3:
			selectedCharacter=  self.topController.mudSession3.connectionData;
			break;
		case 4:
			selectedCharacter = self.topController.mudSession4.connectionData;
			break;
	}
	
	NSString *slotTitle;
	
	if ([[selectedCharacter characterName] length]) {
		slotTitle = [NSString stringWithFormat:@"%@", [selectedCharacter characterName]];
	} else if ([[selectedCharacter serverTitle] length]) {
		slotTitle = [NSString stringWithFormat:@"%@", [selectedCharacter serverTitle]];
	} else {
		slotTitle = @"Unnamed";
	}
	
	self.navigationItem.title = slotTitle;
	[self PullRecordsforList];
	[self.tv reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize contentSize;
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		contentSize.width = 560;
		contentSize.height = 290;
	} else {
		contentSize.width = 560;
		contentSize.height = 620;
	}
	
 
    self.preferredContentSize = contentSize;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	return [mudPreviousCommandArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		//cell.editingAccessoryType = UITableViewCellAEditingStyleDelete;
    }
    
	MudDataPreviousCommands *event = (MudDataPreviousCommands *)[mudPreviousCommandArray objectAtIndex:indexPath.row];	
	
	cell.textLabel.text =  [event commandText];
	
	return cell;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		MudDataPreviousCommands *eventToDelete = (MudDataPreviousCommands *)[mudPreviousCommandArray objectAtIndex:indexPath.row];
		[eventToDelete setShowNoMore:[NSNumber numberWithBool:YES]];
		
		[myAppDelegate saveCoreData];	
		
														 
		[self PullRecordsforList];
		[tableView reloadData];
		
    }   
}



- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	
	UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithTitle:@"Clear" style:UIBarButtonItemStyleDone target:self action:@selector(clearHistoryButtonClicked:)];
	self.navigationItem.rightBarButtonItem = lb;
	
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	tv.dataSource = self;
	tv.delegate = self;
	
	[self.view addSubview:tv];
	
}

-(void)PullRecordsforList {
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataPreviousCommands" inManagedObjectContext:self.topController.context];
	[request setEntity:entity];
	
	MudDataCharacters *tmpChar = nil;
	switch (self.topController.MudActiveIndex) {
		case 1:
			tmpChar = self.topController.mudSession1.connectionData;
			break;
		case 2:
			tmpChar = self.topController.mudSession2.connectionData;
			break;
		case 3:
			tmpChar =  self.topController.mudSession3.connectionData;
			break;
		case 4:
			tmpChar = self.topController.mudSession4.connectionData;
			break;
	}
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"slotID=%@ AND showNoMore=NO", tmpChar];
	[request setPredicate:predicate];	
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"commandText" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[self.topController.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	self.mudPreviousCommandArray = mutableFetchResults;

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	[self PullRecordsforList];
	
	
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


- (void)dealloc {
	
	self.view = nil;
	    ;
}



@end
