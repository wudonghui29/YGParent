//
//  YGScheduleVC.m
//  YGSchool
//
//  Created by faith on 17/2/15.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGScheduleVC.h"
#import "YGCommon.h"
#define KHeadView 65
@interface YGScheduleVC ()
@property(nonatomic, strong)UILabel *headLbl;
@property(nonatomic, strong)UIView *headView;
@property(nonatomic, strong)UIView *bView;
@property(nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) NSMutableArray *courseArray;
@property (nonatomic, strong) NSMutableDictionary *allCourses;
@property (nonatomic, strong) NSMutableArray *labels;
@property(nonatomic, strong) NSMutableArray *classArray;
@property(nonatomic, strong) YGShadeView *shadeView;


@end

@implementation YGScheduleVC
- (NSMutableArray *)classArray{
    if(!_classArray){
        _classArray = [[NSMutableArray alloc] init];
    }
    return _classArray;
}
- (NSMutableArray *)courseArray{
    if(!_courseArray){
        _courseArray = [[NSMutableArray alloc] init];
    }
    return _courseArray;
}
- (NSMutableDictionary *)allCourses{
    if(!_allCourses){
        _allCourses = [[NSMutableDictionary alloc] init];
    }
    return _allCourses;
}
- (NSMutableArray *)labels{
    if(!_labels){
        _labels = [[NSMutableArray alloc] init];
    }
    return _labels;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"课程表";
    self.rightBtn.hidden = YES;
    self.backView.hidden = YES;
    [self.view addSubview:self.headLbl];
    [self addHeadView];
    // 添加左右手势
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, KHeadView, kScreenWidth, kScreenHeight-KHeadView-64)];
    v.backgroundColor = COLOR_WITH_HEX(0xfafafa);
    [self.view addSubview:v];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/5, (kScreenHeight-KHeadView - 64)/2)];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:14];
    label1.text = @"上午";
    [v addSubview:label1];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-KHeadView-64)/2, kScreenWidth, 1)];
    lineView.backgroundColor = COLOR(215, 215, 215, 1);
    [v addSubview:lineView];
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, (kScreenHeight-KHeadView-64)/2+1, kScreenWidth/5, (kScreenHeight-KHeadView-64)/2)];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:14];

    label2.text = @"下午";
    [v addSubview:label2];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/5, 0, 1, kScreenHeight-KHeadView-64)];
    lineView2.backgroundColor = COLOR(215, 215, 215, 1);
    [v addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/5*3, 0, 1, kScreenHeight-KHeadView-64)];
    lineView3.backgroundColor = COLOR(215, 215, 215, 1);
    [v addSubview:lineView3];

    
    CGFloat lw = kScreenWidth/5*2;
    CGFloat lh = (kScreenHeight-KHeadView-64)/8;
    NSArray *arr = @[@"第一节",@"第二节",@"第三节",@"第四节",@"第一节",@"第二节",@"第三节",@"第四节"];
    for(int i = 0; i < 8; i++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/5, i*lh, lw, lh)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.text = arr[i];
        [v addSubview:lbl];
    }
    for(int i = 1; i < 8; i ++){
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth/5, i*lh, kScreenWidth/5*4, 1)];
        line.backgroundColor = COLOR(215, 215, 215, 1);
        [v addSubview:line];
    }
    [self.labels removeAllObjects];
    for(int i = 0; i < 8; i++){
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/5*3, i*lh, lw, lh)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14];
        lbl.text = arr[i];
        [v addSubview:lbl];
        [self.labels addObject:lbl];
    }
    [self getClassList];
    

}
- (void)refreshView{
    NSString *key = [NSString stringWithFormat:@"d%ld",_currentIndex+1];
    NSArray *courses = self.allCourses[key];
    NSMutableArray *all = [[NSMutableArray alloc] init];
    for(int i = 0 ; i < courses.count ; i++){
        NSDictionary *dic = courses[i];
        [all addObject:dic[@"course"]];
    }
    for(int i = 0 ; i < courses.count ; i++){
        NSDictionary *dic = courses[i];
        [all addObject:dic[@"course"]];
    }
    for(int i = 0; i < 8; i++){
        UILabel *lbl = self.labels[i];
        lbl.text = all[i];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![YGLDataManager manager].userData.login){
        YGLoginVC *loginVC = [[YGLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }
    
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"往左滑");
        if(_currentIndex == 4){
            return;
        }
        _currentIndex++;
        [UIView animateWithDuration:KAnimationInterval animations:^{
            _bView.frame = CGRectMake(_currentIndex*kScreenWidth/5, 0, kScreenWidth/5, 40);
            [self switchDay];
        }];

    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"往右滑");
        if(_currentIndex ==0){
            return;
        }
        _currentIndex--;
        [UIView animateWithDuration:KAnimationInterval animations:^{
            _bView.frame = CGRectMake(_currentIndex*kScreenWidth/5, 0, kScreenWidth/5, 40);
            [self switchDay];
        }];

    }
    [self refreshView];
}

