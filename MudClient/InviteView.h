//
//  InviteView.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/12/13.
//
//

#import <UIKit/UIKit.h>


@protocol InviteDelegate <NSObject>
-(void)acceptInvitewithView:(UIView *)v;
-(void)rejectInvitewithView:(UIView *)v;
@end

@interface InviteView : UIView
@property (nonatomic, weak) NSObject <InviteDelegate> *delegate;;
@property (nonatomic, strong) NSString *text;

@end
