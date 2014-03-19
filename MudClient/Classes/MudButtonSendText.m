    //
//  MudButtonSendText.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudButtonSendText.h"
#import "ButtonPanel.h"
#import "MudButtonsDetail.h"
#import "MudAddButtonAction.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudButtonSendText

@synthesize tableview;
@synthesize  parentView;
@synthesize textView;
@synthesize appendFlag;



- (void)viewWillAppear:(BOOL)animated {
	
	self.tableview.frame = CGRectMake(0,0,560,320);
	CGSize contentSize;
	contentSize.width = 560;
	contentSize.height = 320;
	self.preferredContentSize = contentSize;
	
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	
	return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 1) {
		return 200;
	}
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	
	UITableViewCell *cell = nil;
	UITextView *tv = nil;
	
	MudAddButtonAction *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudButtonsDetail *detailView = (MudButtonsDetail *)ma.parentView;
	
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				cell.accessoryType = UITableViewCellAccessoryNone;
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				cell.textLabel.textAlignment = NSTextAlignmentCenter;
			}
			if (appendFlag) { 
				cell.textLabel.text = @"Append Text";
			} else {
				cell.textLabel.text = @"Send Text";
			}
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
				
				CGRect textViewFrame = CGRectMake(0.0, 0.0, cell.bounds.size.width, 200);
				tv = [[UITextView alloc] initWithFrame:textViewFrame];
                tv.keyboardAppearance = UIKeyboardAppearanceDark;tv.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                tv.spellCheckingType = UITextSpellCheckingTypeNo;
                tv.autocorrectionType = UITextAutocorrectionTypeNo;
                tv.autocapitalizationType = UITextAutocapitalizationTypeNone;
				tv.backgroundColor =[UIColor colorWithWhite:0.4 alpha:1.0];
                tv.textColor = [UIColor whiteColor];
				[tv setFont:[UIFont boldSystemFontOfSize:14]];
				
				self.textView = tv;
				
				[cell.contentView addSubview:self.textView];
				[self.textView becomeFirstResponder];
			}
			switch (detailView.editLayer) {
				case 1:
					[tv setText:[detailView.element layer1Action]];
					break;
				case 2:
					[tv setText:[detailView.element layer2Action]];
					break;
				case 3:
					[tv setText:[detailView.element layer3Action]];
					break;
			}
			break;
	}
	
 	return cell;
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	[self.textView becomeFirstResponder];
	
}

-(void)viewWillDisappear:(BOOL)animated {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		
}

- (void)saveEditedRecord:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudAddButtonAction *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudButtonsDetail *detailView = (MudButtonsDetail *)ma.parentView;
	
	switch (detailView.editLayer) {
		case 1:
			[detailView.element setLayer1Action:self.textView.text];
			[detailView.element setLayer1Macro:nil];
			[detailView.element setAppendFlag1:[NSNumber numberWithBool:appendFlag]];
			break;
		case 2:
			[detailView.element setLayer2Action:self.textView.text];
			[detailView.element setLayer2Macro:nil];
			[detailView.element setAppendFlag2:[NSNumber numberWithBool:appendFlag]];
			break;
		case 3:
			[detailView.element setLayer3Action:self.textView.text];
			[detailView.element setLayer3Macro:nil];
			[detailView.element setAppendFlag3:[NSNumber numberWithBool:appendFlag]];
			break;
	}
	
	[detailView.tableview reloadData];
			 
	[myAppDelegate saveCoreData];	
		
	[myAppDelegate pointToDefaultKeyboardResponder];
	[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	MudAddButtonAction *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

	self.parentView = ma;

	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveEditedRecord:)];
	self.navigationItem.rightBarButtonItem = rb;
	
	
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	[self.navigationItem setTitle:@"Assign Text"];
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
