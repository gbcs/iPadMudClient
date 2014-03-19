//
//  MudStepFormattedText.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudStepFormattedText.h"
#import "MudStepFormattedTextVar.h"
#import "MudDataVariables.h"
#import "MudMacrosStep.h"
#import "MudMacrosDetail.h"
#import "MudDataMacros.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudMacros.h"
#import "MudMacroStepDelay.h"

@implementation MudStepFormattedText

@synthesize tableview, formattedText, formatVariables, selectedVariable, delay;



-(void)saveButtonClicked:(id)sender {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	
	myAppDelegate.mudMacrosDetail.macroStep.value1 = self.formattedText.text;

	myAppDelegate.mudMacrosDetail.macroStep.secondVariable = nil;

	//Package variable references
	
	
	NSMutableString *varRef = nil;
	
	int varCount = [self.formatVariables count];
	
	for (int x=0;x<varCount;x++) {
		if (x > 0) {
			NSObject *tmpObj = [self.formatVariables objectAtIndex:x];
			if ( ([[[tmpObj class] description] isEqualToString:@"NSCFNumber"]) || ([[[tmpObj class] description] isEqualToString:@"__NSCFNumber"]) ) {
				[varRef appendFormat:@",%d", [(NSNumber *)tmpObj intValue]];
			} else {
				[varRef appendFormat:@",%d", [[(MudDataVariables *)tmpObj id] intValue]];
			}
		} else {
			NSObject *tmpObj = [self.formatVariables objectAtIndex:x];
			if ( ([[[tmpObj class] description] isEqualToString:@"NSCFNumber"]) || ([[[tmpObj class] description] isEqualToString:@"__NSCFNumber"]) ) {
				varRef = [NSMutableString stringWithFormat:@"%d", [(NSNumber *)tmpObj intValue]];
			} else {
				varRef = [NSMutableString stringWithFormat:@"%d", [[(MudDataVariables *)tmpObj id] intValue]];
				
			}
		}
	}
	myAppDelegate.mudMacrosDetail.macroStep.formatVariableList = varRef;
	myAppDelegate.mudMacrosDetail.macroStep.delay = [NSNumber numberWithInt:delay];
	[myAppDelegate.mudMacrosDetail saveStep];
	 	[myAppDelegate pointToDefaultKeyboardResponder];
	[self.navigationController popToViewController:myAppDelegate.mudMacrosDetail animated:YES];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	
	switch (section) {
		case 0:
			return 1;
		case 1:
		{
			int c = [self.formatVariables count];
			
			if (c < 35) {
				c++;
			}
			
			return c;
		}
		case 2:
			return 1;
	}		
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	
	if (indexPath.section == 0) {
		return 300;
	}
	
	return 44;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Formatted Text";
			break;
		case 1:
			return @"Variable Reference";
			break;	
		case 2:
			return @"Options";
			break;
	}
	
	return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
   
	static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	static NSString *CellIdentifier3 = @"Cell3";

	
	UITableViewCell *cell = nil;
	
	UITextView *TextView = nil;
	
	if (indexPath.section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			
			CGRect TextViewFrame = CGRectMake(0.0, 0.0, self.view.frame.size.width, 300.0);
			TextView = [[UITextView alloc] initWithFrame:TextViewFrame];
            TextView.keyboardAppearance = UIKeyboardAppearanceDark;
            TextView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            TextView.textColor = [UIColor whiteColor];
			[TextView setDelegate:self];
			[TextView setTextAlignment:NSTextAlignmentLeft];
			TextView.keyboardType = UIKeyboardTypeDefault;
			TextView.keyboardAppearance = UIKeyboardAppearanceDark;
			[cell.contentView addSubview:TextView];
			
			self.formattedText = TextView;
			
			[TextView setText:myAppDelegate.mudMacrosDetail.macroStep.value1];
			
		}
	} if (indexPath.section == 1)  {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
		}	
		
		char searchChar;
		if (indexPath.row+1 < 10) {
			searchChar = (char)(48 + indexPath.row+1);
		} else {
			searchChar = (char)(97 + indexPath.row+1 - 10);
		}
		
		
		if ([self.formatVariables count] <= indexPath.row) {
			cell.textLabel.text = [NSString stringWithFormat:@"$%c", searchChar];
		} else {
			NSObject *tmpObj = [self.formatVariables objectAtIndex:indexPath.row];
			NSLog(@"tmpobj class desc = %@", [[tmpObj class] description]);
			if ( ([[[tmpObj class] description] isEqualToString:@"NSCFNumber"]) || ([[[tmpObj class] description] isEqualToString:@"__NSCFNumber"]) ) {
				if ([(NSNumber *)tmpObj intValue] == -10) {
					cell.textLabel.text = [NSString stringWithFormat:@"$%c = [Character's Name]", searchChar];
				} else if ([(NSNumber *)tmpObj intValue] == -11) {
					cell.textLabel.text = [NSString stringWithFormat:@"$%c = [Character's Password]", searchChar];
				}
			} else {
				int aRowMax = [self.formatVariables count];
				
				if (aRowMax > indexPath.row) {
					cell.textLabel.text = [NSString stringWithFormat:@"$%c = %@", searchChar, [(MudDataVariables *)[self.formatVariables objectAtIndex:indexPath.row] title]];
				} else {
					cell.textLabel.text = [NSString stringWithFormat:@"$%c = %@", searchChar, @""];
				}
			}
		}
	} else if (indexPath.section == 2)  {
		
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier3];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
		}		
		NSString *formatString = @"Delay sending text for %d second%s.";
		cell.textLabel.text = [NSString stringWithFormat:formatString, delay, delay == 1 ? "" : "s"];
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
	
	[self.formattedText becomeFirstResponder];
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

	if (indexPath.section == 1) {
	
		self.selectedVariable = indexPath.row;
		
		MudStepFormattedTextVar *uv = [[MudStepFormattedTextVar alloc] init];
		[self.navigationController pushViewController:uv animated:YES];
	} else if (indexPath.section == 2) {
		MudMacroStepDelay *md = [[MudMacroStepDelay alloc] init];
		[self.navigationController pushViewController:md animated:YES];
	}

	
}


-(void)formatButtonClicked:(id)sender {


}


- (void)loadView {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudSession *session = [myAppDelegate getActiveSessionRef];

	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Edit Formatted Text";
	
	UIBarButtonItem *tb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
	tb.enabled = YES;
	self.navigationItem.rightBarButtonItem = tb;
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
		

	[self.view addSubview:tc];
	
	int rowCount = [session.variables count];
	
	self.formatVariables = [[NSMutableArray alloc] init];
	
	NSString *formatVarList = myAppDelegate.mudMacrosDetail.macroStep.formatVariableList;
  
	NSArray *formatVarArray = [formatVarList componentsSeparatedByString:@","];
		
	for (NSString *v in formatVarArray) {
		int idVal = [v intValue];
		if (idVal >= 0) { 
			for (int x= 0;x<rowCount;x++) {
				if ([[[session.variables objectAtIndex:x] id] intValue] == idVal) {
					[self.formatVariables insertObject:[session.variables objectAtIndex:x] atIndex:[self.formatVariables count]];
					break;
				}
			}
		} else {
			[self.formatVariables insertObject:[NSNumber numberWithInt:idVal] atIndex:[self.formatVariables count]];
		}
	}	
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	tc.delegate = self;
	tc.dataSource = self;
	
	self.tableview = tc;
	
	delay = [myAppDelegate.mudMacrosDetail.macroStep.delay intValue];
	
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
