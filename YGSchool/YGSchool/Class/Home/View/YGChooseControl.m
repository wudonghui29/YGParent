//
//  YGChooseControl.m
//  YGSchool
//
//  Created by faith on 17/2/21.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGChooseControl.h"
#import "YGCommon.h"
@interface YGChooseControl()
@end
@implementation YGChooseControl

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 2;
        self.layer.borderColor =BG_COLOR.CGColor;
        [self addSubViews];
    }
    return self;
}
- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self.first setTitle:_titleArray[0] forState:UIControlStateNormal];
    [self.second setTitle:_titleArray[1] forState:UIControlStateNormal];
}
- (void)addSubViews{
    self.first = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth -80)/2, 35)];
    self.first.tag = 0;
    self.first.titleLabel.font = [UIFont systemFontOfSize:14];
    self.first.backgroundColor = BG_COLOR;
    [self.first setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.first.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.first.bounds;
    maskLayer.path = maskPath.CGPath;
    self.first.layer.mask = maskLayer;
    
    
    [self.first addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.first];
    
    self.second = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth -80)/2, 0, (kScreenWidth -80)/2, 35)];
    self.second.tag = 1;
    self.second.titleLabel.font = [UIFont systemFontOfSize:14];
    self.second.backgroundColor = [UIColor whiteColor];
    [self.second setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.second.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = self.second.bounds;
    maskLayer2.path = maskPath2.CGPath;
    self.second.layer.mask = maskLayer2;
    [self.second addTarget:self action:@selector(chooseAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.second];
    
}
- (void)chooseAction:(UIButton *)sender{
    _currentBtn = sender;
    if(sender.tag == 0){
        [self firstIsSelected];
        
    }else{
        [self secondIsSelected];
        
    }
//    if(self.switchBlock){
//        self.switchBlock(sender.tag);
//    }
}
- (void)firstIsSelected{
    [self.first setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.second setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.first setBackgroundColor:BG_COLOR];
    [self.second setBackgroundColor:[UIColor whiteColor]];
    if(self.switchBlock){
        self.switchBlock(_currentBtn.tag);
    }


}
- (void)secondIsSelected{
    [self.first setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.second setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.first setBackgroundColor:[UIColor whiteColor]];
    [self.second setBackgroundColor:BG_COLOR];
    if(self.switchBlock){
        self.switchBlock(_currentBtn.tag);
    }

}
@end
