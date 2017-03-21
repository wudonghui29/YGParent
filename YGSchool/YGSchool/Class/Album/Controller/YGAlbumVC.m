//
//  YGAlbumVC.m
//  YGSchool
//
//  Created by faith on 17/2/15.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGAlbumVC.h"
#import "YGCommon.h"
@interface YGAlbumVC ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong)UILabel *headLbl;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSMutableArray *classArray;
@property(nonatomic, strong) YGShadeView *shadeView;

@end

@implementation YGAlbumVC
- (NSMutableArray *)classArray{
    if(!_classArray){
        _classArray = [[NSMutableArray alloc] init];
    }
    return _classArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"班级相册";
    self.backView.hidden = YES;
    [self.rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
    self.dataArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    [self.view addSubview:self.headLbl];
    [self.view addSubview:self.tableView];
    [YGShow fullSperatorLine:self.tableView];
    [self getClassList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![YGLDataManager manager].userData.login){
        YGLoginVC *loginVC = [[YGLoginVC alloc] init];
        [self presentViewController:loginVC animated:YES completion:nil];
        return;
    }

    [self.tableView setEditing:NO animated:NO];
}
- (UILabel *)headLbl{
    if(!_headLbl){
        _headLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 25)];
        _headLbl.font = [UIFont systemFontOfSize:12];
        _headLbl.backgroundColor = COLOR_WITH_HEX(0x96cfe9);
        _headLbl.textAlignment = NSTextAlignmentCenter;
        _headLbl.text = @"小学一年级(01)班";
        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseClass:)];
        
        _headLbl.userInteractionEnabled=YES;
        [_headLbl addGestureRecognizer:tapRecognizer];

    }
    return _headLbl;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 25, kScreenWidth, kScreenHeight-25) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"YGAlbumListCell";
    YGAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if(!cell){
        cell = [[YGAlbumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:@"photoDel" forKey:@"event_code"];
        [parameter setObject:@"photoDel" forKey:@"account_id"];
        [parameter setObject:@"photoDel" forKey:@"photo_id"];
        [YGNetWorkManager delectAlbumWithParameter:parameter completion:^(id responseObject) {
            NSLog(@"responseObject:%@",responseObject);
        } fail:^{
            
        }];
        [self.tableView reloadData];
        
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"123.jpeg"],[UIImage imageNamed:@"124.jpg"], nil];
        YGEditAlbumVC *editAlbumVC = [[YGEditAlbumVC alloc] init];
        editAlbumVC.contentTitle = @"测试2";
        editAlbumVC.className = _headLbl.text;
        editAlbumVC.imageArray = array;
        [self presentViewController:editAlbumVC animated:YES completion:nil];
        
    }];
    editAction.backgroundColor = [UIColor grayColor];
    return @[deleteAction, editAction];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    MWPhoto *photo;
    BOOL displayActionButton = NO;
    BOOL displaySelectionButtons = NO;
    BOOL displayNavArrows = YES;
    BOOL enableGrid = YES;
    BOOL startOnGrid = YES;
    
    // Photos
    photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123" ofType:@"jpeg"]]];
    // caption图片的描述
    //    photo.caption = @"Fireworks";
    [photos addObject:photo];
    photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"124" ofType:@"jpg"]]];
    //    photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
    [photos addObject:photo];
    photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123" ofType:@"jpeg"]]];
    //    photo.caption = @"York Floods";
    [photos addObject:photo];
    photo = [MWPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"124" ofType:@"jpg"]]];
    //    photo.caption = @"Campervan";
    [photos addObject:photo];
    
    
    // Options
    self.photos = photos;
    self.thumbs = thumbs;
    
    
    //
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = displayActionButton;//分享按钮,默认是
    browser.displayNavArrows = displayNavArrows;//左右分页切换,默认否
    browser.displaySelectionButtons = displaySelectionButtons;//是否显示选择按钮在图片上,默认否
    browser.alwaysShowControls = displaySelectionButtons;//控制条件控件 是否显示,默认否
    browser.zoomPhotosToFill = YES;//是否全屏,默认是
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
    browser.wantsFullScreenLayout = YES;//是否全屏
#endif
    browser.enableGrid = enableGrid;//是否允许用网格查看所有图片,默认是
    browser.startOnGrid = startOnGrid;//是否第一张,默认否
    browser.enableSwipeToDismiss = YES;
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:0];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     [self presentViewController:nav animated:YES completion:nil];
}

//返回图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.photos.count;
}
//返回图片模型
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    //    NSURL *photoUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test2" ofType:@"jpg"]];
    //创建图片模型
    MWPhoto *photo = [self.photos objectAtIndex:index];
    
    return photo;
    
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}



- (void)add:(UIButton *)sender{
    YGAddAlbumVC *addAlbumVC = [[YGAddAlbumVC alloc] init];
    [self.navigationController pushViewController:addAlbumVC animated:YES];
}
- (void)chooseClass:(UIButton *)sender{
    [self getClassList];
    YGShadeView *shadeView = [[YGShadeView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _shadeView= shadeView;
    __block YGShadeView *weakShadeView  = shadeView;
    shadeView.chooseBlock = ^(NSString *title){
        self.headLbl.text = title;
        [weakShadeView dissmiss];
    };
    [self.view.window addSubview:shadeView];
}
- (void)queryAlbumList{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"photoSearch" forKey:@"event_code"];
    [dic setObject:[YGLDataManager manager].userData.accountID forKey:@"account_id"];
    NSDictionary *d = self.classArray[0];
    [dic setObject:d[@"class_id"] forKey:@"class_id"];
    
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    NSString *str = [YGTools convertToJsonString:dic];
    [parameter setObject:str forKey:@"content"];

    [YGNetWorkManager queryAlbumListWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
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
        [self queryAlbumList];
        
    } fail:^{
        
    }];
}


@end
