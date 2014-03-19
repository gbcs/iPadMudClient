//
//  MudMacrosStepVariableModifier.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosStepVariableModifier.h"
#import "MudDataMacros.h"
#import "MudMacrosDetail.h"
#import "MudMacrosStepVariable.h"
#import "MudMacrosStepVarAssMac.h"
#import "MudMacrosStepVarAssNum.h"
#import "MudMacrosStepVarConst.h"
#import "MudStepFormattedText.h"
#import "Macros.h"
#import "MudMacrosStep.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudMacrosStepVariableModifier

@synthesize tableview;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	switch (section) {
		case 0:
			return 6;
			
	}		
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	float h = 50;
	
	return h;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
		UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	switch (indexPath.row) {
		case 0:
			cell.textLabel.text = @"Set Value to a macro command-line argument";
			break;
		case 1: 
			cell.textLabel.text = @"Set value to a Cconstant";
			break;
		case 2:
			cell.textLabel.text = @"Perform a math operation using a constant";
			break;
		case 3:
			cell.textLabel.text = @"Perform a math operation using a variable";
			break;
		case 4:
			cell.textLabel.text = @"Set value to text with formatting";
			break;
		case 5:
			cell.textLabel.text = @"Append a macro command-line argument to a variable";
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
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0:
			case 5:
			{
				
				MudMacrosStepVarAssMac *uv = [[MudMacrosStepVarAssMac alloc] init];
				if (indexPath.row == 0) {
					uv.appendFlag = NO;
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarMacroArgument];
				} else {
					uv.appendFlag = YES;
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarMacroArgumentAppend];
				}
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 1:
			{
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarSetConstant];
				MudMacrosStepVarConst *uv = [[MudMacrosStepVarConst alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 2:
			{
				myAppDelegate.mudMacrosDetail.subCommand = 1;
				MudMacrosStepVarAssNum *uv = [[MudMacrosStepVarAssNum alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 3:
			{
				myAppDelegate.mudMacrosDetail.subCommand = 2;
				MudMacrosStepVarAssNum *uv = [[MudMacrosStepVarAssNum alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
			case 4:
			{
				myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarSetFormattedText];
				MudStepFormattedText *uv = [[MudStepFormattedText alloc] init];
				[self.navigationController pushViewController:uv animated:YES];
			}
				break;
		}
	}
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Edit Macro Steps";
	
	
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

