//
//  SettingsTool.m
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/26/13.
//
//

#import "SettingsTool.h"
#import "MudClientIpad4AppDelegate.h"
#import "HelpViewController.h"

@implementation SettingsTool {
    NSShadow *blackShadowForText;
}

static SettingsTool *sharedSettingsManager = nil;

-(void)displayHelpForSection:(NSInteger )section {
    MudClientIpad4AppDelegate  *myAppDelegate = (MudClientIpad4AppDelegate *) [[UIApplication sharedApplication] delegate];
    [myAppDelegate.viewController dismissPopovers];
    
    
    HelpViewController *helpVC = [[HelpViewController alloc] initWithNibName:@"HelpViewController" bundle:nil];
    helpVC.section = section;
    [myAppDelegate.viewController presentViewController:helpVC animated:YES completion:^{
        
    }];
    
}


+ (SettingsTool*)settings
{
    if (sharedSettingsManager == nil) {
        sharedSettingsManager = [[super allocWithZone:NULL] init];
        
     
        
        
    }
    
    return sharedSettingsManager ;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self settings];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
-(UIColor*)colorWithHexString:(NSString*)hex withAlpha:(float)alpha {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    // strip # if it appears
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

-(UIColor *)stdBackgroundColor {
    return [UIColor colorWithWhite:0.0 alpha:1.0];
}

-(UIColor *)inputBackgroundColor {
    return [UIColor colorWithWhite:0.15 alpha:1.0];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    return [self colorWithHexString:hex withAlpha:1.0f];
}

-(NSShadow *)getBlackShadowForText {
    if (!blackShadowForText) {
        blackShadowForText = [[NSShadow alloc] init];
        blackShadowForText.shadowColor = [self colorWithHexString:@"#000000"];
        blackShadowForText.shadowOffset = CGSizeMake(1,1.0f);
    }
    return blackShadowForText;
}

-(NSString *)docsPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end