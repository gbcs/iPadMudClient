//
//  MudAliasesSelectVariable.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import "MudAliasesSelectVariable.h"
#import "MudDataVariables.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudSession.h"
#import "MudClientIpad4ViewController.h"
#import "MudAliasesDetail.h"


@interface MudAliasesSelectVariable ()

@end


@implementation MudAliasesSelectVariable

@synthesize tv;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	[myAppDelegate.aliasDetail updateVariable:[session.variables objectAtIndex:indexPath.row]];
    
    [self.navigationController popViewControllerAnimated:YES];
     
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 2;
	
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	if (section == 0)
		return [session.variables count];
    
	return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
	MudDataVariables *event = (MudDataVariables *)[session.variables objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [event title];
	
	return cell;
}



- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	self.navigationItem.title = @"Select a Variable";
	  self.tv.autoresizingMask =UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	if ([session.variables count] <1) {
		UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(60,220,300,100)];
		label1.textAlignment = NSTextAlignmentCenter;
		label1.font = [UIFont boldSystemFontOfSize:17];
		label1.textColor = [UIColor blackColor];
		label1.backgroundColor = [UIColor clearColor];
		label1.numberOfLines = 30;
		[label1 setText:@"No variables currently exist.\r\n\r\nCreate a variable and return."];
		[self.view addSubview:label1];
	} else {
		self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
		
		
		tv.dataSource = self;
		tv.delegate = self;
		
		
		[self.view addSubview:tv];
		
	}
	
	
	
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