//
//  YGLeaveShadeView.m
//  YGSchool
//
//  Created by faith on 17/2/23.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGLeaveShadeView.h"
#import "YGCommon.h"
@interface YGLeaveShadeView()
@end
@implementation YGLeaveShadeView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubViews];
    }
    return self;
}
- (YGBoardView *)boardView{
    if(!_boardView){
        _boardView = [[YGBoardView alloc] initWithFrame:CGRectMake(40, 100, kScreenWidth - 80, 120)];
        [_boardView setLineNumber:3];
        [_boardView setCorner:UIRectCornerAllCorners];
    }
    return _boardView;
}

- (void)addSubViews{
    
    [self addSubview:self.boardView];
    _chooseStudentTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 100, 30)];
    _chooseStudentTXF.delegate = self;
    _chooseStudentTXF.font = [UIFont systemFontOfSize:16];
    _chooseStudentTXF.placeholder = @"选择学生";
    
    [self.boardView addSubview:_chooseStudentTXF];
    _chooseDateTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 31, kScreenWidth - 100, 30)];
    _chooseDateTXF.delegate = self;
    _chooseDateTXF.font = [UIFont systemFontOfSize:16];
    _chooseDateTXF.placeholder = @"请假起始日期";
    [self.boardView addSubview:_chooseDateTXF];
    _leaveDaysTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 61, kScreenWidth - 100, 30)];
    _leaveDaysTXF.font = [UIFont systemFontOfSize:16];
    _leaveDaysTXF.placeholder = @"请假天数";
    [self.boardView addSubview:_leaveDaysTXF];
    _reasonTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 91, kScreenWidth - 100, 30)];
    _reasonTXF.font = [UIFont systemFontOfSize:16];
    _reasonTXF.placeholder = @"请假事由";
    [self.boardView addSubview:_reasonTXF];
    
    UIButton *confirm = [[UIButton alloc] initWithFrame:CGRectMake(40, 250, kScreenWidth - 80, 35)];
    confirm.tag = 0;
    confirm.layer.cornerRadius = 7;
    [confirm.layer setMasksToBounds:YES];
    [confirm setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    [confirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirm setTitle:@"确认" forState:UIControlStateNormal];
    [confirm addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirm];

    [self addSubview:confirm];
    
    UIButton *cancle = [[UIButton alloc] initWithFrame:CGRectMake(40, 305, kScreenWidth - 80, 35)];
    cancle.tag = 1;
    cancle.layer.cornerRadius = 7;
    [cancle.layer setMasksToBounds:YES];
    [cancle setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    [cancle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancle];

    [UIView animateWithDuration:KAnimationInterval animations:^{
        self.top = 0;
    }];

}
- (void)dissmiss{
    [UIView animateWithDuration:KAnimationInterval animations:^{
        self.top = kScreenHeight;
    }];
}

- (void)btnAction:(UIButton *)sender{
    if(self.clickBlock){
        self.clickBlock(sender.tag);
    }
}
#pragma mark - UITextFieldDelegate 
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if([textField isEqual:_chooseStudentTXF]){
        if(self.chooseStudentBlock){
            self.chooseStudentBlock();
        }
    }else if([textField isEqual:_chooseDateTXF]){
        if(self.chooseDateBlock){
            self.chooseDateBlock();
        }
    }
}
@end