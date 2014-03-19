//
//  MudMacrosDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudMacros.h"
#import "MudDataMacros.h"
#import "MudMacrosDetail.h"
#import "MudMacrosStep.h"
#import "MudDataMacroSteps.h"
#import "MudClientIpad4AppDelegate.h"
#import "Macros.h"
#import "MudStepFormattedText.h"
#import "MudMacrosStepLabel.h"
#import "MudMacrosStepVarConst.h"

@implementation MudMacrosDetail


@synthesize tableview, mactitle, stepList, macroStep, buttonAddStep, buttonReorderSteps;
@synthesize  subCommand, tvSteps;


-(void)addStep {
	

	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	MudDataMacroSteps *step = (MudDataMacroSteps *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataMacroSteps" inManagedObjectContext:myAppDelegate.context];
	
	int topStep = 0;
	self.subCommand = 0;
	MudDataMacroSteps *tmpStep = nil;
	for (tmpStep in myAppDelegate.mudMacrosDetail.stepList) {
		if ([[tmpStep step] intValue]>topStep)
			topStep = [[tmpStep step] intValue];
	}
	
	[step setStep:[NSNumber numberWithInt:topStep + 1]];
	[step setMacroID:macroView.element];
	[step setFormatVariableList:@""];
	[step setCommand:[NSNumber numberWithInt:mMacroCommandEndMacro]];
	
	[macroView SaveEditedRecord];
	
	myAppDelegate.mudMacrosDetail.macroStep = step;
	
}


-(void)saveStep {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	[macroView SaveEditedRecord];
	[myAppDelegate.mudMacrosDetail PullRecordsforList];
	[myAppDelegate.mudMacrosDetail.tableview reloadData];
	
}


-(void)addStepButtonClicked:(id)sender {
	
	[self addStep];
	
	MudMacrosStep *uv = [[MudMacrosStep alloc] init];
	
	[self.navigationController pushViewController:uv animated:YES];
	
}

-(void)reorderStepButtonClicked:(id)sender {
	self.buttonAddStep.enabled = NO;
	self.buttonReorderSteps.enabled = NO;
	
	[self.tableview reloadData];
	
	[self.tableview setEditing:YES ];
	

	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(SaveButtonClicked)];
	self.navigationItem.rightBarButtonItem = rb;

}



