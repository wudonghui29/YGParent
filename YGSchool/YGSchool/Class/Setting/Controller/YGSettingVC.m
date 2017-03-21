//
//  YGSettingVC.m
//  YGSchool
//
//  Created by faith on 17/2/15.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGSettingVC.h"
#import "YGCommon.h"
@interface YGSettingVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic ,strong) UIImageView *iconImageView;
@property(nonatomic ,strong) UILabel *nameLbl;
@property(nonatomic ,strong) UILabel *phoneLbl;
@property(nonatomic ,strong) UILabel *typeLbl;
@property(nonatomic ,strong) UIView *bindView;
@property(nonatomic ,strong) UILabel *bindNumberLbl;
@property(nonatomic ,strong) UIButton *bindBtn;
@end

@implementation YGSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    self.backView.hidden = YES;
    [self.rightBtn addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![YGLDataManager manager].userData.login){
        YGLoginVC *loginVC = [[YGLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    NSString *headIcon = [YGLDataManager manager].userData.headIcon;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:headIcon] placeholderImage:[UIImage imageNamed:@"头像"]];

    
}

- (void)editAction:(UIButton *)sender{
    YGEditInformationVC *editInformationVC = [[YGEditInformationVC alloc] init];
    editInformationVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:editInformationVC animated:YES];
}
- (UIImageView *)iconImageView{
    if(!_iconImageView){
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
        _iconImageView.image = [UIImage imageNamed:@"头像"];
        _iconImageView.layer.cornerRadius = 40;
        [_iconImageView.layer setMasksToBounds:YES];
        _iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction2:)];
        [_iconImageView addGestureRecognizer:tap];
    }
    return _iconImageView;
}
- (UILabel *)nameLbl{
    if(!_nameLbl){
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(120, 35, 100, 30)];
        _nameLbl.font = [UIFont boldSystemFontOfSize:20];
        _nameLbl.text = [YGLDataManager manager].userData.name;
    }
    return _nameLbl;
}
- (void)addSubViews{
    [self.view addSubview:self.iconImageView];
    [self.view addSubview:self.nameLbl];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 105, kScreenWidth, 1)];
    line1.backgroundColor = COLOR(221, 221, 221, 1);
    [self.view addSubview:line1];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 120, 80, 20)];
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"手机号:";
    [self.view addSubview:label1];
    self.phoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 120, 120, 20)];
    self.phoneLbl.text = [YGLDataManager manager].userData.phone;
    self.phoneLbl.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.phoneLbl];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 155, kScreenWidth, 1)];
    line2.backgroundColor = COLOR(221, 221, 221, 1);
    [self.view addSubview:line2];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 170, 80, 20)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.text = @"用户类型:";
    [self.view addSubview:label2];
    self.typeLbl = [[UILabel alloc] initWithFrame:CGRectMake(100, 170, 120, 20)];
    self.typeLbl.text = @"家长";
    self.typeLbl.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.typeLbl];
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, 205, kScreenWidth, 1)];
    line3.backgroundColor = COLOR(221, 221, 221, 1);
    [self.view addSubview:line3];
    
    self.bindView = [[UIView alloc] initWithFrame:CGRectMake(0, 205, kScreenWidth, 50)];
    [self.view addSubview:self.bindView];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 20)];
    label3.font = [UIFont systemFontOfSize:14];
    label3.text = @"已绑定的学生数:";
    [self.bindView addSubview:label3];
    self.bindNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 100, 20)];
    self.bindNumberLbl.text = @"3";
    self.bindNumberLbl.font = [UIFont systemFontOfSize:14];
    [self.bindView addSubview:self.bindNumberLbl];
    
    UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 15, 20, 20)];
    moreImageView.image = [UIImage imageNamed:@"more"];
    [self.bindView addSubview:moreImageView];
    
    UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 255, kScreenWidth, 1)];
    line4.backgroundColor = COLOR(221, 221, 221, 1);
    [self.view addSubview:line4];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.bindView addGestureRecognizer:tap];


