    //
//  NewConnectionFontDetail.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 4/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewConnectionFontDetail.h"
#import "NewConnectionFont.h"
#import "NewConnectionDetail.h"

@implementation NewConnectionFontDetail {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    self.characterFont = [UIFont fontWithName:[tableView cellForRowAtIndexPath:indexPath].textLabel.text size:self.characterFontSize];
    
	  
}

- (void) SaveButtonClicked {
	NewConnectionDetail *ma = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3];
	[ma updateFont:self.characterFont atSize:self.characterFontSize];
	
	[self.navigationController popToViewController:ma animated:YES];
	
}	

- (void)LargerButtonClicked {

	self.characterFontSize += 0.5f;
	
	if (self.characterFontSize > 98) {
		return;
	}
    
	self.characterFont = [self.characterFont fontWithSize:self.characterFontSize];
	sample.font = self.characterFont;
    [self updateFontLabels];
}

- (void)SmallerButtonClicked {
	
	self.characterFontSize -= 1.0f;
	
	if (self.characterFontSize <6) {
		return;
	}
	
	self.characterFont = [self.characterFont fontWithSize:self.characterFontSize];
	sample.font = self.characterFont;
    [self updateFontLabels];
}

- (void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,560,420)];
	self.view.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
	
   	UIBarButtonItem *rb = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(SaveButtonClicked)];
	self.navigationItem.rightBarButtonItem = rb;
	
	
   
	sample = [[UITextView alloc] initWithFrame:CGRectMake(10,50,540,100)];
    sample.keyboardAppearance = UIKeyboardAppearanceDark;
    [[sample layer] setCornerRadius:8.0f];
	[[sample layer] setMasksToBounds:YES];
	[[sample layer] setBorderWidth:1.0f];
	sample.backgroundColor = [UIColor blackColor];
	sample.textColor = [UIColor greenColor];
	sample.font = self.characterFont;
	
    fontName = [[UILabel alloc] initWithFrame:CGRectMake(10,10,540,30)];
	fontName.textAlignment = NSTextAlignmentCenter;
	fontName.backgroundColor = [UIColor clearColor];
	fontName.textColor = [UIColor whiteColor];
	
	sample.text = @"Colossal Cave Adventure, created in 1975 by Will Crowther on a DEC PDP-10 computer, was the first widely used adventure game. The game was significantly expanded in 1976 by Don Woods. Also called Adventure, it contained many D&D features and references, including a computer controlled dungeon master.[13][14]\n	\n	Inspired by Adventure, a group of students at MIT wrote a game called Zork in the summer of 1977 for the PDP-10 minicomputer which became quite popular on the ARPANET. Zork was ported under the name Dungeon to FORTRAN by a programmer working at DEC in 1978.[15]\n	\n	In 1978 Roy Trubshaw, a student at Essex University in the UK, started working on a multi-user adventure game in the MACRO-10 assembly language for a DEC PDP-10. He named the game MUD (Multi-User Dungeon), in tribute to the Dungeon variant of Zork, which Trubshaw had greatly enjoyed playing.[16] Trubshaw converted MUD to BCPL (the predecessor of C), before handing over development to Richard Bartle, a fellow student at Essex University, in 1980.[17][18][19]\n -- https://secure.wikimedia.org/wikipedia/en/wiki/MUD	\n\n	";

    
    charactersInPortrait = [[UILabel alloc] initWithFrame:CGRectMake(190,160,300,30)];
	charactersInPortrait.textAlignment = NSTextAlignmentCenter;
	charactersInPortrait.backgroundColor = [UIColor clearColor];
	charactersInPortrait.textColor = [UIColor blackColor];
	

    fontSize = [[UILabel alloc] initWithFrame:CGRectMake(50,160,100,30)];
	fontSize.textAlignment = NSTextAlignmentCenter;
	fontSize.backgroundColor = [UIColor clearColor];
	fontSize.textColor = [UIColor blackColor];
	
    
    [self.view addSubview:fontSize];
    [self.view addSubview:charactersInPortrait];
    
	[self.view addSubview:fontName];
	
	[self.view addSubview:sample];
	
    [self updateFontLabels];
}

-(void)updateFontLabels {
    fontSize.text = [NSString stringWithFormat:@"%0.1fpt", self.characterFontSize];
  
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByClipping;
    CGSize textSize = [@"Z" sizeWithAttributes:@{
                                                 NSFontAttributeName : self.characterFont,
                                                 NSParagraphStyleAttributeName : [style copy],
                                                 
                                                 }];
    
    NSInteger charsPerLine = (768.0f / textSize.width) -1;
    charactersInPortrait.text = [NSString stringWithFormat:@"width: %d characters (portrait)", charsPerLine];
}

- (void)viewWillAppear:(BOOL)animated {
    UIBarButtonItem *largerb = [[UIBarButtonItem alloc] initWithTitle:@"Make Larger" style:UIBarButtonItemStylePlain target:self action:@selector(LargerButtonClicked)];
    UIBarButtonItem *smallerb = [[UIBarButtonItem alloc] initWithTitle:@"Make Smaller" style:UIBarButtonItemStylePlain target:self action:@selector(SmallerButtonClicked)];
    [largerb setTintColor:[UIColor blackColor]];
    [smallerb setTintColor:[UIColor blackColor]];
    
    self.navigationController.toolbar.barStyle = UIBarStyleDefault;
    self.navigationController.toolbar.translucent = NO;
    
    [self.navigationController setToolbarHidden:NO];
    self.toolbarItems = @[ smallerb, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:Nil action:nil], largerb ];
    
    
    UIInterfaceOrientation iPadOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	if ( (iPadOrientation == UIInterfaceOrientationLandscapeLeft) | (iPadOrientation == UIInterfaceOrientationLandscapeRight) ) {
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 290;
		self.preferredContentSize = contentSize;
	} else {
		CGSize contentSize;
		contentSize.width = 560;
		contentSize.height = 620;
		self.preferredContentSize = contentSize;
	}
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
