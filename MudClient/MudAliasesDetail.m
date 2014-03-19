//
//  MudAliasesDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 11/10/12.
//
//

#import "MudAliasesDetail.h"
#import "MudDataAliases.h"
#import "MudClientIpad4AppDelegate.h"
#import "MudClientIpad4ViewController.h"
#import "MudAliasesSelectVariable.h"

@interface MudAliasesDetail ()

@end

@implementation MudAliasesDetail

@synthesize tableview, vartitle, varcurrentvalue;


-(void)SaveButtonClicked {
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudAliases  *aliasView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	MudSession *session = [myAppDelegate getActiveSessionRef];
    
	if (![self.vartitle.text length]) {
		return;
	}
	
	if (!aliasView.element) {
        
		MudDataAliases *char1 = (MudDataAliases *)[NSEntityDescription insertNewObjectForEntityForName: @"MudDataAliases" inManagedObjectContext:myAppDelegate.context];
		
		
		[char1 setSlotID:session.connectionData];
        
		aliasView.element = char1;
		
		int topIndex = 0;
		for (MudDataAliases *v in session.aliases) {
			int tmpIndex = [[v id] intValue];
			if (tmpIndex >topIndex) {
				topIndex = tmpIndex;
			}
		}
		topIndex++;
		
		char1.id = [NSNumber numberWithInt:topIndex];
		
	}
	
	if ([self.vartitle.text length]) {
		[aliasView.element setTitle:self.vartitle.text];
	} else {
		[aliasView.element setTitle:@"!invalid!"];
	}
	
    aliasView.element.firstVariable = var1;
    aliasView.element.secondVariable = var2;
    aliasView.element.thirdVariable = var3;
    
	
	if ([self.varcurrentvalue.text length]) {
		[aliasView.element setValue:self.varcurrentvalue.text];
	} else {
		[aliasView.element setValue:@""];
	}
    
	[aliasView SaveEditedRecord];
    [myAppDelegate pointToDefaultKeyboardResponder];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	switch (section) {
		case 0:
			return @"Name";
			break;
		case 1:
			return @"Current Value";
			break;
        case 2:
            return @"Variable Assignment";
            break;
	}
	
	return nil;
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
	switch (section) {
            
		case 0:
			return 1;
			break;
		case 1:
			return 1;
			break;
        case 2:
        {
            return 3;
		}
            break;
	}
	
	return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section ==1 ) {
		return 140;
	}
	return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MudAliases *aliasView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
    static NSString *CellIdentifier = @"Cell";
	static NSString *CellIdentifier2 = @"CellSection2";
	static NSString *CellIdentifier3 = @"CellSection3";
    
	int section = indexPath.section;
	
	NSString *labeltext = nil;
	NSString *hinttext = nil;
	UITableViewCell *cell = nil;
	UILabel *label1 = nil;
	UITextField *textField = nil;
	
	
	if (section == 0) {
		labeltext = @"Alias Name";
		hinttext = @"required";
	} else if (section == 1 ) {
		labeltext = @"Current Value";
	}
	
	if (section == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			
			CGRect textFieldFrame = CGRectMake(0.0, 0.0, cell.bounds.size.width, 50.0);
			textField = [[UITextField alloc] initWithFrame:textFieldFrame];
            textField.keyboardAppearance = UIKeyboardAppearanceDark;
            [textField setTextColor:[UIColor blackColor]];
            textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			[textField setTextAlignment:NSTextAlignmentCenter];
			[textField setFont:[UIFont boldSystemFontOfSize:14]];
			[textField setDelegate:self];
			[textField setPlaceholder:hinttext];
			[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
			[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
			textField.backgroundColor = [UIColor clearColor];
			textField.keyboardType = UIKeyboardTypeDefault;
			
			self.vartitle = textField;
			if (aliasView.element) {
				[textField setText:[aliasView.element title]];
			}
			[cell.contentView addSubview:self.vartitle];
		}
	} else  if (section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
		
			CGRect textViewFrame = CGRectMake(0, 0, cell.bounds.size.width, 140.0);
			UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
            
            textView.keyboardAppearance = UIKeyboardAppearanceDark;
            textView.spellCheckingType = UITextSpellCheckingTypeNo;
            textView.autocorrectionType = UITextAutocorrectionTypeNo;
            textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
            textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			textView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1.0];
            textView.textColor = [UIColor whiteColor];
			[textView setDelegate:self];
			[textView setFont:[UIFont boldSystemFontOfSize:14]];
			
			self.varcurrentvalue = textView;
			if (aliasView.element) {
				[textView setText:[aliasView.element value]];
			}
			[cell.contentView addSubview:self.varcurrentvalue];
		}
	} else if (section == 2) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier3];
        cell.textLabel.text = [NSString stringWithFormat:@"$%d", indexPath.row +1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(70,10,cell.bounds.size.width - 80,30)];
        label1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label1.textAlignment = NSTextAlignmentCenter;
        label1.font = [UIFont boldSystemFontOfSize:14];
        label1.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label1];
        
        MudDataVariables *v = nil;
        
        switch (indexPath.row) {
            case 0:
                v = var1;
                break;
            case 1:
                v = var2;
                break;
            case 2:
                v = var3;
                break;
            default:
                break;
        }
        
        if (v) {
            labeltext = v.title;
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
	} else {
	    contentSize.width = 560;
		contentSize.height = 620;
	}
    self.preferredContentSize = contentSize;
	
	[self.vartitle becomeFirstResponder];
}

-(void)updateVariable:(MudDataVariables *)v  {
    switch (selectedVariableIndex) {
        case 0:
            var1 = v;
            break;
        case 1:
            var2 = v;
            break;
        case 2:
            var3 = v;
            break;
    }
    [self.tableview reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
	
    if (indexPath.section == 0) {
		[self.vartitle becomeFirstResponder];
	} else if (indexPath.section == 1) {
		[self.varcurrentvalue becomeFirstResponder];
	} else if (indexPath.section == 2) {
        MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
        myAppDelegate.aliasDetail = self;
        selectedVariableIndex = indexPath.row;
        MudAliasesSelectVariable *selectVarVC = [[MudAliasesSelectVariable alloc] init];
        [self.navigationController pushViewController:selectVarVC animated:YES];

    }

}

- (void)loadView {
	MudAliases *aliasView = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
    self.view.autoresizingMask =UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    
	if (aliasView.element) {
		self.navigationItem.title = @"Edit Alias";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	} else {
		self.navigationItem.title = @"Add Alias";
		UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
		self.navigationItem.rightBarButtonItem = rb;
	}
	
	tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	
	 tableview.autoresizingMask =UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
    if (aliasView.element) {
        var1 = aliasView.element.firstVariable;
        var2 = aliasView.element.secondVariable;
        var3 = aliasView.element.thirdVariable;
    }
    
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
    
}


@end