//
//  NSString+utilty.h
//  YGSchool
//
//  Created by faith on 17/3/17.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (utilty)
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (NSString *)stringToMD5:(NSString *)str;
@end
