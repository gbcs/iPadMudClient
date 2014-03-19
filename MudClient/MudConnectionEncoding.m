//
//  MudConnectionEncoding.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MudConnectionEncoding.h"
#import "NewConnectionDetail.h"

@implementation MudConnectionEncoding


@synthesize tableview;

#define numEncodings 19

int encodingList[] = {
					kCFStringEncodingISOLatin1,
					kCFStringEncodingISOLatin2,
					kCFStringEncodingISOLatin3,	
					kCFStringEncodingISOLatin4,
					kCFStringEncodingISOLatinCyrillic,
					kCFStringEncodingISOLatinArabic,
					kCFStringEncodingISOLatinGreek,
					kCFStringEncodingISOLatinHebrew,
					kCFStringEncodingISOLatin5,
					kCFStringEncodingISOLatin6,
					kCFStringEncodingISOLatinThai,
					kCFStringEncodingISOLatin7,
					kCFStringEncodingISOLatin8,
					kCFStringEncodingISOLatin9,
					kCFStringEncodingISOLatin10,
					kCFStringEncodingMacRoman,
					kCFStringEncodingWindowsLatin1,
					kCFStringEncodingASCII,
					kCFStringEncodingUTF8
	
};
					

+(NSString *)encodingNameFromVal:(int)encodingVal {

	switch (encodingVal) {
		case 0x0201:
			return @"ISO 8859-1 (Latin1)";
		case 0x0202:
			return @"ISO 8859-2 (Latin2)";
		case 0x0203:
			return @"ISO 8859-3 (Latin3)";
		case 0x0204:
			return @"ISO 8859-4 (Latin4)";	
		case 0x0205:
			return @"ISO 8859-5 (Cryllic)";	
		case 0x0206:
			return @"ISO 8859-6 (Arabic)";
		case 0x0207:
			return @"ISO 8859-7 (Greek)";
		case 0x0208:
			return @"ISO 8859-8 (Hebrew)";
		case 0x0209:
			return @"ISO 8859-9 (Latin5)";
		case 0x020A:
			return @"ISO 8859-10 (Latin 6";
		case 0x020B:
			return @"ISO 8859-11 (Latin Thai)";
		case 0x020D:
			return @"ISO 8859-13 (Latin7)";
		case 0x020E:
			return @"ISO 8859-14 (Latin8)";	
		case 0x020F:
			return @"ISO 8859-15 (Latin9)";
		case 0x0210:
			return @"ISO 8859-16 (Latin10)";
		case 0:
			return @"Mac Roman";
		case 0x0500:
			return @"ANSI 1252 (Windows)";
		case 0x0600:
			return @"ASCII + Unicode";
		case 0x08000100:
			return @"UTF-8";
	}
	
	return nil;

}



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
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// As many rows as there are obects in the events array.
	return numEncodings;
	
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
	
	cell.textLabel.text = [MudConnectionEncoding encodingNameFromVal:encodingList[indexPath.row]];
	
 	return cell;
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	NewConnectionDetail *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
	[ma updateEncoding:encodingList[indexPath.row]];
	[self.navigationController popViewControllerAnimated:YES];
}
 
- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	
	self.navigationItem.title = @"Select a Character Encoding";
	
	UITableView *tc = [[UITableView alloc] initWithFrame:CGRectMake(0,0,560,420) style:UITableViewStyleGrouped];
	tc.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
	tc.delegate = self;
	tc.dataSource = self;
	
	
	[self.view addSubview:tc];
	
	self.tableview = tc;
	
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
