    //
//  NewConnectionFont.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewConnectionFont.h"
#import "NewConnectionDetail.h"
#import "NewConnectionFontDetail.h"

@implementation NewConnectionFont

@synthesize tableview;
@synthesize sortedFontFamilies;

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
	UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		self.tableview.frame = CGRectMake(0,0,560,270);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 290;
		self.preferredContentSize = contentSize;
	} else {
		self.tableview.frame = CGRectMake(0,0,560,600);
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 620;
		self.preferredContentSize = contentSize;
	}	
	[self.tableview reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedFontFamilies count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	return  [[UIFont fontNamesForFamilyName:[self.sortedFontFamilies objectAtIndex:section]] count];
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = nil;
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
		cell.textLabel.textAlignment = NSTextAlignmentCenter;
	}
	NSString *family = [self.sortedFontFamilies objectAtIndex:indexPath.section];
	NSString *fontName = [[UIFont fontNamesForFamilyName:family] objectAtIndex:indexPath.row];
	
	cell.textLabel.text = fontName;
	cell.textLabel.font = [UIFont fontWithName:cell.textLabel.text size:17.0f]; 
	
 	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

    UIFont *newFont = [UIFont fontWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text size:9.5f];
	
	NewConnectionFontDetail *uv = [[NewConnectionFontDetail alloc ] init];
	uv.characterFont = newFont;
    uv.characterFontSize = 9.5f;
	[self.navigationController pushViewController:uv animated:YES];
	
}

-(void)defaultButtonClicked {
	NewConnectionDetail *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	
	self.characterFont = [UIFont fontWithName:@"CourierNewPSMT" size:12.0f];
	[ma updateFont:self.characterFont atSize:12.0f];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	self.navigationItem.title = @"Select a Font Combination";
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	tc.delegate = self;
	tc.dataSource = self;
	
    self.automaticallyAdjustsScrollViewInsets = NO;
	
	[self.view addSubview:tc];
	
	self.tableview = tc;
	
	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Default" style:UIBarButtonItemStyleBordered target:self action:@selector(defaultButtonClicked)];
	self.navigationItem.rightBarButtonItem = rb;
	
	NSArray *fontNameList = [UIFont familyNames];
    NSMutableArray *monoSpaceFontList = [[NSMutableArray alloc] initWithCapacity:10];
    
    for (NSString *fontName in fontNameList) {
        UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithName:fontName size:12.0];
        if (fontDescriptor.symbolicTraits & UIFontDescriptorTraitMonoSpace) {
            [monoSpaceFontList addObject:fontName];
            NSLog(@"adding:%@", fontName);
        } else {
            NSLog(@"skipping:%@", fontName);
        }

    }
    

    
	self.sortedFontFamilies = [[monoSpaceFontList copy] sortedArrayUsingComparator: ^(id obj1, id obj2) {
		return [(NSString *)obj1 compare:(NSString *)obj2];
		
	}];
	
	
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
