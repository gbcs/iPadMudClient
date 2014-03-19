//
//  SpeedwalkingList.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/6/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpeedwalkingList.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"

@implementation SpeedwalkingList

@synthesize tv, element;

-(void)SaveEditedRecord {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	[myAppDelegate saveCoreData];	
	
	[session populateCoreDataArray:4];
	
	[self.tv reloadData];
    
}


-(void)AddButtonClicked {
	
	self.element = nil;
	
	SpeedwalkingDetail *uv = [[SpeedwalkingDetail alloc] init];
    
	[self.navigationController pushViewController:uv animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.section == 1) {
        return 35;
    }
    
	return 40.0f;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return;
    }
    
    
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    MudSession *session = [myAppDelegate getActiveSessionRef];	
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([session.speedwalking count]>0) {
        MudDataSpeedwalking *event = (MudDataSpeedwalking *)[session.speedwalking objectAtIndex:indexPath.row];	
        [session performSelector:@selector(splitAndSendSpeedwalkPath:) withObject:event.path afterDelay:0.01];
        [myAppDelegate dismissPopovers];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    if (section == 1) {
        return 2;
    }
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    int count = [session.speedwalking count];
    
    noEntriesCurrentlyExists = (count == 0) ? YES : NO;
    
    if (count < 1) {
        count = 1;
    }
    
	return count;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    
    if (prefixChar.text && ([prefixChar.text length] ==1)) {
        [session.settings setSpeedwalkPrefix:prefixChar.text];
    }    
    
    if (seperatorChar.text && ([seperatorChar.text length] ==1)) {
        [session.settings setSpeedwalkSeperator:seperatorChar.text];
    }
    
    [myAppDelegate saveCoreData];
    [super viewWillDisappear:animated];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    if ([session.speedwalking count]<1) {
        return NO;
    }
    
    if (indexPath.section >0) {
        return NO;
    }
    
    return YES;
    
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
        
        UITextField *tf = nil;
         
        tf = [[UITextField alloc] initWithFrame:CGRectMake(0,9,20,22)];
        tf.keyboardAppearance = UIKeyboardAppearanceDark;
        cell.accessoryView = tf;
        if (indexPath.row == 0) { 
            prefixChar = tf;
            cell.textLabel.text = @"Command Prefix Character:";
            tf.text = [session.settings speedwalkPrefix];
        } else if (indexPath.row == 1) { 
            seperatorChar = tf;
            cell.textLabel.text = @"Character Used to Seperate Speedwalking Commands:";
            tf.text = [session.settings speedwalkSeperator];
        }
       
        tf.backgroundColor = [UIColor lightGrayColor];
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
            cell.textLabel.text = @"Tap to Add a Speedwalking Path";
            cell.accessoryType = UITableViewCellAccessoryNone;
        } else {
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            MudDataSpeedwalking *event = (MudDataSpeedwalking *)[session.speedwalking objectAtIndex:indexPath.row];	
            cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@%@", [event key], [event path] ? @"" : @" (empty)"];
        }
    } 
    
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
		NSManagedObject *eventToDelete = [session.speedwalking objectAtIndex:indexPath.row];
		[myAppDelegate.context deleteObject:eventToDelete];
		
		// Update the array and table view.
        [session.speedwalking removeObjectAtIndex:indexPath.row];
        
        int count = [session.speedwalking count];
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
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
	MudDataSpeedwalking *event = (MudDataSpeedwalking *)[session.speedwalking objectAtIndex:indexPath.row];
	
	self.element = event;
	
	SpeedwalkingDetail *uv = [[SpeedwalkingDetail alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (section == 0) ? 0 : 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return (section == 0) ? @"" : @"Options";
    
}
-(void)helpClicked:(id)sender {
    [[SettingsTool settings] displayHelpForSection:kHelpSectionSpeedwalking];
}
- (void)loadView {
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Help" style:UIBarButtonItemStylePlain target:self action:@selector(helpClicked:)];
	
	self.navigationItem.title = @"Speedwalking Paths";
	
	self.navigationController.toolbarHidden = YES;
	
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddButtonClicked)];
	rb.enabled = YES;
	//self.toolbarItems = [NSArray arrayWithObject:rb];
	
    self.navigationItem.rightBarButtonItem = rb;
    
	self.tv = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	self.tv.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	tv.dataSource = self;
	tv.delegate = self;
	
	
	[self.view addSubview:tv];
	
    /*
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10,558,540,20)];
	label1.textAlignment = NSTextAlignmentLeft;
	label1.font = [UIFont boldSystemFontOfSize:12];
	label1.textColor = [UIColor whiteColor];
	label1.backgroundColor = [UIColor clearColor];
	label1.numberOfLines = 2;
	[label1 setText:@"Note: You may run speedwalk paths by typing a period (.) before the name, e.g., .home"]; 
	[label1 setOpaque:YES];
	[self.view addSubview:label1];
	noteLabel = label1;
     */
    
	
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
