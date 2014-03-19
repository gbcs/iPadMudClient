//
//  TouchableTextsDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/24/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TouchableTextsDetail.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"
#import "MudDataSessions.h"

@implementation TouchableTextsDetail

@synthesize tableview, vartitle, varcurrentvalue;

-(void)SaveButtonClicked {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    TouchableTexts *variableView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
    
	if (![self.vartitle.text length]) {
		return;
	}
	
	if (!variableView.element) {
        
		MudDataTouchableTexts *char1 = (MudDataTouchableTexts *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataTouchableTexts" inManagedObjectContext:myAppDelegate.context];
		
		[char1 setCharacter:session.connectionData];
        
		variableView.element = char1;
		
	}
	
	if ([self.vartitle.text length]) {
		[variableView.element setKey:self.vartitle.text];
	} else {
		[variableView.element setKey:@"!invalid!"];
	}
	
    [variableView SaveEditedRecord];
    [myAppDelegate pointToDefaultKeyboardResponder];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
    NSString *headerName = nil;
    
	switch (section) {
		case 0:
			headerName = @"Key";
			break;
		case 1:
			headerName = @"Regular Expression";
			break;
		case 2:
			headerName = @"Associated Macro";
            break;
    }
	
	return headerName;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
    
    int rows = 0;
    
	switch (section) {
		case 0:
        case 1:
        case 2:
			rows = 1;
			break;
	}
	
	return rows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section ==1 ) {
		return 50.0f;
	}
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	TouchableTexts *variableView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"CellSection2";
	
	int section = indexPath.section;
	
	NSString *labeltext = nil;
	NSString *hinttext = nil;
	UITableViewCell *cell = nil;
	UILabel *label1 = nil;
	UITextField *textField = nil;
	
	
	if (section == 0) {
		labeltext = @"Title";
		hinttext = @"required";
    } else if (section == 1 ) {
		labeltext = @"Regular Expression";
        hinttext = @"required";
	} else if (section == 2 ) {
		labeltext = @"Associated Macro";
        hinttext = @"required";
	}
	
	if (section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			
			
			label1 = [[UILabel alloc] initWithFrame:CGRectMake(30,15,130,30)];
			label1.textAlignment = NSTextAlignmentRight;
			label1.font = [UIFont boldSystemFontOfSize:12];
			
			label1.backgroundColor = [UIColor clearColor];
			
			
			CGRect textFieldFrame = CGRectMake(10.0, 10.0, self.view.frame.size.width - 20, 30.0);
			textField = [[UITextField alloc] initWithFrame:textFieldFrame];
			[textField setTextColor:[UIColor blackColor]];
            textField.keyboardAppearance = UIKeyboardAppearanceDark;
			[textField setTextAlignment:NSTextAlignmentCenter];
			[textField setFont:[UIFont boldSystemFontOfSize:14]];
			[textField setDelegate:self];
			[textField setPlaceholder:hinttext];
			[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
			textField.backgroundColor = [UIColor clearColor];
			textField.keyboardType = UIKeyboardTypeDefault;
			
			//[cell.contentView addSubview:label1];
			
			self.vartitle = textField;
			if (variableView.element) {
				[textField setText:[variableView.element key]];
			}
			[cell.contentView addSubview:self.vartitle];
		}
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
			
			
			label1 = [[UILabel alloc] initWithFrame:CGRectMake(10,15,130,30)];
			label1.textAlignment = NSTextAlignmentLeft;
			label1.font = [UIFont boldSystemFontOfSize:12];
			
			label1.backgroundColor = [UIColor clearColor];
			
			
			CGRect textViewFrame = CGRectMake(0, 10, cell.bounds.size.width, 210.0);
			UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
            textView.keyboardAppearance = UIKeyboardAppearanceDark;
            textView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            textView.textColor = [UIColor whiteColor];
			[textView setDelegate:self];
			[textView setFont:[UIFont boldSystemFontOfSize:14]];
            textView.spellCheckingType = UITextSpellCheckingTypeNo;
            textView.autocorrectionType = UITextAutocorrectionTypeNo;
            textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
			//[cell.contentView addSubview:label1];
			
			//self.varcurrentvalue = textView;
			//if (variableView.element) {
			//	[textView setText:[variableView.element path]];
			//}
			//[cell.contentView addSubview:self.varcurrentvalue];
		}
	}
    
	label1.text	= labeltext;
	
    
 	return cell;
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	CGSize contentSize;
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
	    contentSize.width = 560;
		contentSize.height = 290;
		self.view.frame = CGRectMake(0,0,560,240);
		self.tableview.frame = CGRectMake(0,0,560,240);
	} else {
	    contentSize.width = 560;
		contentSize.height = 620;;
		self.view.frame = CGRectMake(0,0,560,620);
		self.tableview.frame = CGRectMake(0,0,560,600);
	}
    self.preferredContentSize = contentSize;
	
	[self.vartitle becomeFirstResponder];
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) {
		[self.vartitle becomeFirstResponder];
	} else {
		[self.varcurrentvalue becomeFirstResponder];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)loadView {
	TouchableTexts *variableView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	if (variableView.element) {
		self.navigationItem.title = @"Edit Touchable Text";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	} else {
		self.navigationItem.title = @"Add Touchable Text";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	}
	
	tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tableview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	tableview.delegate = self;
	tableview.dataSource = self;
	
	[tableview setBackgroundColor:[UIColor clearColor]];
    
	
	[self.view addSubview:tableview];
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	self.view = nil;
        ;
}

@end
