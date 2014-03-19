//
//  MudAddConnections.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudAddConnections.h"
#import "MudDataCharacters.h"
#import "NewConnectionDetail.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudDataCharacters.h"
#import "NewConnectionGroup.h"
@implementation MudAddConnections 
@synthesize tv;

@synthesize context;
@synthesize iPath;
@synthesize topController;

@synthesize element;
 

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.toolbarHidden = YES;
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tv.frame = CGRectMake(0,0,560,270);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 290;
		self.preferredContentSize = contentSize;
	} else {
		self.tv.frame = CGRectMake(0,0,560,600);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 620;;
		self.preferredContentSize = contentSize;
	}
	[self.tv reloadData];
	
}


- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {

}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
	return YES;
}

-(void)FindMUDButtonClicked {

}

-(void)SaveAndUpdateView {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[myAppDelegate saveCoreData];	
	
	[myAppDelegate PullRecordsforCharList];
	[self.tv reloadData];
}

-(void)AddButtonClicked {

	self.element = nil;
	
	NewConnectionGroup *uv = [[NewConnectionGroup alloc] init];

	[self.navigationController pushViewController:uv animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40.0f;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudDataCharacters *event = (MudDataCharacters *)[myAppDelegate.mudCharArray objectAtIndex:indexPath.row];
	[self.topController connectionRequest:event];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
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
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];

	return [myAppDelegate.mudCharArray count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudDataCharacters *event = (MudDataCharacters *)[myAppDelegate.mudCharArray objectAtIndex:indexPath.row];	
	
	BOOL returnVal = YES;
	
	if (self.topController.mudSession1 && (self.topController.mudSession1.connectionData == event)) {
		returnVal = NO;
	} else if (self.topController.mudSession2 && (self.topController.mudSession2.connectionData == event)) {
		returnVal = NO;
	} else if (self.topController.mudSession3 && (self.topController.mudSession3.connectionData == event)) {
		returnVal = NO;
	} else if (self.topController.mudSession4 && (self.topController.mudSession4.connectionData == event)) {
		returnVal = NO;
	}
	
	return returnVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
	MudDataCharacters *event = (MudDataCharacters *)[myAppDelegate.mudCharArray objectAtIndex:indexPath.row];	
	
	NSString *charName = [event characterName];
	
	if (charName && ([charName length])) {
		cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@@%@", [event characterName],[event serverTitle]];
	} else {
		cell.textLabel.text = [event serverTitle];
		//cell.detailTextLabel.text = [[[NSString alloc] initWithFormat:@"%@:%@", [event hostName],[event tcpPort]] autorelease];
	} 
	
	return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [myAppDelegate.mudCharArray objectAtIndex:indexPath.row];
		[self.context deleteObject:eventToDelete];
		
		// Update the array and table view.
        [myAppDelegate.mudCharArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		[myAppDelegate saveCoreData];	
    }   
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudDataCharacters *event = (MudDataCharacters *)[myAppDelegate.mudCharArray objectAtIndex:indexPath.row];
	
	self.element = event;
	self.iPath = indexPath;
	 
	
	NewConnectionDetail *uv = [[NewConnectionDetail alloc] init];

	[self.navigationController pushViewController:uv animated:YES];
		
}

-(void)helpClicked:(id)sender {
    [[SettingsTool settings] displayHelpForSection:kHelpSectionAddCharacter];
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Characters";
	
	self.navigationController.toolbarHidden = YES;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(helpClicked:)];
	
	
	UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddButtonClicked)];
	lb.enabled = YES;
	
	//self.toolbarItems = [NSArray arrayWithObject:lb];
	
	self.navigationItem.rightBarButtonItem = lb;
	
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	

	self.tv.dataSource = self;
	self.tv.delegate = self;
	
	
	[self.view addSubview:self.tv];
	

}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
    [super viewDidLoad];
	[myAppDelegate PullRecordsforCharList];
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
   
}


@end
