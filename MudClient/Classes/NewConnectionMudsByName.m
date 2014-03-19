//
//  NewConnectionMudsByName.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewConnectionMudsByName.h"
#import "MudAddConnections.h"
#import "NewConnectionDetail.h"
#import "MudClientIpad4AppDelegate.h"

@implementation NewConnectionMudsByName


@synthesize tableview, mudList, mudListHost, mudListPort, sBar;

- (void)viewWillAppear:(BOOL)animated {

	
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tableview.frame = CGRectMake(0,50,560,170);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 290;
		self.preferredContentSize = contentSize;
		creditLabel.frame = CGRectMake(0,217,560,20);
	} else {
		self.tableview.frame = CGRectMake(0,50,560,510);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 620;;
		self.preferredContentSize = contentSize;
		creditLabel.frame = CGRectMake(0,558,560,20);
	}	
	
	[self.sBar setText:@""];
	[self.tableview reloadData];

	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	return [self.mudList count];
	
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
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	cell.textLabel.text = [self.mudList objectAtIndex:indexPath.row];
	
 	return cell;
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.sBar becomeFirstResponder];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudAddConnections *connectionView = [self.navigationController.viewControllers objectAtIndex:0];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	//NSLog(@"%@ %@ %@", [self.mudList objectAtIndex:indexPath.row],  [self.mudListHost objectAtIndex:indexPath.row],  [self.mudListPort objectAtIndex:indexPath.row]);
	
	
	MudDataCharacters *char1 = (MudDataCharacters *)[NSEntityDescription insertNewObjectForEntityForName:@"MudDataCharacters" inManagedObjectContext:myAppDelegate.context];
	char1.serverTitle = [self.mudList objectAtIndex:indexPath.row];
	char1.hostName = [self.mudListHost objectAtIndex:indexPath.row];
	char1.tcpPort = [NSNumber numberWithInt:[[self.mudListPort objectAtIndex:indexPath.row] intValue]];
	char1.slotID = [NSNumber numberWithInt:[myAppDelegate findNewSlotID]] ;
	char1.encoding = @0;
    char1.font = @"Menlo-Regular";
    char1.fontSize = [NSNumber numberWithFloat:14.5];
    char1.lang = @"en_US";

	connectionView.element = char1;
	
	[connectionView SaveAndUpdateView];
	
	[myAppDelegate createInitialCharacterData:char1];
	
	[connectionView SaveAndUpdateView];
	
	NewConnectionDetail *uv = [[NewConnectionDetail alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];


}

- (void)loadMUDList:(NSString *)searchPrefix {
	
	NSString *sPrefix = [searchPrefix lowercaseString];
	
	//static NSString *regexString = @"(?:\r\n|[\n\v\f\r\302\205\\p{Zl}\\p{Zp}])";
	
	self.mudList = [[NSMutableArray alloc] init];
	self.mudListHost = [[NSMutableArray alloc] init];
	self.mudListPort = [[NSMutableArray alloc] init];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mud_list_12" ofType:@"txt"];  
	
	if (filePath) {  
		NSError *error;
		NSString *myText = [NSString stringWithContentsOfFile:filePath encoding:NSStringEncodingConversionAllowLossy error:&error];
		
		if (myText) {
            NSArray *lines =[myText componentsSeparatedByString:@"\n"];
            
			if ( (!lines) | ([lines count] <1)) {
				return;
			}
			
			//NSLog(@"Lines found: %d", [lines count]);
			int count=0;
			for (NSString *line in lines) {
                //NSLog(@"Line is:%@", line);
				NSArray *components = [line componentsSeparatedByString:@"~"];
				if ( (!components) | ([components count]<3) ) {
					NSLog(@"Bad Entry:%@", line);
				}  else {
					NSString *mudName = [(NSString *)[components objectAtIndex:0] lowercaseString];
					if ( sPrefix && ([sPrefix length]>0) ) {
						//attempt a restriction
						if  (![mudName hasPrefix:sPrefix])
							continue;
					}
						
					[self.mudList insertObject:[components objectAtIndex:0] atIndex:count];
					[self.mudListHost insertObject:[components objectAtIndex:1] atIndex:count];
					[self.mudListPort insertObject:[components objectAtIndex:2] atIndex:count];
				}
				count++;
			}
		}  
	}  
	[self.tableview reloadData];
}


- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.navigationItem.title = @"Select a MUD by Name";
	

	self.sBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,560,50)];
	[self.sBar setShowsCancelButton:NO animated:NO];
	[self.sBar setShowsSearchResultsButton:NO];
	
	self.sBar.delegate = self;
	
	[self.view addSubview:self.sBar];
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,50,560,180) style:UITableViewStylePlain];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	[self loadMUDList:nil];
	
	tc.delegate = self;
	tc.dataSource = self;
	
	[tc setOpaque:YES];
	[self.view addSubview:tc];
	
	self.tableview = tc;
	
	
	creditLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	creditLabel.text = @"MUD Listings courtesy of The Mud Connector                                           http://www.mudconnect.com/";
	creditLabel.textAlignment = NSTextAlignmentLeft;
	creditLabel.font = [UIFont boldSystemFontOfSize:12];
	creditLabel.textColor = [UIColor whiteColor];
	creditLabel.backgroundColor = [UIColor clearColor];
	creditLabel.numberOfLines = 2;
	[self.view addSubview:creditLabel];
	
}




- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar

{
	
	// only show the status bar's cancel button while in edit mode
	
	//sBar.showsCancelButton = YES;
	
	sBar.autocorrectionType = UITextAutocorrectionTypeNo;
	
	// flush the previous search content
	
	[self loadMUDList:nil];
	
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar

{
	
	//sBar.showsCancelButton = NO;
	
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText

{
	
	
	[self loadMUDList:searchText];	
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar

{
	
		
}


// called when Search (in our case "Done") button pressed

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar

{
	
	//[searchBar resignFirstResponder];
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}




@end

