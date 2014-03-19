//
//  MudMacrosLaunch.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacrosName.h"
#import "MudMacros.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"


@implementation MudMacrosName


@synthesize tableview, macroName;

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {		
	return 50.0f;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";

	UITextField *textField = nil;
	UITableViewCell *cell = nil;
	
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		CGRect textFieldFrame = CGRectMake(10.0, 10.0, self.view.frame.size.width - 20, 30.0);
		textField = [[UITextField alloc] initWithFrame:textFieldFrame];
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
		textField.backgroundColor = [UIColor clearColor];
		textField.textAlignment = NSTextAlignmentCenter;
		[textField setDelegate:self];
		[textField setFont:[UIFont boldSystemFontOfSize:14]];
		[textField setPlaceholder:@"required"];
		[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
		[cell.contentView addSubview:textField];
		self.macroName = textField;
	}
			
	
 	return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
		return @"Macro Name";
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
	
	
	[self.macroName becomeFirstResponder];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	[self.macroName becomeFirstResponder];
}

- (void)saveButtonClicked:(id)sender {
	
	if ( (!macroName) | ([macroName.text length]<1)) {
        return;
    }
    
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	MudDataMacros *macro1 = (MudDataMacros *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataMacros" inManagedObjectContext:myAppDelegate.context];
	
	[macro1 setSlotID:session.connectionData];
	
	[macro1 setTitle:self.macroName.text];
		
	int topIndex = 0;
	for (MudDataMacros *m in session.macros) {
		int tmpIndex = [[m id] intValue];
		if (tmpIndex >topIndex) {
			topIndex = tmpIndex;
		}
	}
	topIndex++;
	
	macro1.id = [NSNumber numberWithInt:topIndex];
	
	macroView.element = macro1; 
	
	[macroView SaveEditedRecord];
	
	MudMacrosDetail *uv = [[MudMacrosDetail alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];
	

}

- (void)loadView {
	
	
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.navigationItem.title = @"Create Macro";
	
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
	self.navigationItem.rightBarButtonItem = rb;
	
	
	self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	self.tableview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.tableview.delegate = self;
	self.tableview.dataSource = self;
	
	[self.tableview setBackgroundColor:[UIColor clearColor]];
	
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