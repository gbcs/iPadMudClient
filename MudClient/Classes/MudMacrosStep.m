//
//  MudMacrosStep.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosStep.h"

#import "MudDataMacros.h"
#import "MudMacrosDetail.h"
#import "MudMacrosStepVariable.h"
#import "MudStepFormattedText.h"
#import "MudMacrosStepLabel.h"
#import "MudMacrosBranchLocation.h"
#import "MudMacrosStepRun.h"
#import "MudMacros.h"
#import "Macros.h"
#import "MudDataMacroSteps.h"
#import "MudClientIpad4AppDelegate.h"


@implementation MudMacrosStep 


@synthesize tableview;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 7;
			
	}		
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float h = 50;

	return h;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	
	UITableViewCell *cell = nil;
	
	switch (indexPath.section) {
		case 0:
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				cell.textLabel.textAlignment = NSTextAlignmentCenter;
				cell.textLabel.font = [UIFont systemFontOfSize:17.0];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			cell.textLabel.text = [macroView.element title];
			break;
		default:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
			}
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			switch (indexPath.row) {
				case 0:
					cell.textLabel.text = @"Modify Variable";
					break;
				case 1:
					cell.textLabel.text = @"Assign Label";
					break;
				case 2:
					cell.textLabel.text = @"Branch";
					break;
				case 3:
					cell.textLabel.text = @"Send Text to Server";
					break;
				case 4:
					cell.textLabel.text = @"Send Text Locally";
					break;
				case 5:
					cell.textLabel.text = @"Run Macro";
					break;
				case 6:
					cell.textLabel.text = @"End Macro";
					cell.accessoryType = UITableViewCellAccessoryNone;
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
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	myAppDelegate.mudMacrosDetail.subCommand = 0;
	
	if (indexPath.section == 1) {
		

		switch (indexPath.row) {
			case 0:
				{
					MudMacrosStepVariable *uv = [[MudMacrosStepVariable alloc] init];
					[self.navigationController pushViewController:uv animated:YES];
				}
				break;
			case 1:
			{
				MudMacrosStepLabel *uv = [[MudMacrosStepLabel alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 2:
			{
				MudMacrosBranchLocation *uv = [[MudMacrosBranchLocation alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 3:
			{
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandSendFormattedTextServer];
				MudStepFormattedText *uv = [[MudStepFormattedText alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 4:
			{
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandSendFormattedTextLocal];
				MudStepFormattedText *uv = [[MudStepFormattedText alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 5:
				// macro list
			{
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandRunMacro ];
				myAppDelegate.mudMacrosDetail.macroStep.value1 = nil;
				myAppDelegate.mudMacrosDetail.macroStep.firstVariable = nil;
				myAppDelegate.mudMacrosDetail.macroStep.secondVariable = nil;
				
				MudMacrosStepRun *uv = [[MudMacrosStepRun alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 6:
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber numberWithInt:mMacroCommandEndMacro];

				myAppDelegate.mudMacrosDetail.macroStep.value1 = nil;
				myAppDelegate.mudMacrosDetail.macroStep.firstVariable = nil;
				myAppDelegate.mudMacrosDetail.macroStep.secondVariable = nil;
				
				[myAppDelegate.mudMacrosDetail saveStep];
				
				[myAppDelegate pointToDefaultKeyboardResponder];
				
				[self.navigationController popViewControllerAnimated:YES];
				
				[myAppDelegate.mudMacrosDetail.tableview reloadData];
				break;
		}
	}
}



- (void)loadView {

	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Select Macro Step";
	
	
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



@end

	