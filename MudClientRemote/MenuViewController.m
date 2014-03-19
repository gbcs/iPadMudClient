//
//  MenuViewController.m
//  Mud Client Remote
//
//  Created by Gary Barnett on 9/27/13.
//  Copyright (c) 2013 gbcs. All rights reserved.
//

#import "MenuViewController.h"
#import "KeyboardViewController.h"
#import "ButtonViewController.h"


@interface MenuViewController () {
    NSInteger selected;
    IBOutlet UIView *connectingView;
    __weak IBOutlet UITableView *tv;
  
    __weak IBOutlet GradientAttributedButton *connect;

    __weak IBOutlet GradientAttributedButton *buttons;
    __weak IBOutlet GradientAttributedButton *keyboard;
    MCPeerID *selectedPeer;
    UIDynamicAnimator *animator;
    UICollisionBehavior *collision;
    NSArray *nib;
    BOOL connecting;
    UIDynamicAnimator *connectingAnimator;
    NSInteger connectionTimeout;
}

@end

@implementation MenuViewController

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
    self.navigationItem.title = @"Mud Client Remote";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(peerListChanged:) name:@"peerListChanged" object:nil];
    [self peerListChanged:nil];
    
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0,0,connectingView.bounds.size.width, 30)];
    l.textAlignment = NSTextAlignmentCenter;
    l.text = @"Connecting";
    l.textColor = [UIColor blackColor];
    [connectingView addSubview:l];
    
    UIImageView *i = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    i.contentMode = UIViewContentModeScaleAspectFit;
    i.image = [[SettingsTool settings] randomButtonImage];
    i.tag = 999;
    [connectingView addSubview:i];
    
    connectingAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:connectingView];
    
    connectingView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    connectingView.layer.cornerRadius = 8;
    connectingView.layer.borderWidth = 2;
    connectingView.layer.borderColor = [UIColor colorWithWhite:0.10 alpha:1.0].CGColor;
 
    
   // UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:connectingView.bounds];
    connectingView.layer.masksToBounds = NO;
    connectingView.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:1.0].CGColor;
    connectingView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    connectingView.layer.shadowOpacity = 0.5f;
    connectingView.layer.shadowRadius = 2.0f;
   // connectingView.layer.shadowPath = shadowPath.CGPath;

    
}

-(void)peerListChanged:(NSNotification *)n {
    [self performSelectorOnMainThread:@selector(resetList) withObject:nil waitUntilDone:NO];
}
-(void)resetList {
    selectedPeer = nil;
    [tv reloadData];
    [self selectFirst];
}

-(void)userPressedGradientAttributedButtonWithTag:(int)tag {
    switch (tag) {
        case 0:
        case 1:
        case 2:
            selected = tag;
            [self updateButtons];
            break;
        case 3:
        {
            if ([RemoteClient tool].connecting) {
                return;
            }
                
            if (selectedPeer) {
                [RemoteClient tool].connecting = YES;
                CGSize s = connectingView.bounds.size;
                
                connectingView.frame = CGRectMake((self.view.bounds.size.width /2.0f) - (s.width / 2.0f), -(s.height), s.width, s.height);
                [self.view addSubview:connectingView];
                animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
                UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[ connectingView ]];
                collision = [[UICollisionBehavior alloc] initWithItems:@[ connectingView]];
                
                //NSLog(@"bounds:%@", [NSValue valueWithCGRect:self.view.bounds]);
                
                CGFloat collisionBoundary = (self.view.bounds.size.height / 2.0f) + (s.height /2.0f);
                if (collisionBoundary > self.view.bounds.size.height) {
                    collisionBoundary = self.view.bounds.size.height;
                }
                
                
                [collision addBoundaryWithIdentifier:@"bottom" fromPoint:CGPointMake(0, collisionBoundary) toPoint:CGPointMake(self.view.frame.size.width, collisionBoundary)];
                
                [animator addBehavior:gravity];
                [animator addBehavior:collision];
                
                [[RemoteClient tool] invitePeer:selectedPeer];
                selectedPeer = nil;
                connectionTimeout = 15;
                [self performSelector:@selector(checkForConnection) withObject:nil afterDelay:1.0];
                UIImageView *i = (UIImageView *)[connectingView viewWithTag:999];
                i.center = CGPointMake(connectingView.bounds.size.width / 2.0f, 60);
                
                [self performSelector:@selector(startConnectingView) withObject:nil afterDelay:1.0];
            }
        
        }
            break;
    }
}

-(void)startConnectingView {
    UIImageView *i = (UIImageView *)[connectingView viewWithTag:999];
    i.center = CGPointMake(connectingView.bounds.size.width / 2.0f, 60);
    
    UICollisionBehavior *c = [[UICollisionBehavior alloc] initWithItems:@[ i ] ];
    [c  setTranslatesReferenceBoundsIntoBoundary:YES];
    [connectingAnimator addBehavior:c];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[ i ]];
    [connectingAnimator addBehavior:gravity];
    
    UIDynamicItemBehavior *elasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[ i]];
    elasticityBehavior.elasticity = 0.98f;
     [connectingAnimator addBehavior:elasticityBehavior];
    
}

