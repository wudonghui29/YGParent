//
//  YGDeviceDetailVC.m
//  YGSchool
//
//  Created by faith on 17/3/8.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGDeviceDetailVC.h"
#import "YGCommon.h"
#define DefaultSegmentHeight 44
@interface YGDeviceDetailVC ()<UIScrollViewDelegate, XHSegmentControlDelegate>
@property(nonatomic, strong) YGSegmentControl   *segmentControl;
@property(nonatomic)         CGFloat            beginOffsetX;
@property(nonatomic, strong) UIScrollView       *scrollView;

@end

@implementation YGDeviceDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBtn.hidden = YES;
    YGDeviceInfoVC *vc1 = [[YGDeviceInfoVC alloc] init];
    vc1.title = @"详情";
    YGDeviceTraceVC *vc2 = [[YGDeviceTraceVC alloc] init];
    vc2.title = @"追踪";
    YGDeviceTrackVC *vc3 = [[YGDeviceTrackVC alloc] init];
    vc3.title = @"轨迹";
    self.viewControllers = @[vc1, vc2, vc3];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
}
// For Parent
#pragma mark - Private Method

- (void)selectNext
{
    if (self.segmentControl.selectIndex + 1 < self.viewControllers.count) {
        
        self.segmentControl.selectIndex = self.segmentControl.selectIndex + 1;
    }
}

- (void)selectPrevious
{
    if (self.segmentControl.selectIndex > 0) {
        
        self.segmentControl.selectIndex = self.segmentControl.selectIndex - 1;
    }
}

#pragma mark - lazy initializer
- (YGSegmentControl *)segmentControl
{
    if (!_segmentControl)
    {
        CGFloat y = 54;
        _segmentControl = [[YGSegmentControl alloc] initWithFrame:CGRectMake(0, y, [UIScreen mainScreen].bounds.size.width, DefaultSegmentHeight)];
        _segmentControl.delegate = self;
    }
    return _segmentControl;
}

- (UIScrollView *)scrollView
{
    //  scrollView
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segmentControl.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(_segmentControl.frame))];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.decelerationRate = 0.5;
        _scrollView.delegate = self;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
    }
    return _scrollView;
}
- (void)queryHomework{
    NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:@"homeworkSearch" forKey:@"event_code"];
    [parameter setObject:@"" forKey:@"account_id"];
    [parameter setObject:@"" forKey:@"date"];
    [parameter setObject:@"" forKey:@"student_id"];
    [YGNetWorkManager queryHomeworkWithParameter:parameter completion:^(id responseObject) {
        NSLog(@"responseObject:%@",responseObject);
    } fail:^{
        
    }];
}
#pragma mark - Setters

- (void)setSegmentType:(XHSegmentType)segmentType
{
    _segmentType = segmentType;
    self.segmentControl.segmentType = segmentType;
}

- (void)setSegmentBackgroundColor:(UIColor *)segmentBackgroundColor
{
    _segmentBackgroundColor = segmentBackgroundColor;
    self.segmentControl.backgroundColor = segmentBackgroundColor;
}

- (void)setSegmentBackgroundImage:(UIImage *)segmentBackgroundImage
{
    _segmentBackgroundImage = segmentBackgroundImage;
    self.segmentControl.backgroundImage = segmentBackgroundImage;
}

- (void)setSegmentHighlightColor:(UIColor *)segmentHighlightColor
{
    _segmentHighlightColor = segmentHighlightColor;
    self.segmentControl.highlightColor = segmentHighlightColor;
}

- (void)setSegmentLineWidth:(CGFloat)segmentLineWidth
{
    _segmentLineWidth = segmentLineWidth;
    self.segmentControl.lineWidth = segmentLineWidth;
}

- (void)setSegmentBorderWidth:(CGFloat)segmentBorderWidth
{
    _segmentBorderWidth = segmentBorderWidth;
    self.segmentControl.borderWidth = segmentBorderWidth;
}

- (void)setSegmentBorderColor:(UIColor *)segmentBorderColor
{
    _segmentBorderColor = segmentBorderColor;
    self.segmentControl.borderColor = segmentBorderColor;
}

- (void)setSegmentTitleColor:(UIColor *)segmentTitleColor
{
    _segmentTitleColor = segmentTitleColor;
    self.segmentControl.titleColor = segmentTitleColor;
}

- (void)setSegmentTitleFont:(UIFont *)segmentTitleFont
{
    _segmentTitleFont = segmentTitleFont;
    self.segmentControl.titleFont = segmentTitleFont;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    _viewControllers = viewControllers;
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *child, NSUInteger idx, BOOL * _Nonnull stop) {
        [child removeFromParentViewController];
    }];
    
    //  initialize
    NSMutableArray *arrayTitle = [[NSMutableArray alloc] init];
    for (UIViewController *c in self.viewControllers) {
        [arrayTitle addObject:c.title];
    }
    self.segmentControl.titles = arrayTitle;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.viewControllers.count, CGRectGetHeight(self.scrollView.frame));
    [self.segmentControl load];
}

#pragma mark - XHSegmentControlDelegate
- (void)xhSegmentSelectAtIndex:(NSInteger)index animation:(BOOL)animation
{
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull controller, NSUInteger idx, BOOL * _Nonnull stop)
     {
         [controller removeFromParentViewController];
     }];
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    //  add controller
    UIViewController *controller = self.viewControllers[index];
    
    //  add view
    UIView *view = controller.view;
    [view removeFromSuperview];
    view.frame = CGRectMake(index * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    
    [controller willMoveToParentViewController:self];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
    [self.scrollView addSubview:view];
    
    //  add next view
    if (index + 1 < self.viewControllers.count) {
        UIViewController *nextController = self.viewControllers[index + 1];
        UIView *nextView = nextController.view;
        [nextView removeFromSuperview];
        nextView.frame = CGRectMake((index + 1) * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        [self.scrollView addSubview:nextView];
    }
    
    //  add previous view
    if (index - 1 >= 0) {
        UIViewController *previousController = self.viewControllers[index - 1];
        UIView *previousView = previousController.view;
        [previousView removeFromSuperview];
        [self.scrollView addSubview:previousView];
        previousView.frame = CGRectMake((index - 1) * CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    }
    [self.scrollView scrollRectToVisible:view.frame animated:animation];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!scrollView.isDecelerating) {
        
        self.beginOffsetX = CGRectGetWidth(scrollView.frame) * self.segmentControl.selectIndex;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat targetX = targetContentOffset->x;
    NSInteger selectIndex = targetX/CGRectGetWidth(self.scrollView.frame);
    self.segmentControl.selectIndex = selectIndex;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex ==0){
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        [parameter setObject:@"homeworkDel" forKey:@"event_code"];
        [parameter setObject:@"" forKey:@"account_id"];
        [parameter setObject:@"" forKey:@"homework_id"];
        [YGNetWorkManager delectHomeworkWithParameter:parameter completion:^(id responseObject) {
            NSLog(@"");
        } fail:^{
            
        }];
    }else{
        
    }
}

@end
