    //
//  MudButtonsImage.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 8/26/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MudButtonsImage.h"
#import "ButtonPanel.h"
#import "MudButtonsDetail.h"
#import "MudClientIpad4AppDelegate.h"

@implementation MudButtonsImage

@synthesize scrollView;
@synthesize  parentView;

- (void)btnClicked:(id)sender {
	UIButton *s = (UIButton *)sender;
	
	MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
	MudButtonsDetail *detailView = (MudButtonsDetail *)self.parentView;
	ButtonPanel *bPanel = (ButtonPanel *)detailView.bPanel;
	
	[detailView.element setIconIndex:[NSNumber numberWithInt:s.tag]];
	
	[myAppDelegate saveCoreData];	
	
	[bPanel populateButtons];
	[myAppDelegate pointToDefaultKeyboardResponder];
	[detailView.tableview reloadData];
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (void)viewWillAppear:(BOOL)animated {
	
	CGSize contentSize;
	contentSize.width = 560;
	contentSize.height = 320;
	self.preferredContentSize = contentSize;
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	activityIndicator.frame = CGRectMake(560/2-20,320/2-40, 40,40);
	[self.view addSubview:activityIndicator];
	[activityIndicator startAnimating];
	
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	MudButtonsDetail *md = (MudButtonsDetail *)self.parentView;
	ButtonPanel *b = (ButtonPanel *)md.parentView;
	
	int imageCount = [b.iconImages count];
	
	int col =0;
	
	for ( int x=0; x<imageCount; x+=5) { 
		for (int y=0;y<5;y++) {
			int tag = x + y;
			if (tag >= imageCount) {
				continue;
			}
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			NSString *imgName = [b.iconImages objectAtIndex:tag];
			[btn setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
			btn.tag = tag;
			[btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
			[btn setFrame:CGRectMake(10 + col*55, 10 + y*55,45,45)];
			[self.scrollView addSubview:btn];
		}
		col++;
	}
	
	self.scrollView.contentSize = CGSizeMake(col * 55 + 55, 300);
	
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	activityIndicator = nil;
	
	[self.view addSubview:self.scrollView];
}



- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 560, 420)];
	self.view.backgroundColor = [UIColor whiteColor];
	self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,560,400)];
	[scrollView setShowsVerticalScrollIndicator:NO];
	[scrollView setShowsHorizontalScrollIndicator:NO];
	[self.navigationItem setTitle:@"Select an Icon"];
	[self.scrollView setBackgroundColor:[UIColor whiteColor]];
	

	
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




@end
