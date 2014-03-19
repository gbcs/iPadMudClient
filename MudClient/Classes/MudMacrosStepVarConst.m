//
//  MudMacrosStepVarConst.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosStepVarConst.h"
#import "MudMacrosStep.h"
#import "MudMacrosDetail.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudMacrosStepVarConst



@synthesize tableview, varValue;


-(void) saveButtonClicked:(id)sender {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	myAppDelegate.mudMacrosDetail.macroStep.value1 = self.varValue.text;
	
	
	
	[myAppDelegate.mudMacrosDetail saveStep];
	
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popToViewController:myAppDelegate.mudMacrosDetail animated:YES];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	switch (section) {
		case 0:
			return 1;
			
	}		
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
		return 100;
	
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Value";
			break;
	}
	
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	UITextField *textField = nil;
	
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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

		self.varValue = textField;
	
		[textField setPlaceholder:@"required"];
	
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
		contentSize.height = 620;
	}
    self.preferredContentSize = contentSize;
	
	
	[self.varValue becomeFirstResponder];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 620)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Math With Constant";
	
	UIBarButtonItem *tb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];

	tb.enabled = YES;
	self.navigationItem.rightBarButtonItem = tb;

	
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

