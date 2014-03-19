//
//  NewConnectionMudList.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewConnectionMudList.h"
#import "MudAddConnections.h"
#import "MudClientIpad4AppDelegate.h"

@implementation NewConnectionMudList

@synthesize tableview, which;

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
		contentSize.height = 620;;
		self.preferredContentSize = contentSize;
	}	
	[self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	return 1;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = nil;
	NSString *labeltext = nil;
	
	switch (indexPath.section) {
		case 0:
		labeltext = @"The MUD Connector";
			break;
		case 1:
			labeltext = @"Top MUD Sites";
			break;
		case 2:
			labeltext = @"MudVerse";
			break;
	}

	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
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
	

    switch (indexPath.section) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mudconnect.com/"]];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.topmudsites.com/"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mudverse.com/"]];
            break;
    }
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.navigationItem.title = @"MUD Listing Websites";
	
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
    
}


@end
