//
//  MudAliases.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import "MudAliases.h"
#import "MudAliasesDetail.h"
#import "MudDataAliases.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"

@implementation MudAliases

@synthesize tv, element;

-(void)SaveEditedRecord {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	[myAppDelegate saveCoreData];
	
	[session populateCoreDataArray:6];
	
	[self.tv reloadData];
	
    
}


-(void)AddButtonClicked {
	
	self.element = nil;
	
	MudAliasesDetail *uv = [[MudAliasesDetail alloc] init];
    
	[self.navigationController pushViewController:uv animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
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
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
	return [session.aliases count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
	
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		//cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
		cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
	MudDataAliases *event = (MudDataAliases *)[session.aliases objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ = %@", [event title], [event value] ? [event value] : @""];
	
	return cell;
}


/**
 Handle deletion of an event.
 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [session.aliases objectAtIndex:indexPath.row];
		[myAppDelegate.context deleteObject:eventToDelete];
		
		// Update the array and table view.
        [session.aliases removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		[myAppDelegate saveCoreData];
    }
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
	MudDataAliases *event = (MudDataAliases *)[session.aliases objectAtIndex:indexPath.row];
	
	self.element = event;
	
	MudAliasesDetail *uv = [[MudAliasesDetail alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];
	
}
-(void)helpClicked:(id)sender {
    [[SettingsTool settings] displayHelpForSection:kHelpSectionAlias];
}

- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	
	self.navigationItem.title = @"Aliases";
	
	self.navigationController.toolbarHidden = YES;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(helpClicked:)];
	
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddButtonClicked)];
	rb.enabled = YES;
	//self.toolbarItems = [NSArray arrayWithObject:rb];
	
    self.navigationItem.rightBarButtonItem = rb;
    
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
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





@end