- (UILabel *)headLbl{
    if(!_headLbl){
        _headLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _headLbl.font = [UIFont systemFontOfSize:12];
        _headLbl.backgroundColor = COLOR_WITH_HEX(0x96cfe9);
        _headLbl.textAlignment = NSTextAlignmentCenter;
//        _headLbl.text = @"小学一年级(01)班";
        
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseClass:)];
        
        _headLbl.userInteractionEnabled=YES;
        [_headLbl addGestureRecognizer:tapRecognizer];
    }
    return _headLbl;
}
- (void)addHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, 40)];
    [self.view addSubview:headView];
    CGFloat bWidth = kScreenWidth/5;
    _bView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bWidth, 40)];
    _bView.backgroundColor = COLOR_WITH_HEX(0xcae8fd);
    [headView addSubview:_bView];
    NSArray *titleArr = @[@"周一",@"周二",@"周三",@"周四",@"周五"];
    for(int i = 0; i < 5;i++){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i*bWidth, 0, bWidth, 40)];
        btn.tag = i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:btn];
        
    }
}

- (void)btnAction:(UIButton *)sender{
    NSInteger index = sender.tag;
    _currentIndex = index;
    [UIView animateWithDuration:KAnimationInterval animations:^{
        _bView.frame = CGRectMake(index*kScreenWidth/5, 0, kScreenWidth/5, 40);
        [self switchDay];
        [self refreshView];
    }];
}
- (void)switchDay{
//    NSString *key = [NSString stringWithFormat:@"d%ld",(long)_currentIndex + 1];
//    NSArray *courseArray = _allCourses[key];
//    for(int i = 0; i < 8; i ++){
//        NSDictionary *dic = courseArray[i];
//        UILabel *lbl = self.labels[i];
//        lbl.text = dic[@"course "];
//    }
}
- (void)chooseClass:(UIButton *)sender{
    [self getClassList];
    YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _shadeView = shadeView;
    __block YGShadeView *weakShadeView  = shadeView;
//    shadeView.titleArray = @[@"班级",@"小学一年级(01)班",@"小学一年级(02)班",@"小学二年级(01)班",@"小学二年级(02)班",@"小学三年级(01)班",@"小学三年级(02)班",@"小学四年级(01)班",@"小学四年级(02)班",@"小学五年级(01)班",@"小学五年级(02)班",@"小学六年级(01)班",@"小学六年级(02)班"];
    shadeView.chooseBlock = ^(NSString *title){
        self.headLbl.text = title;
        [weakShadeView dissmiss];
    };
    [self.view.window addSubview:shadeView];
}
- (void)queryCourse{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"scheduleSearch" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
    NSDictionary *d = self.classArray[0];
    [dic setObject:d[@"class_id"] forKey:@"class_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];

    [YGNetWorkManager queryCourseWithParameter:parameter completion:^(id responseObject) {
        [YGShow StatusWithObj:responseObject withStr:nil isSuccessBlock:^{
            _allCourses = responseObject[@"course"];
            [self refreshView];
        } isErrorBlock:^{
            
        }];
    } fail:^{
        
    }];
}
- (void)getClassList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"classList" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.schoolID forKey:@"school_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    [YGNetWorkManager getClassListWithParameter:parameter completion:^(id responseObject) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:@"班级", nil];
        NSLog(@"responseObject:%@",responseObject);
        self.classArray = responseObject[@"list"];
        NSDictionary *first = [self.classArray firstObject];
        _headLbl.text = first[@"name"];
        
        for(int i = 0; i < self.classArray.count ;i++){
            NSDictionary *dic = self.classArray[i];
            [array addObject:dic[@"name"]];
        }
        [_shadeView setTitleArray:array];
        [self queryCourse];
        
    } fail:^{
        
    }];
}

@end
