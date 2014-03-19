//
//  SettingsTool.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 9/26/13.
//
//

#import <Foundation/Foundation.h>

#define kHelpSectionMain 0
#define kHelpSectionAddCharacter 1
#define kHelpSectionAlias 2
#define kHelpSectionMacro 3
#define kHelpSectionTrigger 4
#define kHelpSectionSpeedwalking 5
#define kHelpSectionSettings 6
#define kHelpSectionVariable 7


@interface SettingsTool : NSObject

+ (SettingsTool*)settings;
-(UIColor*)colorWithHexString:(NSString*)hex withAlpha:(float)alpha;
-(UIColor*)colorWithHexString:(NSString*)hex;
-(UIColor *)stdBackgroundColor;
-(UIColor *)inputBackgroundColor;

-(void)displayHelpForSection:(NSInteger )section;
@end
