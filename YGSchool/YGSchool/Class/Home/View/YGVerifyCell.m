//
//  YGVerifyCell.m
//  YGSchool
//
//  Created by faith on 17/2/21.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGVerifyCell.h"
#import "YGCommon.h"
@interface YGVerifyCell()
@property(nonatomic, strong)UILabel *titleLbl;
@property(nonatomic, strong)UILabel *timeLbl;
@property(nonatomic, strong)UILabel *nameLbl;
@property(nonatomic, strong)UILabel *statusLbl;
@property(nonatomic, strong)UIButton *moreBtn;
@end
@implementation YGVerifyCell
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
    self.titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 5,120 , 15)];
    self.titleLbl.font = [UIFont systemFontOfSize:14];
    self.timeLbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 150, 5,140 , 15)];
    self.timeLbl.font = [UIFont systemFontOfSize:14];
    self.timeLbl.textAlignment = NSTextAlignmentRight;
    self.timeLbl.textColor = COLOR(175, 175, 175, 1);
    self.nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 25,200 , 15)];
    self.nameLbl.font = [UIFont systemFontOfSize:14];
    self.nameLbl.textColor = COLOR(175, 175, 175, 1);
    self.statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 45,100 , 15)];
    self.statusLbl.font = [UIFont systemFontOfSize:14];
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 40 , 22, 20 , 20)];
    [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self addSubview:self.titleLbl];
    [self addSubview:self.timeLbl];
    [self addSubview:self.nameLbl];
    [self addSubview:self.statusLbl];
    [self addSubview:self.moreBtn];
    self.titleLbl.text = @"新的注册审核";
    self.timeLbl.text = @"16/12/19 12:40";
    self.nameLbl.text = @"测试45的家长2申请认证";
    self.statusLbl.text = @"状态: 已审核";
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
