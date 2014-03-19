//
//  NavViewController.m
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import "NavViewController.h"
#import "MenuViewController.h"


@interface NavViewController ()

@end

@implementation NavViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate {
    return ![RemoteClient tool].connecting;
}
- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)t {
    BOOL landscape = UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
    BOOL isiPad = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
    
    NSString *nibStr = @"MenuViewController";
    if (landscape) {
        nibStr = [nibStr stringByAppendingString:@"Landscape"];
    }
    
    if (isiPad) {
        nibStr = [nibStr stringByAppendingString:@"iPad"];
    }
    
    MenuViewController *vc = [[MenuViewController alloc] initWithNibName:nibStr bundle:nil];
    
    NSMutableArray *vcList = [self.viewControllers mutableCopy];
    [vcList replaceObjectAtIndex:0 withObject:vc];
    
    [self setViewControllers:[vcList copy] animated:NO];
    
    if ([vcList count] >1) {
        for (int x=1;x<[vcList count];x++) {
            UIViewController *vc = [vcList objectAtIndex:x];
            [vc willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:t];
        }
    }
    

}



@end
