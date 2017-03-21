//
//  YGHomeWorkListCell.m
//  YGSchool
//
//  Created by faith on 17/2/17.
//  Copyright © 2017年 YDK. All rights reserved.
//

#import "YGHomeWorkListCell.h"
#import "YGCommon.h"

@interface YGHomeWorkListCell()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic, strong)UILabel *coursesLbl;
@property(nonatomic, strong)UILabel *classLbl;
@property (nonatomic,strong)UIView *containerView;
@property (nonatomic,strong)UIButton *edit;
@property (nonatomic,strong)UIButton *delect;
@property (nonatomic,strong)UIButton *signDetail;
@property (nonatomic,strong)UILabel *contentLbl;


@end
@implementation YGHomeWorkListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    return self;
}
- (UILabel *)coursesLbl{
    if(!_coursesLbl){
        _coursesLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 50, 20)];
        _coursesLbl.font = [UIFont systemFontOfSize:16];
        [self addSubview:_coursesLbl];
    }
    return _coursesLbl;
}
- (UILabel *)classLbl{
    if(!_classLbl){
        _classLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 140, 20)];
        _classLbl.font = [UIFont systemFontOfSize:16];
        [self addSubview:_classLbl];
    }
    return _classLbl;

}
- (UIView *)containerView
{
    if(!_containerView)
    {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(10, self.classLbl.bottom, kScreenWidth - 120, 50)];
    }
    return _containerView;
}
- (UIButton *)edit{
    if(!_edit){
        _edit = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 10, 60, 30)];
        [_edit setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
        _edit.titleLabel.font = [UIFont systemFontOfSize:16];
        _edit.layer.cornerRadius = 7;
        [_edit.layer setMasksToBounds:YES];
        [_edit setTitle:@"审核" forState:UIControlStateNormal];
        [_edit addTarget:self action:@selector(editAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _edit;
}
- (UIButton *)delect{
    if(!_delect){
        _delect = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 45, 60, 30)];
        [_delect setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
        _delect.titleLabel.font = [UIFont systemFontOfSize:16];
        _delect.layer.cornerRadius = 7;
        [_delect.layer setMasksToBounds:YES];
        [_delect setTitle:@"删除" forState:UIControlStateNormal];
        [_delect addTarget:self action:@selector(delectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delect;

}
- (UIButton *)signDetail{
    if(!_signDetail){
        _signDetail = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 80, 80, 60, 30)];
        [_signDetail setBackgroundColor:COLOR_WITH_HEX(0x4285d4)];
        _signDetail.titleLabel.font = [UIFont systemFontOfSize:8];
        _signDetail.layer.cornerRadius = 7;
        [_signDetail.layer setMasksToBounds:YES];
        [_signDetail setTitle:@"签字详情(0/0)" forState:UIControlStateNormal];
        [_signDetail addTarget:self action:@selector(signDetailAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signDetail;
    
}
- (UILabel *)contentLbl{
    if(!_contentLbl){
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 100, kScreenWidth - 60, 200)];
        _contentLbl.font = [UIFont systemFontOfSize:16];
        _contentLbl.numberOfLines = 0;
        _contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
//        _contentLbl.adjustsFontSizeToFitWidth =YES;
        _contentLbl.textColor = COLOR(175, 175, 175, 1);
        [self addSubview:_contentLbl];
    }
    return _contentLbl;
}

- (void)setItem:(YGHomeWorkListItem *)item{
    [self addSubview:self.edit];
    [self addSubview:self.delect];
    [self addSubview:self.signDetail];
    [self addSubview:self.containerView];
    int imageCount = 3;
    for (int index = 0; index < imageCount; index++) {
        //计算这个app在几行几列
        int totalColumns = 2;
        int row=index/totalColumns;
        int col=index%totalColumns;
        int appW = (kScreenWidth - 160)/2;
        int appH = (kScreenWidth - 160)/2;
        UIImageView *itemBtn = [[UIImageView alloc]init];
        itemBtn.frame = CGRectMake(col*(5+appW), row*(5+appH), appW, appH);
        itemBtn.tag = index;
        itemBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [itemBtn addGestureRecognizer:tap];
        itemBtn.image = item.imgs[index];
        itemBtn.layer.cornerRadius = 5;
        [self.containerView addSubview:itemBtn];
        self.containerView.height = imageCount/2*(5 + appH);
        if(imageCount%2!=0){
            self.containerView.height = (imageCount/2+1)*(5 + appH);
        }

    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.containerView.bottom+5, 40, 20)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"内容:";
    [self addSubview:label];
    NSString *content = item.desc;
    
    
    CGSize s = [content textSizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth - 60, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    
    self.contentLbl.top = label.bottom;
    self.contentLbl.height = s.height;
    self.contentLbl.text = content;
    self.coursesLbl.text = item.course;
    self.classLbl.text = item.classId;
}
- (void)tapAction:(UITapGestureRecognizer *)sender{
    
    if(self.enlargeImageBlock){
        self.enlargeImageBlock(sender.self.view.tag);
    }
}
- (void)editAction:(UIButton *)sender{
    if(self.editBlock){
        self.editBlock();
    }
}
- (void)delectAction:(UIButton *)sender{
    if(self.delectBlock){
        self.delectBlock();
    }
}
- (void)signDetailAction:(UIButton *)sender{
    if(self.signBlock){
        self.signBlock();
    }
}
- (void)setDic:(NSDictionary *)dic{
    _dic = dic;
    [self addSubview:self.edit];
    [self addSubview:self.delect];
    [self addSubview:self.signDetail];
    [self addSubview:self.containerView];
    NSArray *imags = dic[@"imgs"];
    NSInteger imageCount = imags.count;
    for (int index = 0; index < imageCount; index++) {
        //计算这个app在几行几列
        int totalColumns = 2;
        int row=index/totalColumns;
        int col=index%totalColumns;
        int appW = (kScreenWidth - 160)/2;
        int appH = (kScreenWidth - 160)/2;
        UIImageView *itemBtn = [[UIImageView alloc]init];
        itemBtn.frame = CGRectMake(col*(5+appW), row*(5+appH), appW, appH);
        itemBtn.tag = index;
        itemBtn.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [itemBtn addGestureRecognizer:tap];
        
        [itemBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imags[index]]] placeholderImage:[UIImage imageNamed:@"i1"]];
//        itemBtn.image = item.imgs[index];
        itemBtn.layer.cornerRadius = 5;
        [self.containerView addSubview:itemBtn];
        self.containerView.height = imageCount/2*(5 + appH);
        if(imageCount%2!=0){
            self.containerView.height = (imageCount/2+1)*(5 + appH);
        }
        
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, self.containerView.bottom+5, 40, 20)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"内容:";
    [self addSubview:label];
    NSString *content = dic[@"desc"];
    
    
    CGSize s = [content textSizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(kScreenWidth - 60, 10000) lineBreakMode:NSLineBreakByCharWrapping];
    
    self.contentLbl.top = label.bottom;
    self.contentLbl.height = s.height;
    self.contentLbl.text = content;
    self.coursesLbl.text = dic[@"course"];
//    self.classLbl.text = item.classId;

    
}
@end
