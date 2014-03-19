    //
//  MudAbout.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/30/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudAbout.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudAbout

@synthesize tv;


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 44.0f;	
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Website";
		case 1:
			return @"Copyright";
			break;
		case 2:
			return @"Version";
		case 3:
			return @"Credits";
	}
	
	return nil;
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 4;
	
}


- (void)viewWillAppear:(BOOL)animated {
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tv.frame = CGRectMake(0,0,560,300);	
	} else {
		self.tv.frame = CGRectMake(0,0,560,570);	
	}
	[self.tv reloadData];		
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    CGSize contentSize;
    contentSize.width = 560;
    contentSize.height = 620;
    self.contentSizeForViewInPopover = contentSize;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	
	if (section == 0) 
		return 1;

	if (section == 1) 
		return 1;
	
	if (section == 2) 
		return 1;
	
	if (section == 3) 
		return 4;
	
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell.editingAccessoryType = UITableViewCellEditingStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    }
    cell.detailTextLabel.text = @"";

	if (indexPath.section == 0) {
		cell.textLabel.text = @"http://ipadmudclient.com/";
	} else if (indexPath.section == 1 ) {
		cell.textLabel.text = @"Copyright 2010-2011 Gary Barnett";
	} else if (indexPath.section == 2) {
		cell.textLabel.text = @"1.4.0";	
	} else if (indexPath.section == 3 ) {
		switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"MUD Listings courtesy of: The MUD Connector.";
				cell.detailTextLabel.text = @"http://www.mudconnect.com/";
				break;
			case 1:
				cell.textLabel.text = @"Icons";
				cell.detailTextLabel.text = @"http://www.iconfinder.com/";
				break;
			case 2:
				cell.textLabel.text = @"libtelnet";
				cell.detailTextLabel.text = @"http://github.com/elanthis/libtelnet/";
				break;
			case 3:
				cell.textLabel.text = @"RegexKitLite";
				cell.detailTextLabel.text = @"http://regexkit.sourceforge.net/RegexKitLite/";
				break;	
		}
	}
	 
	
	return cell;
}



- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	
	self.navigationItem.title = @"MUD Client for iPad";
	
	self.navigationController.toolbarHidden = YES;
	
	
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,620) style:UITableViewStyleGrouped];
	
	tv.dataSource = self;
	tv.delegate = self;
	
	[self.view addSubview:tv];
	
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
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
    [super dealloc];
}



@end

