//
//  YGRewardPunishmentVC.m
//  YGSchool
//
//  Created by faith on 17/2/15.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGRewardPunishmentVC.h"
#import "YGCommon.h"
@interface YGRewardPunishmentVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UITableView *rewardTable;
@property(nonatomic,strong) UITableView *punishmentTable;
@property(nonatomic,strong) NSArray *rewardList;
@property(nonatomic,strong) NSArray *punishmentList;

@end

@implementation YGRewardPunishmentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"奖励和惩罚";
    self.backView.hidden = YES;
    self.chooseControl.titleArray = @[@"奖励",@"惩罚"];
    __block YGRewardPunishmentVC *weakSelf = self;
    self.chooseControl.switchBlock = ^(NSInteger tag){
        if(tag ==0){
            weakSelf.rewardTable.hidden = NO;
            weakSelf.punishmentTable.hidden = YES;
            [weakSelf queryRewardList];
        }else{
            weakSelf.rewardTable.hidden = YES;
            weakSelf.punishmentTable.hidden = NO;
            [weakSelf queryPunishmentList];
        }
    };

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 129, kScreenWidth, 1)];
    lineView.backgroundColor = COLOR(200, 200, 200, 1);
    [self.view addSubview:lineView];
    [self.view addSubview:self.rewardTable];
    [self.view addSubview:self.punishmentTable];
    [YGShow fullSperatorLine:self.rewardTable];
    [YGShow fullSperatorLine:self.punishmentTable];
    self.punishmentTable.hidden = YES;
    [self queryRewardList];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![YGLDataManager manager].userData.login){
        YGLoginVC *loginVC = [[YGLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }

}
- (NSArray *)rewardList{
    if(!_rewardList){
        _rewardList = [[NSArray alloc] init];
    }
    return _rewardList;
}
- (NSArray *)punishmentList{
    if(!_punishmentList){
        _punishmentList = [[NSArray alloc] init];
    }
    return _punishmentList;
}

- (UITableView *)rewardTable{
    if(!_rewardTable){
        _rewardTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 76, kScreenWidth, kScreenHeight-76) style:UITableViewStylePlain];
        _rewardTable.tag = 0;
        _rewardTable.delegate = self;
        _rewardTable.dataSource = self;
        _rewardTable.tableFooterView = [[UIView alloc] init];
    }
    return _rewardTable;
}
- (UITableView *)punishmentTable{
    if(!_punishmentTable){
        _punishmentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 76, kScreenWidth, kScreenHeight-76) style:UITableViewStylePlain];
        _punishmentTable.tag = 1;
        _punishmentTable.delegate = self;
        _punishmentTable.dataSource = self;
        _punishmentTable.tableFooterView = [[UIView alloc] init];
    }
    return _punishmentTable;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag ==0){
        return self.rewardList.count;
    }
    return self.punishmentList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag ==0){
        return 44;
    }
    return 65;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag ==0){
        static NSString *identify = @"YGNoticeListCell";
        YGNoticeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if(!cell){
            cell = [[YGNoticeListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        NSDictionary *dic = self.rewardList[indexPath.row];
        [cell setDic:dic];
        return cell;
    }else{
        static NSString *identify = @"YGVerifyCell";
        YGVerifyCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if(!cell){
            cell = [[YGVerifyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        NSDictionary *dic = self.punishmentList[indexPath.row];
        [cell setDic:dic];
        return cell;
        
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YGRewardPunishmentDetailVC *vc = [[YGRewardPunishmentDetailVC alloc] init];
    NSDictionary *dic = self.rewardList[indexPath.row];
    if(tableView.tag ==1){
        dic = self.punishmentList[indexPath.row];
    }
    
    vc.dic = dic;
    [self.navigationController pushViewController:vc animated:YES];
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
- (void)queryRewardList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"rewardSearch" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];

    [YGNetWorkManager queryRewardListWithParameter:parameter completion:^(id responseObject) {
            NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"code"] integerValue] ==1){
            self.rewardList = responseObject[@"list"];
            [self.rewardTable reloadData];
        }
    } fail:^{
        
    }];
}
- (void)queryPunishmentList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"punishSearch" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];
    
    
    [YGNetWorkManager querypunishmentListWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
        if([responseObject[@"code"] integerValue] ==1){
            self.punishmentList = responseObject[@"list"];
            [self.punishmentTable reloadData];
        }

    } fail:^{
        
    }];
}
@end
