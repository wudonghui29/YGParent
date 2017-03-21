//
//  YGRegisterVC.m
//  YGSchool
//
//  Created by faith on 17/2/16.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGRegisterVC.h"
#import "YGCommon.h"
@interface YGRegisterVC ()
{
    NSString *relation;
    NSString *selectSchoolID;
    NSString *selectClassID;
    NSString *selectStudentID;

}
@property(nonatomic, strong) YGBoardView *registerView;
@property(nonatomic, strong) YGRegisterShadeView *registerShadeView;
@property(nonatomic, strong) UITextField *phoneTXF;
//@property(nonatomic, strong) UITextField *verifyTXF;
@property(nonatomic, strong) UITextField *nameTXF;
@property(nonatomic, strong) UITextField *passwordTXF;
@property(nonatomic, strong) UITextField *repasswordTXF;
@property(nonatomic, strong) UIButton *registerBtn;
@property(nonatomic, assign) BOOL phoneType; //发送验证码状态
@property(nonatomic, assign) NSInteger timeNumber;
@property(nonatomic, strong) NSMutableArray *schoolArray;
@property(nonatomic, strong) NSMutableArray *classArray;
@property(nonatomic, strong) NSMutableArray *studentArray;
@property(nonatomic, strong) YGShadeView *shadeView1;
@property(nonatomic, strong) YGShadeView *shadeView2;
@property(nonatomic, strong) YGShadeView *shadeView3;

@end

