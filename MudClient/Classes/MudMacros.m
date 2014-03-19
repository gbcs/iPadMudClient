//
//  MudMacros.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 7/31/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacros.h"
#import "MudDataMacros.h"

#import "MudMacrosName.h"
#import "MudClientIpad4AppDelegate.h"


@implementation MudMacros

@synthesize tv, element;

-(void)SaveEditedRecord {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[myAppDelegate saveCoreData];	
	
	[[myAppDelegate getActiveSessionRef] populateCoreDataArray:3];
	
	[self.tv reloadData];
}


-(void)AddButtonClicked {
	
	self.element = nil;

	MudMacrosName *uv = [[MudMacrosName alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return;
    }
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    int count = [session.macros count];
    
	if (count >0) {
        [self tableView:tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    } else {
        [self performSelector:@selector(AddButtonClicked) withObject:nil afterDelay:0.01];
    }
    
  
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 2;
	
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0 : 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return (section == 0) ? @"" : @"Options";
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.section == 1) {
        return 35;
    }
    
	return 40.0f;	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 1;
    }
    
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    int count = [session.macros count];
    
    noEntriesCurrentlyExists = (count == 0) ? YES : NO;
    
    if (count < 1) {
        count = 1;
    }
    
	return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    
    UITableViewCell *cell = nil;
    
    if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        prefixChar = [[UITextField alloc] initWithFrame:CGRectMake(0,9,20,22)];
        prefixChar.keyboardAppearance = UIKeyboardAppearanceDark;
        prefixChar.backgroundColor = [UIColor lightGrayColor];
        
        prefixChar.text = [session.settings macroPrefix];
        
        cell.accessoryView = prefixChar;
        cell.textLabel.text = @"Macro Command Prefix Character:";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.editingAccessoryType = UITableViewCellEditingStyleNone;
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell2"];
        }
        cell.accessoryView = nil;
        cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        if (noEntriesCurrentlyExists) {
            cell.textLabel.text = @"Tap to Add a Macro";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            MudDataMacros *event = (MudDataMacros *)[session.macros objectAtIndex:indexPath.row];	
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@", [event title]];
        }
    } 
    
	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    if ([session.macros count]<1) {
        return NO;
    }
    
    if (indexPath.section >0) {
        return NO;
    }
    
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [[[myAppDelegate getActiveSessionRef] macros] objectAtIndex:indexPath.row];
		[myAppDelegate.context deleteObject:eventToDelete];
		
		// Update the array and table view.
        [[[myAppDelegate getActiveSessionRef] macros] removeObjectAtIndex:indexPath.row];
        
        int count = [[myAppDelegate getActiveSessionRef].macros count];
        if (count > 0) {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        } else {
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];  
        }

		[myAppDelegate saveCoreData];	
    }   
}


-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudDataMacros *event = (MudDataMacros *)[[[myAppDelegate getActiveSessionRef] macros] objectAtIndex:indexPath.row];
	self.element = event;
	
	MudMacrosDetail *uv = [[MudMacrosDetail alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];
	
}

-(void)viewWillDisappear:(BOOL)animated {
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];

    
    if (prefixChar.text && ([prefixChar.text length] ==1)) {
        [session.settings setMacroPrefix:prefixChar.text];
        [myAppDelegate saveCoreData];
        
    }     
    
    [super viewWillDisappear:animated];
}
-(void)helpClicked:(id)sender {
    [[SettingsTool settings] displayHelpForSection:kHelpSectionMacro];
}
- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Macros";
		
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(helpClicked:)];
	
		
	
	self.tv.dataSource = self;
	self.tv.delegate = self;
	[self.view addSubview:self.tv];
	
	self.navigationController.toolbarHidden = YES;
	
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddButtonClicked)];
	rb.enabled = YES;
	//self.toolbarItems = [NSArray arrayWithObject:rb];
	self.navigationItem.rightBarButtonItem = rb;
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
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    self.view = nil;
	
	
	    ;
	
}



@end