-(void)SaveButtonClicked {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	if (self.tableview.editing == YES) {
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
		self.tableview.editing = NO;
		self.buttonAddStep.enabled = YES;
		self.buttonReorderSteps.enabled = YES;
		return;
	}
	
	
	if (![self.mactitle.text length] ) {
		return;
	}
	
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	[macroView.element setTitle:self.mactitle.text];
	
	[macroView SaveEditedRecord];
		
	[myAppDelegate pointToDefaultKeyboardResponder];
	
	[self.navigationController popToViewController:macroView animated:YES];
						 
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
   
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	

    if (editingStyle == UITableViewCellEditingStyleDelete) {
	

		
        // Delete the managed object at the given index path.
		NSManagedObject *eventToDelete = [self.stepList objectAtIndex:indexPath.row];
		[myAppDelegate.context deleteObject:eventToDelete];
		
		// Update the array and table view.
        [self.stepList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		
		[myAppDelegate saveCoreData];	
    }   
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Name";
			break;
		case 1:
			return @"Steps";
			break;
	}
	
	return nil;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	
	return YES;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.	
	int rows = [self.stepList count]+1;
	
	if (section == 0) {
		rows = 1;
	}
	
	return rows;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 50;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
	
	static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"Cell2";
	UITableViewCell *cell = nil;
	
	MudMacros *macroView = [self.navigationController.viewControllers objectAtIndex:0];
	
	
	switch (indexPath.section) {
		case 0:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				cell.textLabel.font = [UIFont systemFontOfSize:14.0];
				//cell.editingAccessoryType = UITableViewCellEditingStyleNone;
				
				CGRect textFieldFrame = CGRectMake(10.0, 10.0, self.view.frame.size.width - 20, 30.0);
				UITextField *textField = [[UITextField alloc] initWithFrame:textFieldFrame];
				[textField setTextColor:[UIColor blackColor]];
                textField.keyboardAppearance = UIKeyboardAppearanceDark;
				[textField setTextAlignment:NSTextAlignmentCenter];
				[textField setFont:[UIFont boldSystemFontOfSize:14]];
				[textField setDelegate:self];
				[textField setPlaceholder:@"required"];
				[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
				[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
				textField.backgroundColor = [UIColor clearColor];
				textField.keyboardType = UIKeyboardTypeDefault;
				self.mactitle = textField;
				[cell addSubview:self.mactitle];
				if (macroView.element) {
					self.mactitle.text = [macroView.element title];
				}
			}
			cell.showsReorderControl = NO;
			//cell.editingAccessoryType = UITableViewCellEditingStyleNone;
			cell.shouldIndentWhileEditing = NO;
			break;
		case 1:
			cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
			
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier2];
				cell.textLabel.font = [UIFont systemFontOfSize:14.0];
			}
			
			cell.accessoryType = UITableViewCellAccessoryNone;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if (indexPath.row == [self.stepList count]) {
				cell.textLabel.text	 = @"End Macro";
				cell.showsReorderControl = NO;
				//cell.editingAccessoryType = UITableViewCellEditingStyleNone;
			} else {
				//cell.editingAccessoryType = UITableViewCellEditingStyleDelete;
				
				MudDataMacroSteps *cellStep = [self.stepList objectAtIndex:indexPath.row];
				cell.showsReorderControl = YES;
		
				cell.textLabel.text = [NSString stringWithFormat:@"%d",  [[cellStep command] intValue]];
				
				cell.detailTextLabel.text = @"";
				
				cell.tag = [[cellStep step] intValue];
				
				switch ([[cellStep command] intValue]) {
					case mMacroCommandModVarMacroArgument:	// 1~var_obj_id~macro_arg_num
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Set Variable %@ to macro argument #%@", indexPath.row+1, [[cellStep firstVariable] title], [cellStep value1]];
						break;
					case mMacroCommandModVarMacroArgumentAppend:	// 1~var_obj_id~macro_arg_num
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Append macro argument #%@ to variable %@", indexPath.row+1, [cellStep value1], [[cellStep firstVariable] title] ];
						break;
					case mMacroCommandModVarSetConstant:	// 2~var_obj_id~value
						//NSLog(@"%@ %@", [cellStep firstVariable], [cellStep value1]);
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Set [%@] to: %@", indexPath.row+1, [[cellStep firstVariable] title], [cellStep value1]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;	
					case mMacroCommandModVarAddConstant:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Add %@ to [%@]", indexPath.row+1, [cellStep value1], [[cellStep firstVariable] title]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandModVarSubtractConstant:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Subtract %@ From [%@]", indexPath.row+1,[cellStep value1], [[cellStep firstVariable] title]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandModVarMultiplyConstant:// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Multiply [%@] by %@", indexPath.row+1, [[cellStep firstVariable] title], [cellStep value1]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandModVarDivideConstant:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Divide [%@] by %@", indexPath.row+1, [[cellStep firstVariable] title], [cellStep value1]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandModVarAddVariable:	// 7~var_obj_id~var_obj_id
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Add [%@] to [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title] ];
						break;
					case mMacroCommandModVarSubtractVariable:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Subtract [%@] from [%@]", indexPath.row+1, [[cellStep secondVariable] title], [[cellStep firstVariable] title] ];
						break;
					case mMacroCommandModVarMultiplyVariable:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Multiply [%@] by [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title] ];
						break;
					case mMacroCommandModVarDivideVariable:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Divide [%@] into [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title] ];	
						break;
					case mMacroCommandModVarSetFormattedText:	// 11~var_obj_id~text~var_obj_id_list
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Set variable with formatted text:%@", indexPath.row+1,[cellStep value1]];
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Variable 1: %@", [[cellStep firstVariable] title]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandLabelAssign:	// 12~labeltext
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Label: %@", indexPath.row+1,[cellStep value1]];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandBranchUnconditional:	// 13~labeltext
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Branch Unconditionally", indexPath.row+1  ];
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Branch to Label: %@", [cellStep value1]];	
						break;
					case mMacroCommandBranchEquality:	// 14~labeltext~var_obj_id~var_obj_id
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Branch if [%@] is equal to [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title]   ];
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Branch to Label: %@", [cellStep value1]];	
						break;				
					case mMacroCommandBranchInequality:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Branch if [%@] is not equal to [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title]   ];
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Branch to Label: %@", [cellStep value1]];	
						break;					
					case mMacroCommandBranchGreaterThan:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Branch if [%@] is greater than [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title]   ];
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Branch to Label: %@", [cellStep value1]];	
						break;			
					case mMacroCommandBranchLessThan:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Branch if [%@] is less than [%@]", indexPath.row+1, [[cellStep firstVariable] title], [[cellStep secondVariable] title]   ];
						cell.detailTextLabel.text = [NSString stringWithFormat:@"Branch to Label: %@", [cellStep value1]];	
						break;	
					case mMacroCommandSendFormattedTextServer:// 18~text~var_obj_id_list
					{
						NSString *delayStr = @"";
						if ([[cellStep delay] intValue] > 0) {
							delayStr = [NSString stringWithFormat:@" (%d second delay)", [[cellStep delay] intValue]];
						}
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Send formatted text to the server%@", indexPath.row+1, delayStr];
						cell.detailTextLabel.text = [cellStep value1];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
					}
						break;
					case mMacroCommandSendFormattedTextLocal:	// ""
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: Send formatted text to the local screen", indexPath.row+1];
						cell.detailTextLabel.text = [cellStep value1];
						cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
						break;
					case mMacroCommandEndMacro:  //
						cell.textLabel.text = [NSString stringWithFormat:@"%2d: End the macro", indexPath.row+1];
						break;
					case mMacroCommandRunMacro:
					{
						int macroID = [[cellStep value1] intValue];
						for (MudDataMacros *macro in session.macros) {
							if ([[macro id] intValue] == macroID) {
								cell.textLabel.text = [NSString stringWithFormat:@"%2d: Run Macro: %@", indexPath.row+1, [macro title]];
								break;
							}
						}
					} 
						break;
					default:
						NSLog(@"Invalid Command");
						exit(1);
						break;
				}
			}
			
		
	}
			
	return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) 
		return NO;
	
	int topStep = [self.stepList count];
	
	if (indexPath.row == topStep) 
		return NO;
	
	
	
	return YES;

}

