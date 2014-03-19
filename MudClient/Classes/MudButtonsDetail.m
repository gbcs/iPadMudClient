    //
//  MudButtonsDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudButtonsDetail.h"
#import "MudDataButtons.h"
#import "MudAddButtonAction.h"
#import "MudClientIpad4ViewController.h"
#import "ButtonPanel.h"
#import "MudButtonsImage.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudDataMacros.h"
#import "ButtonPanel.h"


@implementation MudButtonsDetail

@synthesize tableview, buttitle;
@synthesize element, parentView, context;
@synthesize bPanel;
@synthesize editLayer;

-(void)SaveButtonClicked {
	[self.element setTitle:self.buttitle.text];
	
	if (self.element.layer1Macro) {
		[self.element setLayer1Action:@""];
	} else {
		[self.element setLayer1Macro:nil];
	}
	
	if (self.element.layer2Macro) {
		[self.element setLayer2Action:@""];
	} else {
		[self.element setLayer2Macro:nil];
	}
	
	if (self.element.layer3Macro) {
		[self.element setLayer3Action:@""];
	} else {
		[self.element setLayer3Macro:nil];
	}
	
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate saveCoreData];	

	ButtonPanel *bp = (ButtonPanel *)self.parentView;
	MudClientIpad4ViewController *ip = (MudClientIpad4ViewController *)bp.topController;
	
	[bp populateButtons];
	[ip dismissPopovers];
    
    if (bp.remote) {
        [[RemoteServer tool] sendButtonList];
    }
    
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	switch (section) {
		case 0:
			return 2;
		case 1:
			return 3;
	}
	
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	 static NSString *CellIdentifier2 = @"Cell2";
	 static NSString *CellIdentifier3 = @"Cell3";
		
	ButtonPanel *bp = (ButtonPanel *)self.parentView;
	UITextField *textField = nil;
	
	int section = indexPath.section;
	int row = indexPath.row;
	
	UITableViewCell *cell = nil;
	
	if (section == 0) {
		if (row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				CGRect textFieldFrame = CGRectMake(0.0, 2.0, self.view.frame.size.width, 44.0 -4);
				textField = [[UITextField alloc] initWithFrame:textFieldFrame];
				textField.keyboardAppearance = UIKeyboardAppearanceDark;
                [textField setTextColor:[UIColor blackColor]];
				[textField setFont:[UIFont boldSystemFontOfSize:14]];
				[textField setTextAlignment:NSTextAlignmentCenter];
				[textField setDelegate:self];
				[textField setPlaceholder:@"Name"];
				[textField setBackgroundColor:[UIColor clearColor]];
				textField.keyboardType = UIKeyboardTypeDefault;
				[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
				[cell.contentView addSubview:textField];
                textField.backgroundColor = [UIColor clearColor];
				self.buttitle = textField;
			}
			[textField setText:[self.element title]];
		} else if (row == 1 ) {
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.textLabel.textAlignment = NSTextAlignmentCenter;
			}
			int iconIdx = [self.element.iconIndex intValue];
			if (iconIdx > 0) {
				UIImageView *iView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[bp.iconImages objectAtIndex:iconIdx]]];
				iView.frame = CGRectMake(225,6	,32,32);
				[cell.contentView addSubview:iView];
				cell.textLabel.text = @"";
			} else {
				cell.textLabel.text = @"Icon";
			}
			
			
			
		}
    } else if (section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier3];
			cell.textLabel.textAlignment = NSTextAlignmentLeft;
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];

		BOOL isMacro = NO;
		BOOL appendFlag = NO;
		
		switch (row) {
			case 0:
				cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
				cell.textLabel.text = @"Layer 1";
				if (element.layer1Macro) { isMacro = YES; }
				if ([element.appendFlag1 boolValue] == YES) { appendFlag = YES; }
				if (isMacro) {
					cell.detailTextLabel.text = [NSString stringWithFormat:@"Run macro: %@", element.layer1Macro.title];
				} else if ([element.layer1Action length]) {
					if (appendFlag) {
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Append to the command-line: %@", element.layer1Action];
					} else {
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Send to the server: %@", element.layer1Action];
					}
				} else {
					cell.detailTextLabel.text = @"<No action configured>";
				}
				break;
			case 1:
				cell.textLabel.text = @"Layer 2";
				cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
				if (element.layer2Macro) { isMacro = YES; }
				if ([element.appendFlag2 boolValue] == YES) { appendFlag = YES; }
				if (isMacro) {
					cell.detailTextLabel.text = [NSString stringWithFormat:@"Run macro: %@", element.layer2Macro.title];
				} else if ([element.layer2Action length]) {
					if (appendFlag) {
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Append to the command-line: %@", element.layer2Action];
					} else {
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Send to the server: %@", element.layer2Action];
					}
				} else {
					cell.detailTextLabel.text = @"<No action configured>";
				}
				break;
			case 2:
				cell.textLabel.text = @"Layer 3";
				cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
				if (element.layer3Macro) { isMacro = YES; }
				if ([element.appendFlag3 boolValue] == YES) { appendFlag = YES; }
				if (isMacro) {
					cell.detailTextLabel.text = [NSString stringWithFormat:@"Run macro: %@", element.layer3Macro.title];
				} else if ([element.layer3Action length]	) {
					if (appendFlag) {
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Append to the command-line: %@", element.layer3Action];
					} else {
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Send to the server: %@", element.layer3Action];
					}
				} else {
					cell.detailTextLabel.text = @"<No action configured>";
				}
				break;
				
		}
	}
	
	return cell;
}


-(void)viewWillDisappear:(BOOL)animated {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	[myAppDelegate pointToDefaultKeyboardResponder];


}

- (void)viewWillAppear:(BOOL)animated {
	
	self.tableview.frame = CGRectMake(0,0,560,320);
	CGSize contentSize;
	contentSize.width = 560;
	contentSize.height = 320;
	self.preferredContentSize = contentSize;
	
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[self.buttitle becomeFirstResponder];
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	switch (indexPath.section) {
		case 0:
        {
            MudButtonsImage *uv;
			switch (indexPath.row) {
				case 0:
					[self.buttitle becomeFirstResponder];
					break;
				case 1:
					uv = [[MudButtonsImage alloc] init];
					uv.parentView = self;
					[self.navigationController pushViewController:uv animated:YES];
					break;
			}
		}
            break;
		case 1:
        {
            MudAddButtonAction *uv;
			self.editLayer = indexPath.row+1;
			uv = [[MudAddButtonAction alloc] init];
			uv.parentView = self;
			[self.navigationController pushViewController:uv animated:YES];
		}
            break;
	}
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Edit Button";
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
	self.navigationItem.rightBarButtonItem = rb;

	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
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


- (void)dealloc {
	self.view = nil;
        ;
}


@end
