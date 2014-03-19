//
//  InviteView.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/12/13.
//
//

#import "InviteView.h"

@implementation InviteView {
    UILabel *l;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        
        l = [[UILabel alloc] initWithFrame:CGRectMake(0,10, 500,100)];
        l.textAlignment = NSTextAlignmentCenter;
        l.text = self.text;
        l.textColor = [UIColor whiteColor];
        
        UIButton *accept = [[UIButton alloc] initWithFrame:CGRectMake(100,200,100,44)];
        [accept setTitle:@"Allow" forState:UIControlStateNormal];
        [accept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [accept addTarget:self action:@selector(userTappedAccept) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *reject = [[UIButton alloc] initWithFrame:CGRectMake(300,200,100,44)];
        [reject setTitle:@"Reject" forState:UIControlStateNormal];

        [reject addTarget:self action:@selector(userTappedReject) forControlEvents:UIControlEventTouchUpInside];
        [reject setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:l];
        [self addSubview:accept];
        [self addSubview:reject];
        
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    l.text = self.text;
}

-(void)userTappedAccept {
    [self.delegate acceptInvitewithView:self];
}

-(void)userTappedReject {
    [self.delegate rejectInvitewithView:self];
}

@end
