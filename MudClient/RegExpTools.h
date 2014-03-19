//
//  RegExpTools.h
//  MudClientIpad4
//
//  Created by Gary Barnett on 10/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegExpTools : NSObject
+(NSMutableArray *)arrayOfComponentsFromString:(NSString *)sourceStr withRegExp:(NSString *)regexp;
+(NSString *)replaceMatchesInString:(NSString *)sourceStr usingRegExp:(NSString *)regexp withTemplate:(NSString *)templateStr caseSensitivity:(BOOL)caseSensitivity;
+(NSMutableArray *)arrayOfCaptureComponentMatches:(NSString *)sourceStr withRegExp:(NSString *)regexp;
@end
