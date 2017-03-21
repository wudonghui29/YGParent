//
//  YGLeaveVC.m
//  YGSchool
//
//  Created by faith on 17/2/20.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGLeaveVC.h"
#import "YGCommon.h"
@interface YGLeaveVC ()<UITableViewDataSource,UITableViewDelegate>
{
    DatePickerHeadView *headView;
    DatePickerView *pickerView;
    YGLeaveShadeView *leaveShadeV;
    NSArray *studentArray;
    BOOL isEdit;
    NSString *selectedEditStudentID;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *leaveBills;
@property(nonatomic,strong) YGShadeView *shadeView;
@property(nonatomic,strong) YGShadeView *editShadeView;

@end

@implementation YGLeaveVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请假";
    self.rightBtn.hidden = NO;
    studentArray = [NSArray array];
    [self.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self queryLeaveBill];
}
- (NSArray *)leaveBills{
    if(!_leaveBills){
        _leaveBills = [[NSArray alloc] init];
    }
    return _leaveBills;
}
- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [self.view addSubview:self.tableView];
        [YGShow fullSperatorLine:self.tableView];
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self queryLeaveBill];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            
        }];


    }
    return _tableView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.leaveBills.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 105;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YGLeaveListCell";
    YGLeaveListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[YGLeaveListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    NSDictionary *dic = self.leaveBills[indexPath.row];
    [cell setDic:dic];
    return cell;
}
#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *billDic = self.leaveBills[indexPath.row];
    NSArray *array = [NSArray array];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"leaveDel" forKey:@"event_code"];
        [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
        [dic setObject:billDic[@"leave_id"] forKey:@"leave_id"];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        NSString *str = [YGTools convertToJsonString:dic];
        [parameter setObject:str forKey:@"content"];

        [YGNetWorkManager delectLeaveWithParameter:parameter completion:^(id responseObject) {
            NSLog(@"responseObject:%@",responseObject);
        } fail:^{
            
        }];
        [self.tableView reloadData];
        
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
        isEdit = YES;
        selectedEditStudentID = billDic[@"student_id"];
        YGLeaveShadeView *leaveShadeView = [[YGLeaveShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        leaveShadeV = leaveShadeView;
        __block YGLeaveShadeView *weakLeaveShadeView  = leaveShadeView;
        leaveShadeView.chooseStudentTXF.text = billDic[@"student_name"];
        leaveShadeView.chooseDateTXF.text = billDic[@"date"];
        leaveShadeView.leaveDaysTXF.text = [billDic[@"days"] stringValue];
        leaveShadeView.reasonTXF.text = billDic[@"desc"];
        leaveShadeView.chooseStudentBlock = ^{
            [self getMyStudentList];
            YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
            __block YGShadeView *weakShadeView  = shadeView;
            _editShadeView = shadeView;
            shadeView.chooseBlock = ^(NSString *title){
                for(NSDictionary *dic in self.leaveBills){
                    if([title isEqualToString:dic[@"student_name"]]){
                        selectedEditStudentID = dic[@"student_id"];
                        break;
                    }
                }
                weakLeaveShadeView.chooseStudentTXF.text = title;
                [weakShadeView dissmiss];
            };
            [self.view.window addSubview:shadeView];
        };
        leaveShadeView.chooseDateBlock = ^{
            //日期选择
            pickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 250, kScreenWidth, 250)];
            pickerView.dateFormat = @"yyyy-MM-dd";
            headView = pickerView.headView;
            
            [headView addTarget:self confirmAction:@selector(confirm:)];
            [headView addTarget:self cancelAction:@selector(cancle:)];
            [weakLeaveShadeView addSubview:pickerView];
        };
        leaveShadeView.clickBlock = ^(NSInteger tag){
            if(tag ==0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    leaveShadeV.hidden = NO;
                }]];
                NSString *alertMessage;
                if([leaveShadeView.chooseStudentTXF.text length] ==0) {
                    alertMessage = @"请选择学生";
                }else if([leaveShadeView.chooseDateTXF.text length] ==0){
                    alertMessage = @"请选择请假起始日期";
                }else if([leaveShadeView.leaveDaysTXF.text length] ==0){
                    alertMessage = @"请选择请假天数";
                }else if([leaveShadeView.reasonTXF.text length] ==0){
                    alertMessage = @"请选择请假事由";
                }else{
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:@"leaveEdit" forKey:@"event_code"];
                    [dic setObject:billDic[@"leave_id"] forKey:@"leave_id"];
                    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
                    [dic setObject:selectedEditStudentID forKey:@"student_id"];
                    [dic setObject:leaveShadeV.chooseDateTXF.text forKey:@"date"];
                    [dic setObject:leaveShadeV.leaveDaysTXF.text forKey:@"days"];
                    [dic setObject:leaveShadeV.reasonTXF.text forKey:@"desc"];
                    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
                    NSString *str = [YGTools convertToJsonString:dic];
                    [parameter setObject:str forKey:@"content"];
                    [YGNetWorkManager editLeaveWithParameter:parameter completion:^(id responseObject) {
                        NSLog(@"responseObject:%@",responseObject);
                    } fail:^{
                        
                    }];
                    [weakLeaveShadeView dissmiss];
                    return ;
                }
                leaveShadeV.hidden = YES;
                alert.message = alertMessage;
                [self presentViewController:alert animated:YES completion:nil];
                
            }else{
                [weakLeaveShadeView dissmiss];
            }
        };
        [self.view.window addSubview:leaveShadeView];
        
    }];
    editAction.backgroundColor = [UIColor grayColor];
    array = @[deleteAction, editAction];
    return array;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 补全分割线
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)addAction:(UIButton *)sender{
    YGLeaveShadeView *leaveShadeView = [[YGLeaveShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    leaveShadeV = leaveShadeView;
    __block YGLeaveShadeView *weakLeaveShadeView  = leaveShadeView;
    leaveShadeView.chooseStudentBlock = ^{
        [self getMyStudentList];
        YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
        _shadeView = shadeView;
        __block YGShadeView *weakShadeView  = shadeView;
//        shadeView.titleArray = @[@"选择学生",@"测试学生",@"学生2",@"测试学生45"];
        shadeView.chooseBlock = ^(NSString *title){
            weakLeaveShadeView.chooseStudentTXF.text = title;
            [weakShadeView dissmiss];
        };
        [self.view.window addSubview:shadeView];
    };
    leaveShadeView.chooseDateBlock = ^{
        //日期选择
        pickerView = [[DatePickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 250, kScreenWidth, 250)];
        pickerView.dateFormat = @"yyyy-MM-dd";
        headView = pickerView.headView;
        
        [headView addTarget:self confirmAction:@selector(confirm:)];
        [headView addTarget:self cancelAction:@selector(cancle:)];
        [weakLeaveShadeView addSubview:pickerView];
//        pickerView.hidden = YES;

    };
    leaveShadeView.clickBlock = ^(NSInteger tag){
        if(tag ==0){
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                leaveShadeV.hidden = NO;
                
            }]];
            NSString *alertMessage;
            if([leaveShadeView.chooseStudentTXF.text length] ==0) {
                alertMessage = @"请选择学生";
            }else if([leaveShadeView.chooseDateTXF.text length] ==0){
                alertMessage = @"请选择请假起始日期";
            }else if([leaveShadeView.leaveDaysTXF.text length] ==0){
                alertMessage = @"请选择请假天数";
            }else if([leaveShadeView.reasonTXF.text length] ==0){
                alertMessage = @"请选择请假事由";
            }else{
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                [dic setObject:@"leaveAdd" forKey:@"event_code"];
                [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
                NSString *studentID;
                for(NSDictionary *dic in studentArray){
                    if([weakLeaveShadeView.chooseStudentTXF.text isEqualToString:dic[@"name"]]){
                        studentID = dic[@"student_id"];
                        break;
                    }
                }
                [dic setObject:studentID forKey:@"student_id"];
                [dic setObject:weakLeaveShadeView.chooseDateTXF.text forKey:@"date"];
                [dic setObject:weakLeaveShadeView.leaveDaysTXF.text forKey:@"days"];
                [dic setObject:weakLeaveShadeView.reasonTXF.text forKey:@"desc"];
                NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
                NSString *str = [YGTools convertToJsonString:dic];
                [parameter setObject:str forKey:@"content"];
                [YGNetWorkManager addLeaveWithParameter:parameter completion:^(id responseObject) {
                    NSLog(@"responseObject:%@",responseObject);
                    
                } fail:^{
                    
                }];
                [weakLeaveShadeView dissmiss];
                return ;
            }
            leaveShadeV.hidden = YES;
            alert.message = alertMessage;
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [weakLeaveShadeView dissmiss];
        }
    };
    [self.view.window addSubview:leaveShadeView];
}
- (void)confirm:(UIButton *)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *resultStr = pickerView.resultStr;
    if (resultStr == nil) {
        resultStr = dateStr;
    }
    leaveShadeV.chooseDateTXF.text = resultStr;
    pickerView.hidden = YES;
    
}
- (void)cancle:(UIButton *)sender {
    pickerView.hidden = YES;
}
- (void)queryLeaveBill{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"leaveSearch" forKey:@"event_code"];
    [dic setObject:@"" forKey:@"account_id"];
    [dic setObject:@"" forKey:@"class_id"];
    [dic setObject:@"" forKey:@"student_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    [YGNetWorkManager queryLeaveWithParameter:parameter completion:^(id responseObject) {
        if([responseObject[@"code"] integerValue] ==1){
            self.leaveBills = responseObject[@"dt"];
            [self.tableView reloadData];
        }
    } fail:^{
        
    }];
}
- (void)getMyStudentList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"myStudentList" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    [YGNetWorkManager getMyStudentListWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        
        if([responseObject[@"code"] integerValue] ==1){
            studentArray = responseObject[@"list"];
            NSMutableArray *titleArr = [[NSMutableArray alloc] initWithObjects:@"请选择学生", nil];
            for(NSDictionary *dic in studentArray){
                [titleArr addObject:dic[@"name"]];
            }
            NSArray *titleArray = [[NSArray alloc] initWithArray:titleArr];
            if(!isEdit){
                _shadeView.titleArray = titleArray;

            }else{
                _editShadeView.titleArray = titleArray;
            }
            
        }
    } fail:^{
        
    }];
}

@end