//    if([YGLDataManager manager].userData.userType ==UserTypeParent){
//        self.bindView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, kScreenWidth, 50)];
//        [self.view addSubview:self.bindView];
//        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 120, 20)];
//        label3.font = [UIFont systemFontOfSize:14];
//        label3.text = @"已绑定的学生数:";
//        [self.bindView addSubview:label3];
//        self.bindNumberLbl = [[UILabel alloc] initWithFrame:CGRectMake(150, 15, 100, 20)];
//        self.bindNumberLbl.text = @"3";
//        self.bindNumberLbl.font = [UIFont systemFontOfSize:14];
//        [self.bindView addSubview:self.bindNumberLbl];
//        
//        UIImageView *moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth-40, 15, 20, 20)];
//        moreImageView.image = [UIImage imageNamed:@"more"];
//        [self.bindView addSubview:moreImageView];
//        
//        UIView *line4 = [[UIView alloc] initWithFrame:CGRectMake(0, 315, kScreenWidth, 1)];
//        line4.backgroundColor = COLOR(221, 221, 221, 1);
//        [self.view addSubview:line4];
//        
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//        [self.bindView addGestureRecognizer:tap];
//
//    }
    
    
//    self.bindView = [ui];
    
    
    self.bindBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 350, kScreenWidth - 40, 35)];
    self.bindBtn.layer.cornerRadius = 7;
    [self.bindBtn.layer setMasksToBounds:YES];
    [self.bindBtn setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    [self.bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bindBtn setTitle:@"绑定微信" forState:UIControlStateNormal];
    [self.bindBtn addTarget:self action:@selector(bindAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.bindBtn];
    
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 395, kScreenWidth - 40, 35)];
    logoutBtn.layer.cornerRadius = 7;
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
    YGBindedStudentVC *bindedStudentVC = [[YGBindedStudentVC alloc] init];
    [self.navigationController pushViewController:bindedStudentVC animated:YES];
}
- (void)logout:(UIButton *)sender{
    NSFileManager *defauleManager = [NSFileManager defaultManager];
    NSString *path = [[YGLDataManager manager] userCacheFilePath];
    [defauleManager removeItemAtPath:path error:nil];
    YGLoginVC *loginVC = [[YGLoginVC alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}
//调用相册～
-(void)openMenu{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"获取图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //相机
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePickerController animated:YES completion:^{
                
            }];
        }];
        [alertController addAction:defaultAction];
    }
    UIAlertAction *defaultAction1 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerController animated:YES completion:^{
        }];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel  handler:^(UIAlertAction *action){
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:defaultAction1];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    UIImage *image = [self result:[info objectForKey:UIImagePickerControllerOriginalImage] percent:0.0001];
    //    [self.imageArray addObject:image];
    //    [self refreshView];
    UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *data = UIImageJPEGRepresentation(originImage, 0.2f);
    NSString *encodedImageStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSLog(@"encodedImageStr:%@",encodedImageStr);
    NSString *baseString = (__bridge NSString *) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                         (CFStringRef)encodedImageStr,
                                                                                         NULL,
                                                                                         CFSTR(":/?#[]@!$&’()*+,;="),
                                                                                         kCFStringEncodingUTF8);
    NSLog(@"baseString:%@",baseString);
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"accountHead" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
    [dic setObject:baseString forKey:@"head_icon"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    [YGNetWorkManager upLoadUserProfileWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        NSString *path = [[YGLDataManager manager] userCacheFilePath];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [dic setObject:responseObject[@"head_icon"] forKey:@"head_icon"];
        [dic writeToFile:path atomically:YES];
        [YGLDataManager manager].userData = [[YGUserData alloc] initWithDictionary:dic];
        
    } fail:^{
        
    }];

}

- (void)tapAction2:(UITapGestureRecognizer *)tap{
    [self openMenu];
}
- (void)bindAction{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"weixinBound" forKey:@"event_code"];
    [parameter setObject:@"" forKey:@"account_id"];
    [parameter setObject:@"" forKey:@"weixin_id"];
    [YGNetWorkManager bindwechatWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
    } fail:^{
        
    }];
}

@end
