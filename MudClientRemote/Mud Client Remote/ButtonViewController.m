//
//  ButtonViewController.m
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/28/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import "ButtonViewController.h"

@interface ButtonViewController () {
  
    NSArray *buttonIcons;
    CGSize gridSize;
    NSInteger currentLayer;
}

@end

@implementation ButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)userTappedHistory {
    
}

-(void)userTappedClose {
    [[RemoteClient tool] disconnect];
    [[RemoteClient tool] gotoMenu];
   //[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    BOOL landscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CGRect r = CGRectMake(0,0, landscape ? bounds.size.height : bounds.size.width, landscape ? bounds.size.width : bounds.size.height);
    
    self.view = [[UIView alloc] initWithFrame:r];
    
    self.view.backgroundColor = [UIColor blackColor];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonListUpdated:) name:@"ButtonList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionListUpdated:) name:@"ConnectionList" object:nil];
    
    self.view.tag = -2;
    
}

-(void)connectionListUpdated:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(updateToolbar) withObject:nil waitUntilDone:YES];
    [[RemoteClient tool] performSelectorOnMainThread:@selector(requestButtonList) withObject:nil waitUntilDone:NO];
}

-(void)buttonListUpdated:(NSNotification *)n {
    buttonIcons = (NSArray *)n.object;
    
    [self performSelectorOnMainThread:@selector(paintButtons) withObject:nil waitUntilDone:NO];
}

-(void)paintButtons {
    
    for (NSObject *v in self.view.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            UIImageView *i = (UIImageView *)v;
            i.image = nil;
        }
    }
    
    if ( (!buttonIcons)  || ([buttonIcons count] <1 )) {
        return;
    }
    
    for (NSArray *button in buttonIcons) {
        NSNumber *index = [button objectAtIndex:0];
        NSNumber *icon = [button objectAtIndex:1];
        
        NSLog(@"index:%@:%@", index, [self.view viewWithTag:[index integerValue] + 10000]);
        UIImageView *i = (UIImageView *)[self.view viewWithTag:[index integerValue] + 10000];
        if (i && ([icon integerValue] > -1) ) {
            i.image = [UIImage imageNamed:[[[SettingsTool settings] buttonImages] objectAtIndex:[icon integerValue]]];
            
           // NSLog(@"%@ -> %@ (%@) '%@'", index, icon, i.image, [iconImages objectAtIndex:[icon integerValue]]);
            
        } else {
            i.image = nil;
        }
    }
}



-(void)cleanView {
    while ([self.view.subviews count]>0) {
        UIView *v = [self.view.subviews objectAtIndex:0];
        [v removeFromSuperview];
    }

}

-(void)updateToolbar {
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = [[RemoteClient tool] toolbarButtonsForCurrentConnectionList];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(userTappedClose)];
}

