//
//  YGHomeItemCell.m
//  YGSchool
//
//  Created by faith on 17/2/15.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGHomeItemCell.h"
#import "YGCommon.h"
@interface YGHomeItemCell()
{
    UIImageView *iconImageView;
}
@end
@implementation YGHomeItemCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, (kScreenWidth-40)/3, kScreenWidth/4)];
        //        goodView.backgroundColor = [UIColor yellowColor];
       

    }
    return self;
}


@end
