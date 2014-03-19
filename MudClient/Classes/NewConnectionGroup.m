//
//  NewConnectionGroup.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewConnectionGroup.h"
#import "NewConnectionDetail.h"
#import "MudAddConnections.h"
#import "NewConnectionMudList.h"
#import "NewConnectionMudsByName.h"
#import "MudClientIpad4AppDelegate.h"

@implementation NewConnectionGroup

@synthesize tableview;


- (void)viewWillAppear:(BOOL)animated {
	
	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tableview.frame = CGRectMake(0,0,560,270);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 290;
		self.preferredContentSize = contentSize;
	} else {
		self.tableview.frame = CGRectMake(0,0,560,600);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 620;
		self.preferredContentSize = contentSize;
	}
	[self.tableview reloadData];
	[self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	switch (section) {
			
		case 2:
		case 3:
		case 4:
			return 1;
	}
	
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	int section = indexPath.section;
	
	
	UITableViewCell *cell = nil;
	NSString *labeltext = nil;
	
	if (section == 2) {
		labeltext = @"Select a MUD by Name";
	} else	if (section == 3) {
		labeltext = @"Browse MUD Listing Websites";
	} else if (section == 4 ) {
		labeltext = @"Enter Server and Character Information";
	}
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
	}
	
	cell.textLabel.text = labeltext;
	
 	return cell;
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];

	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudAddConnections *connectionView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	
	switch (indexPath.section) {
		case 2:
		{
			NewConnectionMudsByName *uv = [[NewConnectionMudsByName alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
		}	
			break;
		case 3:
		{			
			NewConnectionMudList *uv = [[NewConnectionMudList alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
			
		}	
			break;
		case 4:
		{	
			connectionView.element = nil;
			
			NewConnectionDetail *uv = [[NewConnectionDetail alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
		}	
			break;
	}
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.navigationItem.title = @"Create a Character";
		
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	tc.delegate = self;
	tc.dataSource = self;
	
	
	[self.view addSubview:tc];
	
	self.tableview = tc;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	self.view = nil;
        ;
}


@end