-(void)generateButtonGrid {
    [self cleanView];
   // NSLog(@"Gen");
    BOOL landscape = UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]);
    BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
  
    BOOL isWide = self.view.frame.size.height == 568.0f;
    
    if (landscape) {
       isWide = self.view.frame.size.width == 568.0f;
    }
    
    CGSize buttonSize = CGSizeMake(50,45);
    
    gridSize = CGSizeZero;
    
    CGPoint greenLoc = CGPointZero;
    CGPoint redLoc = CGPointZero;
    
    CGFloat yOffset = 0;
    CGFloat xOffset = 0;
    CGSize buttonPadding = CGSizeZero;
    
    if (isiPad && landscape) {
        gridSize = CGSizeMake(12,12);
        greenLoc = CGPointMake(40, (768 * 0.333f) - (buttonSize.height / 2.0f));
        redLoc = CGPointMake(40, (768 * 0.666f) - (buttonSize.height / 2.0f));
        xOffset = 90.0f;
        yOffset = 60.0f;
        buttonPadding = CGSizeMake(20,10);
    } else if (isiPad && (!landscape)) {
        gridSize = CGSizeMake(12,12);
        greenLoc = CGPointMake(((768 * 0.333f) - (buttonSize.height / 2.0f)), 940);
        redLoc = CGPointMake(((768 * 0.666f) - (buttonSize.height / 2.0f)), 940);
        xOffset = 0.0f;
        yOffset = 0.0f;
        buttonPadding = CGSizeMake(10,20);
    } else if (landscape && isWide) {
        gridSize = CGSizeMake(8,4);
        greenLoc = CGPointMake(20, 60 +( (260 * 0.333f) - (buttonSize.height / 2.0f)));
        redLoc = CGPointMake(20, 60 +( (260 * 0.666f) - (buttonSize.height / 2.0f)));
        xOffset = 70.0f;
        yOffset = 60.0f;
        buttonPadding = CGSizeMake(10,10);
    } else if (landscape) {
        gridSize   = CGSizeMake(6,4);
        greenLoc = CGPointMake(20, 60 +( (260 * 0.333f) - (buttonSize.height / 2.0f)));
        redLoc = CGPointMake(20, 60 +( (260 * 0.666f) - (buttonSize.height / 2.0f)));
        xOffset = 70.0f;
        yOffset = 60.0f;
        buttonPadding = CGSizeMake(10,10);
    } else if (isWide) {
        gridSize   = CGSizeMake(5,7);
        greenLoc = CGPointMake((self.view.frame.size.width * 0.333f) - (buttonSize.width / 2.0f), 490);
        redLoc = CGPointMake((self.view.frame.size.width * 0.666f) - (buttonSize.width / 2.0f), 490);
        yOffset = -30;
        buttonPadding = CGSizeMake(10,10);
    } else {
        gridSize   = CGSizeMake(5,6);
        yOffset = 0;
        buttonPadding = CGSizeMake(10,10);
        greenLoc = CGPointMake((self.view.frame.size.width * 0.333f) - (buttonSize.width / 2.0f), 420);
        redLoc = CGPointMake((self.view.frame.size.width * 0.666f) - (buttonSize.width / 2.0f), 420);
    }
    
    CGFloat leftX = xOffset + (((self.view.frame.size.width - xOffset) - ( (buttonSize.width * gridSize.width) + ( buttonPadding.width * (gridSize.width -1)))) / 2.0f);
    CGFloat topY = ( ( (self.view.frame.size.height - yOffset)  - ( (buttonSize.height * gridSize.height) + ( buttonPadding.height * (gridSize.height -1)))) / 2.0f) + yOffset;
    
  //  NSLog(@"frame:%@ gridSize:%@ leftX:%f topY:%f" , [NSValue valueWithCGRect:self.view.frame], [NSValue valueWithCGSize:gridSize], leftX, topY);
   
    for (int w=0;w<gridSize.width;w++) {
        for (int h=0;h<gridSize.height;h++) {
            CGRect pos = CGRectMake(leftX + (buttonSize.width * w) + (buttonPadding.width * w) , topY + (buttonSize.height * h) + (buttonPadding.height * h), buttonSize.width, buttonSize.height);
            UIImageView *i = [[UIImageView alloc] initWithFrame:pos];
            i.backgroundColor  = [UIColor colorWithWhite:0.2 alpha:1.0];
            i.tag = w + (gridSize.width * h) + 10000;
            i.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapped:)];
            UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userPressed:)];
            longG.minimumPressDuration = 0.25f;
            [i addGestureRecognizer:tapG];
            [i addGestureRecognizer:longG];
            
            i.userInteractionEnabled = YES;
            
            [self.view addSubview:i];
        }
    }
    
    UIImageView *ig = [[UIImageView alloc] initWithFrame:CGRectMake(greenLoc.x, greenLoc.y, buttonSize.width, buttonSize.height)];
    ig.backgroundColor  = [UIColor greenColor];
    ig.tag = 1000;
    ig.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(layerPressed:)];
    longG.minimumPressDuration = 0.001f;
    [ig addGestureRecognizer:longG];
    [self.view addSubview:ig];
    
    UIImageView *ir = [[UIImageView alloc] initWithFrame:CGRectMake(redLoc.x, redLoc.y, buttonSize.width, buttonSize.height)];
    ir.backgroundColor  = [UIColor redColor];
    ir.tag = 1001;
    ir.userInteractionEnabled = YES;
    longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(layerPressed:)];
    longG.minimumPressDuration = 0.001f;
    [ir addGestureRecognizer:longG];
    [self.view addSubview:ir];
}

-(void)layerPressed:(UILongPressGestureRecognizer *)g {
    if (g.state == UIGestureRecognizerStateBegan) {
        currentLayer = (g.view.tag == 1000) ? 1 : 2;
        self.view.backgroundColor = (g.view.tag == 1000) ?
        [UIColor colorWithRed:0 green:0.3 blue:0 alpha:1.0] :
        [UIColor colorWithRed:0.3 green:0 blue:0 alpha:1.0];
    } else if (g.state == UIGestureRecognizerStateEnded) {
        currentLayer = 0;
        self.view.backgroundColor = [UIColor blackColor];
    }
}


-(void)userPressed:(UILongPressGestureRecognizer *)g {
    UIImageView *v = (UIImageView *)g.view;
    if (g.state == UIGestureRecognizerStateBegan) {
         [[RemoteClient tool] userPressedButtonAtIndex:v.tag -10000];
    }
}

-(void)userTapped:(UITapGestureRecognizer *)g {
    UIImageView *v = (UIImageView *)g.view;
    
    if (!v.image) {
        return;
    }
    if (g.state == UIGestureRecognizerStateEnded) {
        [[RemoteClient tool] userTappedButtonAtIndex:v.tag - 10000 layer:currentLayer];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateToolbar];

    [self generateButtonGrid];
    
    [[RemoteClient tool] requestButtonList];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate {
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)t {
    [self cleanView];
    [self generateButtonGrid];
    [self paintButtons];
    [self updateToolbar];

}


@end