-(void)stopConnectingView {
    [RemoteClient tool].connecting = NO;
    [connectingAnimator removeAllBehaviors];
}


-(void)nextPage {
    switch (selected) {
        case 0:
        {
            [RemoteClient tool].role = kRoleKeyboard;
            
            KeyboardViewController *vc = [[KeyboardViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            [RemoteClient tool].role = kRoleButtons;
            
            ButtonViewController *vc = [[ButtonViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
    }
}

-(void)endConnectionViewAnimation {
    [animator removeBehavior:collision];
    collision = nil;
    [self performSelector:@selector(stopConnectingView) withObject:nil afterDelay:1.5];
}

-(void)checkForConnection {
    if ([[[RemoteClient tool] connectedPeers] count] >0) {
        [self endConnectionViewAnimation];
        [self performSelector:@selector(nextPage) withObject:nil afterDelay:1.5];
    } else {
        connectionTimeout--;
        if (connectionTimeout <1) {
            [self endConnectionViewAnimation];
        } else {
            [self performSelector:@selector(checkForConnection) withObject:nil afterDelay:1.0];
        }
    }
}

-(void)updateButtons {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [[SettingsTool settings] colorWithHexString:@"#FFFFFF"];
    shadow.shadowOffset = CGSizeMake(0,-1.0f);
    
    
	NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[style setAlignment:NSTextAlignmentCenter];
    
    NSDictionary *a = @{
                        NSFontAttributeName : [UIFont systemFontOfSize:[UIFont buttonFontSize]],
                        NSShadowAttributeName : shadow,
                        NSForegroundColorAttributeName : [[SettingsTool settings] colorWithHexString:@"#FFFFFF"],
                        NSParagraphStyleAttributeName  : style
                        };
    
    
    NSAttributedString *connectText = [[NSAttributedString alloc] initWithString:@"Connect" attributes:a];
     NSAttributedString *keyboardText = [[NSAttributedString alloc] initWithString:@"Keyboard" attributes:a];
    NSAttributedString *buttonText = [[NSAttributedString alloc] initWithString:@"Buttons" attributes:a];
   
    NSString *bgSelectedBegin =@"#000099";
    NSString *bgSelectedEnd =@"#000066";
    
    NSString *bgNotSelectedBegin =@"#009900";
    NSString *bgNotSelectedEnd =@"#006600";
    
    
    NSString *bgConnectBegin =@"#000099";
    NSString *bgConnectEnd =@"#000066";
   
    NSString *bgConnectDisabledBegin =@"#999999";
    NSString *bgConnectDisabledEnd =@"#AAAAAA";

    [connect setTitle:connectText disabledTitle:connectText beginGradientColorString:selectedPeer ?  bgConnectBegin : bgConnectDisabledBegin endGradientColor:selectedPeer ?  bgConnectEnd : bgConnectDisabledEnd];
     [keyboard setTitle:keyboardText disabledTitle:keyboardText beginGradientColorString:(selected == 0) ? bgSelectedBegin : bgNotSelectedBegin endGradientColor:(selected == 0) ? bgSelectedEnd : bgNotSelectedEnd];
    [buttons setTitle:buttonText disabledTitle:buttonText beginGradientColorString:(selected == 1) ? bgSelectedBegin : bgNotSelectedBegin endGradientColor:(selected == 1) ? bgSelectedEnd : bgNotSelectedEnd];
    
    [connect update];
   
    [keyboard update];
    [buttons update];
  
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    connect.enabled = YES;
     keyboard.enabled = YES;
    buttons.enabled = YES;
    
    connect.delegate = self;
    keyboard.delegate = self;
    buttons.delegate = self;
    
    [self updateButtons];
    [self selectFirst];
   
}

-(void)selectFirst {
    if ([[RemoteClient tool] availablePeers] && ([[[RemoteClient tool] availablePeers] count]>0)) {
        if (!selectedPeer) {
            selectedPeer = [[[RemoteClient tool] availablePeers] objectAtIndex:0];
            UITableViewCell *cell = [tv cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setSelected:YES];
        }
    } else {
        selectedPeer = nil;
    }
    
    [self updateButtons];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self updateButtons];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedPeer = [[[RemoteClient tool] availablePeers] objectAtIndex:indexPath.row];
    [self updateButtons];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedPeer = nil;
    [self updateButtons];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//
//	switch (section) {
//		case 0:
//			return @"Mud Client for Ipad - Listing";
//			break;
//	}
//
//	return nil;
//}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Only one section.
    return 1;
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	 
	return [[RemoteClient tool] availablePeers] ? [[[RemoteClient tool] availablePeers] count] : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    MCPeerID *peer = [[[RemoteClient tool] availablePeers] objectAtIndex:indexPath.row];
   
	cell.textLabel.text = peer.displayName;
	cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
	return cell;
}


@end
