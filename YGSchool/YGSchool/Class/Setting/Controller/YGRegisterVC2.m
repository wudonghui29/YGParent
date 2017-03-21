//
//  YGRegisterVC2.m
//  YGSchool
//
//  Created by Faith on 2017/3/21.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGRegisterVC2.h"
#import "YGCommon.h"
@interface YGRegisterVC2 ()
@property(nonatomic, strong) YGBoardView *registerView;
@property(nonatomic, strong) UITextField *phoneTXF;
@property(nonatomic, strong) UITextField *verifyTXF;
@property(nonatomic, strong) UIButton *registerBtn;
@property(nonatomic, strong) UIButton *sendVerifyCode;
@property(nonatomic, strong) UILabel *sendVerifyLabel;
@property(nonatomic, assign) BOOL phoneType; //发送验证码状态
@property(nonatomic, assign) NSInteger timeNumber;

@end

@implementation YGRegisterVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.rightBtn.hidden = YES;
    self.phoneType = NO;
    self.view.backgroundColor = COLOR_WITH_HEX(0xebeef3);
    [self addSubView];

}
- (void)addSubView{
    [self.view addSubview:self.registerView];
    [self addTXF];
    [self addBtn];
}
- (YGBoardView *)registerView{
    if(!_registerView){
        _registerView = [[YGBoardView alloc] initWithFrame:CGRectMake(10, 90, kScreenWidth - 20, 60)];
        [_registerView setLineNumber:2];
        [_registerView setCorner:UIRectCornerAllCorners];
    }
    return _registerView;
}
- (void)addTXF{
    _phoneTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 40, 30)];
    _phoneTXF.font = [UIFont systemFontOfSize:16];
    _phoneTXF.placeholder = @"请输入您手机号码";
    [self.registerView addSubview:_phoneTXF];
    _verifyTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 31, kScreenWidth - 40, 30)];
    _verifyTXF.font = [UIFont systemFontOfSize:16];
    _verifyTXF.placeholder = @"请输入验证码";
    [self.registerView addSubview:_verifyTXF];
}
- (void)addBtn{
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 200, kScreenWidth - 50, 35)];
    self.registerBtn.layer.cornerRadius = 7;
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 125, 0, 1, 30)];
    lineView.backgroundColor = COLOR(221, 221, 221, 1);
    [_verifyTXF addSubview:lineView];
    _sendVerifyCode = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 120, 5, 80, 20)];
    _sendVerifyCode.layer.cornerRadius = 7;
    _sendVerifyCode.layer.borderColor = [UIColor grayColor].CGColor;
    _sendVerifyCode.layer.borderWidth = 1.0;
    [_sendVerifyCode.layer setMasksToBounds:YES];
    _sendVerifyCode.titleLabel.font = [UIFont systemFontOfSize:12];
    [_sendVerifyCode setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_sendVerifyCode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_sendVerifyCode addTarget:self action:@selector(sendVerifyCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [_verifyTXF addSubview:_sendVerifyCode];
    _sendVerifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    _sendVerifyLabel.font = [UIFont systemFontOfSize:12];
    _sendVerifyLabel.textAlignment = NSTextAlignmentCenter;
    [_sendVerifyCode addSubview:_sendVerifyLabel];
}
- (void)registerAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    NSString *alertMessage;
    if (!self.phoneType) {
        alertMessage = @"请发送验证码";
    }else{
        if([_verifyTXF.text length] == 0){
            alertMessage = @"请输入验证码";
            }else{
            NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
            [parameter setObject:@"register" forKey:@"event_code"];
            [parameter setObject:_phoneTXF.text forKey:@"phone"];
            [parameter setObject:_phoneTXF.text forKey:@"user_name"];
            [parameter setObject:_verifyTXF.text forKey:@"sms_code"];
            [YGNetWorkManager registerWithParameter:parameter completion:^(id responseObject) {
            } fail:^{
            }];
            return;
        }
        
    }
    alert.message = alertMessage;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)sendVerifyCodeAction{
    if([_phoneTXF.text isPhoneNumber]){
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_phoneTXF.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
            if(!error){
                NSLog(@"获取验证码成功");
                [MBProgressHUD showSuccess:@"发送验证码成功"];
                self.phoneType = YES;
                _phoneTXF.userInteractionEnabled = NO;
                _phoneTXF.textColor = [UIColor grayColor];
                self.timeNumber = 6;
                NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(time:) userInfo:nil repeats:YES];
                [timer fire];
                
            }else{
                NSLog(@"错误信息：%@",error);
                self.phoneType = NO;
            }
        }];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"手机号格式不正确" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)time:(NSTimer *)timer{
    self.sendVerifyCode.userInteractionEnabled = NO;
    self.sendVerifyLabel.text = [NSString stringWithFormat:@"%ldS再发送",self.timeNumber];
    self.sendVerifyCode.backgroundColor = [UIColor grayColor];
    _phoneTXF.userInteractionEnabled = NO;
    _phoneTXF.textColor = [UIColor grayColor];
    self.timeNumber--;
    if (self.timeNumber < 0) {
        [timer invalidate];
        timer = nil;
        self.sendVerifyCode.userInteractionEnabled =YES;
        self.sendVerifyLabel.text = @"发送验证码";
        //        self.FaSongBtn.backgroundColor = DefaultColor;
        _phoneTXF.userInteractionEnabled = YES;
        _phoneTXF.textColor = [UIColor blackColor];
    }
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
