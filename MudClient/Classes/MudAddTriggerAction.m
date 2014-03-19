//
//  MudAddTriggerAction.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudAddTriggerAction.h"
#import "MudDataMacros.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"

@implementation MudAddTriggerAction

@synthesize tableview;

- (void)selectNoneAsMacro:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudTriggersDetail *detailView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

	detailView.trigmacro = nil;
	
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popViewControllerAnimated:YES];
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	return [session.macros count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		//cell.editingAccessoryType = UITableViewCellEditingStyleNone;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
    }
    
	MudDataMacros *event = (MudDataMacros *)[session.macros objectAtIndex:indexPath.row];	
	
	cell.textLabel.text =  [event title];
	
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50.0f;
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
		contentSize.height = 620;;
	}
    self.preferredContentSize = contentSize;
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
		
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudTriggersDetail *detailView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	[detailView setTrigmacro:[session.macros objectAtIndex:indexPath.row]];
	
	[myAppDelegate pointToDefaultKeyboardResponder];
	[detailView.tableview reloadData];
	[self.navigationController popViewControllerAnimated:YES];

}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"None" style:UIBarButtonItemStylePlain target:self action:@selector(selectNoneAsMacro:)];
	self.navigationItem.rightBarButtonItem = rb;
	
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	[self.navigationItem setTitle:@"Associate Macro with Trigger"];
	tc.delegate = self;
	tc.dataSource = self;
	
	self.tableview = tc;
	
	[self.view addSubview:tc];
	
	
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
