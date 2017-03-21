//
//  YGChooseUserTypeVC.m
//  YGSchool
//
//  Created by faith on 17/2/17.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGChooseUserTypeVC.h"
#import "YGCommon.h"
@interface YGChooseUserTypeVC ()

@end

@implementation YGChooseUserTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 568, 320, 100)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    [UIView animateWithDuration:KAnimationInterval animations:^{
        view.top = 100;
    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
