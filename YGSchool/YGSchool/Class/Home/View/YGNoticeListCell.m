//
//  YGNoticeListCell.m
//  YGSchool
//
//  Created by faith on 17/2/20.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGNoticeListCell.h"
#import "YGCommon.h"
@interface YGNoticeListCell()
@property(nonatomic, strong)UILabel *titleLbl;
@property(nonatomic, strong)UILabel *timeLbl;
@property(nonatomic, strong)UIButton *moreBtn;

@end
@implementation YGNoticeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,kScreenWidth - 70 , 15)];
    self.timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 25,kScreenWidth - 70 , 15)];
    self.timeLbl.font = [UIFont systemFontOfSize:14];
    self.timeLbl.font = [UIFont systemFontOfSize:14];
    self.timeLbl.textColor = COLOR(175, 175, 175, 1);
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40 , 12, 20 , 20)];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self addSubview:self.titleLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.moreBtn];
    self.titleLbl.text = @"测试红点";
    self.timeLbl.text = @"16/12/19 12:40";
}
- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    self.titleLbl.text = dic[@"title"];
//    @"YYYY-MM-dd hh:mm:ss"
    NSInteger time = [dic[@"time"] integerValue];
    NSString *timeString = [YGTools timestampSwitchTime:time/1000 andFormatter:@"YY-MM-dd HH:mm:ss"];
    self.timeLbl.text = timeString;
    
}

@end
