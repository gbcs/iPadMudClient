    //
//  MudTriggersDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudTriggersDetail.h"
#import	"MudAddTriggerAction.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"

#define LABEL1_TAG 1
#define SWITCH1_TAG 2
#define SWITCH2_TAG 3

@implementation MudTriggersDetail

@synthesize tableview, trigtitle, trigvalue, trigmacro, trigenabled, trigautodisable;

-(void)SaveButtonClicked {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudTriggers *triggerView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	if (![self.trigtitle.text length]) {
		return;
	}
	
	if (!triggerView.element) {
		MudDataTriggers *char1 = (MudDataTriggers *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataTriggers" inManagedObjectContext:myAppDelegate.context];
		
		[char1 setSlotID:session.connectionData];
				
		triggerView.element = char1;
	}
	
	[triggerView.element setTitle:self.trigtitle.text];
	[triggerView.element setExpression:self.trigvalue.text];
	[triggerView.element setTrigmacro:self.trigmacro];
	
	[triggerView.element setTriggerEnabled:[NSNumber numberWithBool:[self.trigenabled isOn]]];
	[triggerView.element setDisableOnUse:[NSNumber numberWithBool:[self.trigautodisable isOn]]];
	
	
	[triggerView saveEditedRecord];
	
		[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
		return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 2;
		case 1:
			return 2;
		case 2:
			return 1;
	}
	
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( (indexPath.section == 0) && (indexPath.row == 1) ) {
		return 140.0f;
	} else {
		return 50.0f;
	}
}


-(void)triggerEnabledSwitch:(id)sender {
	MudTriggers *triggerView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	UISwitch *tempSwitch = (UISwitch *)sender;
	if ([tempSwitch isOn]) {
		triggerView.element.triggerEnabled = [NSNumber numberWithBool:YES];
	} else {
		triggerView.element.triggerEnabled = [NSNumber numberWithBool:NO];
	}
}

-(void)triggerDisableOnUseSwitch:(id)sender {
	MudTriggers *triggerView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	UISwitch *tempSwitch = (UISwitch *)sender;
	if ([tempSwitch isOn]) {
		triggerView.element.DisableOnUse = [NSNumber numberWithBool:YES];
	} else {
		triggerView.element.DisableOnUse = [NSNumber numberWithBool:NO];
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MudTriggers *triggerView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];

    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	static NSString *CellIdentifier4 = @"Cell4";
	
	
	UISwitch *switch1 = nil;
	UILabel *label1 = nil;
	UITextField *textField = nil; 

	NSString *labeltext = nil;
    NSString *detailtext = nil;
	UITableViewCell *cell = nil;

	
	int celltype = 0;
	
	int section = indexPath.section;
	int row = indexPath.row;
	
	
	switch (section) {
		case 0:
		{
			switch (row) {
				case 0:
					labeltext = @"Name";
					celltype = 0;
					break;
				case 1:
					labeltext = @"";
					celltype = 4;
					break;
			}
		}
			break;
	case 1:
		{
			switch (row) {
				case 0:
					labeltext = @"Enabled";
					celltype = 3;
					break;
				case 1:
					labeltext = @"Disable on Match; Enable Each Connect";
					celltype = 3;
					break;
			}
		}
			break;
		case 2:
			labeltext = @"Associated Macro:";
            detailtext = self.trigmacro ? [self.trigmacro title] : @"None";
            celltype = 1;
		break;
	case 3:
		labeltext = @"Explain Trigger Construction";
		celltype = 1;
		break;
	}
	
	switch (celltype) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				CGRect textFieldFrame = CGRectMake(10.0, 10.0, cell.bounds.size.width - 20, 30.0);
				textField = [[UITextField alloc] initWithFrame:textFieldFrame];
                textField.keyboardAppearance = UIKeyboardAppearanceDark;
                textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				[textField setTextColor:[UIColor blackColor]];
				[textField setTextAlignment:NSTextAlignmentCenter];
				[textField setFont:[UIFont boldSystemFontOfSize:14]];
				
				[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
				[textField setDelegate:self];
				[textField setPlaceholder:labeltext];
				textField.keyboardType = UIKeyboardTypeDefault;
				textField.backgroundColor = [UIColor clearColor];
				[textField setText:[triggerView.element title]];
				[cell.contentView addSubview:textField];
				
				self.trigtitle = textField;
			}	
			
			
			
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}	
            
			cell.detailTextLabel.text = detailtext;
			cell.textLabel.text = labeltext;
			
			if (section == 3) {
				cell.accessoryType = UITableViewCellAccessoryNone;
			} else {
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			}
			break;
		case 3:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier4];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier4];
				switch1 = [[UISwitch alloc] initWithFrame:CGRectZero];
				switch (indexPath.row) {
					case 0:
						if ([[triggerView.element triggerEnabled] boolValue] == YES) {
							[switch1 setOn:YES animated:NO];
						} else {
							[switch1 setOn:NO animated:NO];
						}
						switch1.tag = SWITCH1_TAG;
						self.trigenabled = switch1;
						
						break;
						
					case 1:
						if ([[triggerView.element DisableOnUse] boolValue] == YES) {
							[switch1 setOn:YES animated:NO];
						} else {
							[switch1 setOn:NO animated:NO];
						}
						switch1.tag = SWITCH2_TAG;
						self.trigautodisable = switch1;
						break;
				}
				
				[cell addSubview:switch1];
				cell.accessoryView = switch1;
				
				[(UISwitch *)cell.accessoryView addTarget:self action:@selector(triggerEnabledSwitch:) forControlEvents:UIControlEventValueChanged];
				
			;
				cell.textLabel.text = labeltext;
			}
			break;	
		case 4:
			
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
				label1 = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, cell.bounds.size.width, 20.0)];
                label1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				label1.textAlignment = NSTextAlignmentCenter;
				label1.font = [UIFont boldSystemFontOfSize:12];
				label1.text	= @"Regular Expression (matched against each incoming line)";
				label1.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1.0];
				[cell.contentView addSubview:label1];
				
				CGRect textViewFrame = CGRectMake(0.0, 40.0, cell.bounds.size.width, 90.0);
				UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
                textView.keyboardAppearance = UIKeyboardAppearanceDark;
                textView.backgroundColor =[UIColor colorWithWhite:0.4 alpha:1.0];
                textView.textColor = [UIColor whiteColor];
				[textView setDelegate:self];
				[textView setFont:[UIFont boldSystemFontOfSize:14]];
                textView.spellCheckingType = UITextSpellCheckingTypeNo;
                textView.autocorrectionType = UITextAutocorrectionTypeNo;
                textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
                    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
				self.trigvalue = textView;
				[cell.contentView addSubview:self.trigvalue];
				
				[textView setText:[triggerView.element expression]];
                
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
		contentSize.height = 620;
	}
    self.preferredContentSize = contentSize;
	
	[self.trigtitle becomeFirstResponder];

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MudAddTriggerAction *uv = nil;
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	switch (indexPath.section) {
		case 0:
			switch (indexPath.row) {
			case 0:
				[self.trigtitle becomeFirstResponder];
				break;
			case 1:
				[self.trigvalue becomeFirstResponder];
				break;
			}
			break;
		case 2:
			uv = [[MudAddTriggerAction alloc] init];
			[self.navigationController pushViewController:uv animated:YES];
			break;
		}
}

-(void)triggerHelpButtonClicked:(id)sender {
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = @"";
    
    switch (section) {
        case 0:
            title = @"Trigger";
            break;
        case 1:
            title = @"Options";
            break;     
        case 2:
            title = @"Target";
            break;
    }
    
    return title;
    
}


- (void)loadView {
	MudTriggers *triggerView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560,420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	if (triggerView.element) {
		self.navigationItem.title = @"Edit Trigger";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	} else {
		
				
		self.navigationItem.title = @"Add Trigger";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	}
	
	tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStylePlain];
	tableview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	tableview .delegate = self;
	tableview .dataSource = self;

	[self.view addSubview:tableview];
	
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
