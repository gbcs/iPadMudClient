//
//  MudMacrosStepVarAssNum.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosStepVarAssNum.h"
#import "MudMacrosStepVarConst.h"
#import "MudMacrosStepVarVar.h"
#import "MudMacrosStep.h"
#import "Macros.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudMacrosStepVarAssNum


@synthesize tableview;



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	switch (section) {
		case 0:
			return 4;
			
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
			cell.textLabel.text = @"Add";
			break;
		case 1:
			cell.textLabel.text = @"Subtract";
			break;
		case 2:
			cell.textLabel.text = @"Multiply";
			break;
		case 3:
			cell.textLabel.text = @"Divide";
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
	
	switch (myAppDelegate.mudMacrosDetail.subCommand) {
		case 1:
        {
			switch (indexPath.row) {
				case 0:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarAddConstant];
					break;
				case 1:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarSubtractConstant];
					break;
				case 2:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarMultiplyConstant];
					break;
				case 3:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarDivideConstant];
					break;
			}
			MudMacrosStepVarConst *uv1 = [[MudMacrosStepVarConst alloc] init];
			[self.navigationController pushViewController:uv1 animated:YES];
        }
            break;
		case 2:
        {
			switch (indexPath.row) {
				case 0:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarAddVariable];
					break;
				case 1:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarSubtractVariable];
					break;
				case 2:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarMultiplyVariable];
					break;
				case 3:
					myAppDelegate.mudMacrosDetail.macroStep.command = [NSNumber	numberWithInt:mMacroCommandModVarDivideVariable];
					break;
			}
			MudMacrosStepVarVar *uv2 = [[MudMacrosStepVarVar alloc] init];
			[self.navigationController pushViewController:uv2 animated:YES];
		}
            break;
	}
	
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Select Operation";
	
	
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