- (BOOL)tableView:(UITableView *)tableview canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0) 
		return NO;
	
	int topStep = [self.stepList count];
	
	if (indexPath.row == topStep) 
		return NO;
	
	return YES;
}
- (void)reloadData{
    [self.tableview reloadData];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	
	MudDataMacroSteps *fromStep = [self.stepList objectAtIndex:fromIndexPath.row];	
	
	int fromRow = fromIndexPath.row;
	int toRow = toIndexPath.row;
	
	if ( fromRow >toRow) {
		[self.stepList removeObjectAtIndex:fromRow];
		[self.stepList insertObject:fromStep atIndex:toRow];
	} else {
		[self.stepList removeObjectAtIndex:fromRow];
		[self.stepList insertObject:fromStep atIndex:toRow];
		
	}
	int count=0;
	for (MudDataMacroSteps *s in self.stepList) {
		count++;
		s.step = [NSNumber numberWithInt:count];
	}
	
	
	
	
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	
	
	[myAppDelegate saveCoreData];
	[self PullRecordsforList];
	[self performSelector:@selector(reloadData) withObject:nil afterDelay:0.02];
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
	
	[self.mactitle becomeFirstResponder];
	
	
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableview reloadData];
}



-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
		
	if (indexPath.section != 1) {
		return;
	}
	
	self.macroStep = [self.stepList objectAtIndex:indexPath.row];
	self.subCommand = 0;
	
	switch ([[self.macroStep command] intValue]) {
		case mMacroCommandSendFormattedTextServer:
		case mMacroCommandSendFormattedTextLocal:
		case mMacroCommandModVarSetFormattedText:
		{
			MudStepFormattedText *uv = [[MudStepFormattedText alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
		}
			break;
		
		case mMacroCommandModVarSetConstant:
		case mMacroCommandModVarAddConstant:
		case mMacroCommandModVarSubtractConstant:
		case mMacroCommandModVarMultiplyConstant:
		case mMacroCommandModVarDivideConstant:
		{
			MudMacrosStepVarConst *uv = [[MudMacrosStepVarConst alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
		}
			break;
			
		case mMacroCommandLabelAssign:	// 12~labeltext
		{
			MudMacrosStepLabel *uv = [[MudMacrosStepLabel alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
		}
			break;
		default:
		{
			MudMacrosStep *uv = [[MudMacrosStep alloc] init];
			
			[self.navigationController pushViewController:uv animated:YES];
		}		
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	if (indexPath.section == 0) {
		[self.mactitle becomeFirstResponder];
	} 
	
}


-(void)PullRecordsforList {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MudDataMacroSteps" inManagedObjectContext:myAppDelegate.context];
	[request setEntity:entity];
	
	
	
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"macroID=%@", macroView.element];
	[request setPredicate:predicate];
	
	// Order the events by creation date, most recent first.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"step" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	// Execute the fetch -- create a mutable copy of the result.
	NSError *error = nil;
	NSMutableArray *mutableFetchResults = [[myAppDelegate.context executeFetchRequest:request error:&error] mutableCopy];
	if (mutableFetchResults == nil) {
		// Handle the error.
	}
	
	// Set self's events array to the mutable array, then clean up.
	
	self.stepList = mutableFetchResults;

	
    
    /*
    int x=0;
	for (MudDataMacroSteps *s in self.stepList) {
		int snum = [[s step] intValue];
		x++;
		NSLog(@"%d -> %d" , x, snum);
	}
    */
}



- (void)loadView {
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	
	myAppDelegate.mudMacrosDetail = self;
	
    
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	self.tableview.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	

	self.view.opaque = YES;

    
	self.tableview.delegate = self;
	self.tableview.dataSource = self;
	
	[self.tableview setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:self.tableview];

    self.navigationController.toolbarHidden = YES;
    
    
	UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithTitle:@"Edit Steps" style:UIBarButtonItemStyleBordered target:self action:@selector(reorderStepButtonClicked:)];
	lb.enabled = YES;
	self.navigationItem.leftBarButtonItem = lb;
    self.navigationItem.rightBarButtonItem = nil;
    
	UIBarButtonItem *saveButton =  [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		
	MudMacros *macroView = (MudMacros *)[self.navigationController.viewControllers objectAtIndex:0];
	
	if (macroView.element) {
		self.navigationItem.title = @"Edit Macro";
		[self PullRecordsforList];
	} else {
		self.navigationItem.title = @"Add Macro";
    }

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Macro Step" style:UIBarButtonItemStyleBordered target:self action:@selector(addStepButtonClicked:)];
	addButton.enabled = YES;
	
	self.buttonAddStep = addButton;
	//UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
	self.buttonReorderSteps = saveButton;
    

    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveButton, addButton, nil];
	
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
