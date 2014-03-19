//
//  MudAddButtonAction.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudAddButtonAction.h"
#import "MudButtonRunMacro.h"
#import "MudButtonSendText.h"
#import "MudButtonsDetail.h"
#import "MudClientIpad4AppDelegate.h"


@implementation MudAddButtonAction

@synthesize tableview;
@synthesize  parentView;


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

	NSString *labeltext = nil;
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	
	switch (indexPath.section) {
		case 0:
			labeltext = @"Send Text";
			break;
		case 1:
			labeltext = @"Run Macro";
			break;
		case 2:
			labeltext = @"Append to Current Command";
			break;
	}			
	
	cell.textLabel.text = labeltext;

 	return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	switch (indexPath.section) {
		case 0: 
		case 2:
		{
			MudButtonSendText *uv = [[MudButtonSendText alloc] init];
			if (indexPath.section == 2) {
				uv.appendFlag = YES;
			} else {
				uv.appendFlag = NO;
			}
			[self.navigationController pushViewController:uv animated:YES];
		}
			break;
		case 1:
		{
			MudButtonRunMacro *uv = [[MudButtonRunMacro alloc] init];
			[self.navigationController pushViewController:uv animated:YES];
		}
			break;
	}
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	MudButtonsDetail *detailView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	[self.navigationItem setTitle:[NSString stringWithFormat:@"Layer %d", detailView.editLayer]];
	tc.delegate = self;
	tc.dataSource = self;
	
	
	
	[self.view addSubview:tc];
	
	self.tableview = tc;
}

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




@end
