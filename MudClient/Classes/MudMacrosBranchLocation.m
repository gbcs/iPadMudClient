//
//  MudMacrosBranchLocation.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosBranchLocation.h"
#import "MudMacrosStepBranchVar.h"
#import "MudMacrosStep.h"
#import "MudMacrosDetail.h"
#import "Macros.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudMacrosBranchLocation



@synthesize tableview, branchLocation;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 5;
			
	}		
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1)
		return 44;
	
	return 100;
	
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Destination Label for Branch";
			break;
		case 1:
			return @"Branch Condition";
			break;
	}
	
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	
	UITextField *textField = nil;
	UITableViewCell *cell = nil;
	
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				
				CGRect textFieldFrame = CGRectMake(10.0, 40.0, 480.0, 20.0);
				textField = [[UITextField alloc] initWithFrame:textFieldFrame];
				[textField setTextColor:[UIColor blackColor]];
				textField.keyboardAppearance = UIKeyboardAppearanceDark;
				[textField setDelegate:self];
				[textField setTextAlignment:NSTextAlignmentCenter];
				[textField setBackgroundColor:[UIColor clearColor]];
				textField.keyboardType = UIKeyboardTypeDefault;
				[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
				[cell.contentView addSubview:textField];
				
				self.branchLocation = textField;
				
				[textField setPlaceholder:@"required"];
				
			}
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}	
			switch (indexPath.row) {
			case 0:
				cell.textLabel.text = @"Unconditionally";
				cell.accessoryType = UITableViewCellAccessoryNone;
				break;
			case 1: 
				cell.textLabel.text = @"Compare two Variables for Equality";
				break;
			case 2:
				cell.textLabel.text = @"Compare two Variables for Inequality";
				break;
			case 3:
				cell.textLabel.text = @"First Variable is Greater than the Second";
				break;
			case 4:
				cell.textLabel.text = @"First Variable is Less than the Second";
				break;
			}
			break;
	}
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
		contentSize.height = 620;;
	}
    self.preferredContentSize = contentSize;
	
	[self.branchLocation becomeFirstResponder];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	myAppDelegate.mudMacrosDetail.macroStep.value1 = self.branchLocation.text;
	
	if (indexPath.section == 1) {
		if ([self.branchLocation.text length] <1) {
			return;
		}
		
		switch (indexPath.row) {
			case 0:
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandBranchUnconditional];
				[myAppDelegate.mudMacrosDetail saveStep];
				
				[myAppDelegate pointToDefaultKeyboardResponder];
				
				[self.navigationController popToViewController:myAppDelegate.mudMacrosDetail animated:YES];
				return;
			case 1:
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandBranchEquality];
				break;
			case 2:
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandBranchInequality];
				break;
			case 3:	
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandBranchGreaterThan];
				break;
			case 4:	
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandBranchLessThan];				
				break;
		}
		
		
		MudMacrosStepBranchVar *uv = [[MudMacrosStepBranchVar alloc] init];
		[self.navigationController pushViewController:uv animated:YES];;
	} else {
		[self.branchLocation becomeFirstResponder];
	}
	
	
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Branch Destination";
	
	
	self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	self.tableview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.tableview.delegate = self;
	self.tableview.dataSource = self;
	
	
	[self.view addSubview:self.tableview];
	
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


- (void)dealloc {
    self.view = nil;

    ;
}

@end

