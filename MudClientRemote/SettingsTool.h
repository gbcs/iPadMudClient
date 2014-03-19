//
//  SettingsTool.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/26/13.
//
//

#import <Foundation/Foundation.h>

@interface SettingsTool : NSObject

+ (SettingsTool*)settings;
-(UIColor*)colorWithHexString:(NSString*)hex withAlpha:(float)alpha;
-(UIColor*)colorWithHexString:(NSString*)hex;
-(UIColor *)stdBackgroundColor;
-(UIColor *)inputBackgroundColor;

-(UIImage *)randomButtonImage;
-(NSArray *)buttonImages;
@end
