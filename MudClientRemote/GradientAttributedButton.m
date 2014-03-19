//
//  GradientAttributedButton.m
//  Capture
//
//  Created by Gary Barnett on 9/4/13.
//  Copyright (c) 2013 Gary Barnett. All rights reserved.
//

#import "GradientAttributedButton.h"

@implementation GradientAttributedButton {
    NSAttributedString *title;
    NSAttributedString *titleDisabled;
    
    UIColor *bgBeginGradientColor;
    UIColor *bgEndGradientColor;
    
    UILabel *label;
    BOOL applyGradient;
}

-(void)setTitle:(NSAttributedString *)buttonTitle disabledTitle:(NSAttributedString *)buttonDisabledTitle beginGradientColorString:(NSString *)bgGradientColorBegin endGradientColor:(NSString *)bgGradientColorEnd {
    title = buttonTitle;
    titleDisabled = buttonDisabledTitle;
    bgBeginGradientColor = [[SettingsTool settings] colorWithHexString:bgGradientColorBegin];
    bgEndGradientColor = [[SettingsTool settings] colorWithHexString:bgGradientColorEnd];
    [self update];
}

-(void)update {
    self.backgroundColor = [UIColor clearColor];
    
    if (!label) {
        label = [[UILabel alloc] initWithFrame:self.bounds];
        [self addSubview:label];
        
        UILongPressGestureRecognizer *longG = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(userPressed:)];
        [self addGestureRecognizer:longG];
        longG.minimumPressDuration = 0.001;
        self.userInteractionEnabled  = YES;

    }
    
    label.frame = CGRectInset(self.bounds, 10,0);
    
    label.attributedText = self.enabled ? title : titleDisabled;
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    applyGradient = YES;
    
    [self setNeedsDisplay];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
         }
    return self;
}

-(void)userPressed:(UILongPressGestureRecognizer *)g {
    if (!self.enabled) {
        return;
    }
    
    if (g.state == UIGestureRecognizerStateBegan) {
        applyGradient = NO;
        [self setNeedsDisplay];
    } else if (g.state == UIGestureRecognizerStateEnded) {
        applyGradient = YES;
        [self setNeedsDisplay];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate userPressedGradientAttributedButtonWithTag:(int)self.tag];
        });
    }
}


- (void)drawRect:(CGRect)rect
{
    
    CGGradientRef gradient = [self normalGradient];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef outlinePath = CGPathCreateMutable();
    float offset = 5.0;
    float w  = [self bounds].size.width;
    float h  = [self bounds].size.height;
    CGPathMoveToPoint(outlinePath, nil, offset*2.0, offset);
    CGPathAddArcToPoint(outlinePath, nil, offset, offset, offset, offset*2, offset);
    CGPathAddLineToPoint(outlinePath, nil, offset, h - offset*2.0);
    CGPathAddArcToPoint(outlinePath, nil, offset, h - offset, offset *2.0, h-offset, offset);
    CGPathAddLineToPoint(outlinePath, nil, w - offset *2.0, h - offset);
    CGPathAddArcToPoint(outlinePath, nil, w - offset, h - offset, w - offset, h - offset * 2.0, offset);
    CGPathAddLineToPoint(outlinePath, nil, w - offset, offset*2.0);
    CGPathAddArcToPoint(outlinePath, nil, w - offset , offset, w - offset*2.0, offset, offset);
    CGPathCloseSubpath(outlinePath);
    
    CGContextSetShadow(ctx, CGSizeMake(0,2), 3);
    CGContextAddPath(ctx, outlinePath);
    CGContextFillPath(ctx);
    
    CGContextAddPath(ctx, outlinePath);
    CGContextClip(ctx);
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.size.height);
    CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
    
    CGPathRelease(outlinePath);
}

- (CGGradientRef)normalGradient
{
    
    NSMutableArray *normalGradientLocations = nil;
    
    if (applyGradient ) {
        normalGradientLocations = [NSMutableArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:1.0f],
                                   nil];
    }
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:2];
    
    [colors addObject:(id)[bgBeginGradientColor CGColor]];
    
    if (applyGradient) {
        if (bgEndGradientColor) {
            [colors addObject:(id)[bgEndGradientColor CGColor]];
        } else {
            [colors addObject:(id)[bgBeginGradientColor CGColor]];
        }
    }
    
    NSMutableArray  *normalGradientColors = colors;
    
    NSInteger locCount = [normalGradientLocations count];
    CGFloat locations[locCount];
    for (int i = 0; i < [normalGradientLocations count]; i++)
    {
        NSNumber *location = [normalGradientLocations objectAtIndex:i];
        locations[i] = [location floatValue];
    }
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    
    CGGradientRef normalGradient = CGGradientCreateWithColors(space, (CFArrayRef)normalGradientColors, locations);
    CGColorSpaceRelease(space);
    
    return normalGradient;
}


@end