@implementation YGRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.rightBtn.hidden = YES;
    self.phoneType = NO;
    self.view.backgroundColor = COLOR_WITH_HEX(0xebeef3);
    [self addSubView];
}
- (NSMutableArray *)schoolArray{
    if(!_schoolArray){
        _schoolArray = [[NSMutableArray alloc] init];
    }
    return _schoolArray;
}
- (NSMutableArray *)classArray{
    if(!_classArray){
        _classArray = [[NSMutableArray alloc] init];
    }
    return _classArray;
}
- (NSMutableArray *)studentArray{
    if(!_studentArray){
        _studentArray = [[NSMutableArray alloc] init];
    }
    return _studentArray;
}
- (YGBoardView *)registerView{
    if(!_registerView){
        _registerView = [[YGBoardView alloc] initWithFrame:CGRectMake(10, 90, kScreenWidth - 20, 120)];
        [_registerView setLineNumber:4];
        [_registerView setCorner:UIRectCornerTopLeft|UIRectCornerTopRight];
    }
    return _registerView;
}
- (YGRegisterShadeView *)registerShadeView{
    if(!_registerShadeView){
        _registerShadeView = [[YGRegisterShadeView alloc] initWithFrame:CGRectMake(0, 240, kScreenWidth, 120)];
    }
    return _registerShadeView;
}
- (void)addSubView{
    [self.view addSubview:self.registerView];
    [self addTXF];
    [self addBtn];
}
- (void)addTXF{
    _phoneTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth - 40, 30)];
    _phoneTXF.font = [UIFont systemFontOfSize:16];
    _phoneTXF.text = self.phone;
    _phoneTXF.enabled = NO;
    [self.registerView addSubview:_phoneTXF];
    _nameTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 31, kScreenWidth - 40, 30)];
    _nameTXF.font = [UIFont systemFontOfSize:16];
    _nameTXF.placeholder = @"请输入您的姓名";
    [self.registerView addSubview:_nameTXF];
    _passwordTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 61, kScreenWidth - 40, 30)];
    _passwordTXF.font = [UIFont systemFontOfSize:16];
    _passwordTXF.secureTextEntry = YES;
    _passwordTXF.placeholder = @"请输入密码";
    [self.registerView addSubview:_passwordTXF];
    _repasswordTXF = [[UITextField alloc] initWithFrame:CGRectMake(10, 91, kScreenWidth - 40, 30)];
    _repasswordTXF.secureTextEntry = YES;
    _repasswordTXF.font = [UIFont systemFontOfSize:16];
    _repasswordTXF.placeholder = @"请再次输入密码";
    [self.registerView addSubview:_repasswordTXF];
    
    [self.view addSubview:self.registerShadeView];
    __block YGRegisterVC *weakVC = self;
    self.registerShadeView.chooseSchBlock = ^{
        [weakVC getSchoolList];
        YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        __block YGShadeView *weakShadeView  = shadeView;
        _shadeView1 = shadeView;
        shadeView.chooseBlock = ^(NSString *title){
            for(NSDictionary *dic in weakVC.schoolArray){
                if([title isEqualToString:dic[@"name"]]){
                    selectSchoolID = dic[@"school_id"];
                    break;
                }
            }

            weakVC.registerShadeView.chooseSchTXF.text = title;
            // 获取所有的学校可以在控制器中，也可以在view中
            [weakShadeView dissmiss];
            [weakVC.registerShadeView showChooseClass];
        };
        [weakVC.view.window addSubview:shadeView];

    };
    self.registerShadeView.chooseClassBlock = ^{
        [self getClassList];
        YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        _shadeView2 = shadeView;
        __block YGShadeView *weakShadeView  = shadeView;
        shadeView.chooseBlock = ^(NSString *title){
            for(NSDictionary *dic in self.classArray){
                if([title isEqualToString:dic[@"name"]]){
                    selectClassID = dic[@"class_id"];
                    break;
                }
            }

            weakVC.registerShadeView.chooseClassTXF.text = title;
            [weakShadeView dissmiss];
            [weakVC.registerShadeView showChooseStudent];
        };
        [weakVC.view.window addSubview:shadeView];
    };
    self.registerShadeView.chooseStudentBlock = ^{
        [self getStudentList];
        YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        _shadeView3 = shadeView;
        __block YGShadeView *weakShadeView  = shadeView;
        shadeView.chooseBlock = ^(NSString *title){
            for(NSDictionary *dic in self.studentArray){
                if([title isEqualToString:dic[@"name"]]){
                    selectStudentID = dic[@"student_id"];
                    break;
                }
            }

            weakVC.registerShadeView.chooseStudentTXF.text = title;
            [weakShadeView dissmiss];
            //            [weakbindShadeView showChooseStudent];
        };
        [weakVC.view.window addSubview:shadeView];
    };
}
- (void)addBtn{
    self.registerBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 380, kScreenWidth - 50, 35)];
    self.registerBtn.layer.cornerRadius = 7;
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    [self.registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 125, 0, 1, 30)];
    lineView.backgroundColor = COLOR(221, 221, 221, 1);
}
- (void)registerAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    NSString *alertMessage;
    if([_nameTXF.text length] ==0){
        alertMessage = @"请输入您的姓名";
    }else if ([_passwordTXF.text length]==0 || [_repasswordTXF.text length] ==0){
        alertMessage = @"请输入密码";
    }else if (![_passwordTXF.text isEqualToString:_repasswordTXF.text]){
        alertMessage = @"两次密码不相同";
    }else if ([self.registerShadeView.chooseSchTXF.text length] ==0 || selectSchoolID == nil){
        alertMessage = @"请选择您的孩子所在的学校";
    }else if ([self.registerShadeView.chooseClassTXF.text length] ==0 || selectClassID == nil){
        alertMessage = @"请选择您要关联的学生所在的班级";
    }else if ([self.registerShadeView.chooseStudentTXF.text length] ==0 || selectStudentID == nil){
        alertMessage = @"请填写您要关联的学生";
    }else if ([self.registerShadeView.relationTXF.text length] ==0){
        alertMessage = @"请填写您和学生的关系";
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        NSString *password = [_passwordTXF.text stringToMD5:_passwordTXF.text];
        [dic setObject:@"register" forKey:@"event_code"];
        [dic setObject:_phoneTXF.text forKey:@"phone"];
        [dic setObject:_phoneTXF.text forKey:@"user_name"];
        [dic setObject:@"0000" forKey:@"sms_code"];

        [dic setObject:_nameTXF.text forKey:@"name"];
        [dic setObject:_passwordTXF.text forKey:@"password"];
        [dic setObject:selectSchoolID forKey:@"school_id"];
        [dic setObject:selectClassID forKey:@"class_id"];
        [dic setObject:selectStudentID forKey:@"student_id"];
        [dic setObject:self.registerShadeView.relationTXF.text forKey:@"relation"];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        NSString *str = [YGTools convertToJsonString:dic];
        [parameter setObject:str forKey:@"content"];
        [YGNetWorkManager registerWithParameter:parameter completion:^(id responseObject) {
            NSLog(@"responseObject:%@",responseObject);
            [MBProgressHUD showSuccess:@"注册成功"];
            YGLoginVC *loginVC = [[YGLoginVC alloc] init];
            
            [self presentViewController:loginVC animated:YES completion:nil];
        } fail:^{
        }];
        return;
    }
    alert.message = alertMessage;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)getSchoolList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"schoolList" forKey:@"event_code"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    NSLog(@"parameter:%@",parameter);
    [YGNetWorkManager getSchoolListWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        self.schoolArray = responseObject[@"list"];
        NSMutableArray *a = [[NSMutableArray alloc] initWithObjects:@"请选择您的孩子所在的学校", nil];
        for(int i = 0; i < self.schoolArray.count; i++){
            NSDictionary *dic = self.schoolArray[i];
            [a addObject:dic[@"name"]];
        }
        _shadeView1.titleArray = a;
    } fail:^{
        NSLog(@"");
    }];
}

- (void)getClassList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"classList" forKey:@"event_code"];
    [dic setObject:selectSchoolID forKey:@"school_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    [YGNetWorkManager getClassListWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        self.classArray = responseObject[@"list"];
        NSMutableArray *a = [[NSMutableArray alloc] initWithObjects:@"请选择您要关联的学生所在的班级", nil];
        for(int i = 0; i < self.classArray.count; i++){
            NSDictionary *dic = self.classArray[i];
            [a addObject:dic[@"name"]];
        }
        _shadeView2.titleArray = a;
        
    } fail:^{
        
    }];
}

- (void)getStudentList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"studentList" forKey:@"event_code"];
    [dic setObject:selectSchoolID forKey:@"school_id"];
    [dic setObject:selectClassID forKey:@"class_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    [YGNetWorkManager getStudentListWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        self.studentArray = responseObject[@"list"];
        NSMutableArray *a = [[NSMutableArray alloc] initWithObjects:@"请选择您要关联的学生", nil];
        for(int i = 0; i < self.studentArray.count; i++){
            NSDictionary *dic = self.studentArray[i];
            [a addObject:dic[@"name"]];
        }
        _shadeView3.titleArray = a;
        
    } fail:^{
        
    }];
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
