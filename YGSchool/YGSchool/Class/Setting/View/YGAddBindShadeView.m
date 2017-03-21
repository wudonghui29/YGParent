//
//  YGAddBindShadeView.m
//  YGSchool
//
//  Created by faith on 17/2/23.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGAddBindShadeView.h"
#import "YGCommon.h"
@interface YGAddBindShadeView()<UITextFieldDelegate>
{
    UIView *lineView1;
    UIView *lineView2;
    UIView *lineView3;

}
@end
@implementation YGAddBindShadeView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
        [self addSubViews];
    }
    return self;
}
- (void)addSubViews{
    self.chooseSchTXF = [[UITextField alloc] initWithFrame:CGRectMake(40, 120,kScreenWidth-80 , 40)];
    self.chooseSchTXF.backgroundColor = [UIColor whiteColor];
    self.chooseSchTXF.delegate = self;
    self.chooseSchTXF.placeholder = @"请选择您的孩子所在的学校";
    [self addSubview:self.chooseSchTXF];
    lineView1 = [[UIView alloc] initWithFrame:CGRectMake(40, 159, kScreenWidth-80, 1)];
    lineView1.backgroundColor = COLOR(221, 221, 221, 1);
    [self addSubview:lineView1];
    
    self.chooseClassTXF = [[UITextField alloc] initWithFrame:CGRectMake(40, 160,kScreenWidth-80 , 40)];
    self.chooseClassTXF.delegate = self;
    self.chooseClassTXF.backgroundColor = [UIColor whiteColor];
    self.chooseClassTXF.placeholder = @"请选择您要关联的学生所在的班级";
    [self addSubview:self.chooseClassTXF];

    lineView2 = [[UIView alloc] initWithFrame:CGRectMake(40, 199, kScreenWidth-80, 1)];
    lineView2.backgroundColor = COLOR(221, 221, 221, 1);
    [self addSubview:lineView2];

    self.chooseStudentTXF = [[UITextField alloc] initWithFrame:CGRectMake(40, 200,kScreenWidth-80 , 40)];
    self.chooseStudentTXF.delegate = self;
    self.chooseStudentTXF.backgroundColor = [UIColor whiteColor];
    self.chooseStudentTXF.placeholder = @"请选择您要关联的学生";
    [self addSubview:self.chooseStudentTXF];
    
    lineView3 = [[UIView alloc] initWithFrame:CGRectMake(40, 239, kScreenWidth-80, 1)];
    lineView3.backgroundColor = COLOR(221, 221, 221, 1);
    [self addSubview:lineView3];
    
    self.relationTXF = [[UITextField alloc] initWithFrame:CGRectMake(40, 240,kScreenWidth-80 , 40)];
    self.relationTXF.backgroundColor = [UIColor whiteColor];
    self.relationTXF.placeholder = @"请选择您和该学生的关系";
    [self addSubview:self.relationTXF];
    
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 300, kScreenWidth - 80, 30)];
    [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _confirmBtn.tag = 0;
    [_confirmBtn setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _confirmBtn.layer.cornerRadius = 7;
    [_confirmBtn.layer setMasksToBounds:YES];
    [_confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self addSubview:_confirmBtn];

    
    _cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 350, kScreenWidth - 80, 30)];
    _cancleBtn.tag = 1;
    [_cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_cancleBtn setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _cancleBtn.layer.cornerRadius = 7;
    [_cancleBtn.layer setMasksToBounds:YES];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:_cancleBtn];
    
    lineView2.hidden = YES;
    lineView3.hidden = YES;
    self.chooseClassTXF.hidden = YES;
    self.chooseStudentTXF.hidden = YES;
    self.relationTXF.top = 160;
    self.confirmBtn.top = 240;
    self.cancleBtn.top = 300;
    
    [UIView animateWithDuration:KAnimationInterval animations:^{
        self.top = 0;
    }];

}
- (void)showChooseClass{
    lineView2.hidden = NO;
    self.chooseClassTXF.hidden = NO;
    self.relationTXF.top = 200;
    self.confirmBtn.top = 280;
    self.cancleBtn.top = 340;
}
- (void)showChooseStudent{
    lineView3.hidden = NO;
    self.chooseStudentTXF.hidden = NO;
    self.relationTXF.top = 240;
    self.confirmBtn.top = 320;
    self.cancleBtn.top = 380;
}
- (void)cancleAction:(UIButton *)sender{
    [self dissmiss];
}
- (void)dissmiss{
    [UIView animateWithDuration:KAnimationInterval animations:^{
        self.top = kScreenHeight;
    }];
}

- (void)btnAction:(UIButton *)sender{
    [self dissmiss];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    if([textField isEqual:_chooseSchTXF]){
        if(self.chooseSchBlock){
            self.chooseSchBlock();
        }
    }
    if([textField isEqual:_chooseClassTXF]){
        if(self.chooseClassBlock){
            self.chooseClassBlock();
        }
    }
    if([textField isEqual:_chooseStudentTXF]){
        if(self.chooseStudentBlock){
            self.chooseStudentBlock();
        }
    }


}
@end
