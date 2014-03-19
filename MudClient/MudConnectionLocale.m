//
//  MudConnectionLocale.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MudConnectionLocale.h"
#import "NewConnectionDetail.h"

@implementation MudConnectionLocale


@synthesize tableview;
@synthesize localeIdentifierList;

- (void)viewWillAppear:(BOOL)animated {
	self.navigationController.toolbarHidden = YES;
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
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	return [self.localeIdentifierList count];
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = nil;

	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
	}
	
	cell.textLabel.text = [self.localeIdentifierList objectAtIndex:indexPath.row];
	
 	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	NewConnectionDetail *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
    [ma updateLocaleStr:[self.localeIdentifierList objectAtIndex:indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
} 

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.navigationItem.title = @"Select a Locale";
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	NSArray *tmpArray = [NSLocale availableLocaleIdentifiers];
	
	self.localeIdentifierList  = [tmpArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	
	
	
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
