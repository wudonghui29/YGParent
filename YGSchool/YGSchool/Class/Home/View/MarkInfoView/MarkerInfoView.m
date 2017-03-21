//
//  MarkerInfoView.m
//  YLDGPS
//
//  Created by user on 15/12/16.
//  Copyright © 2015年 user. All rights reserved.
//

#import "MarkerInfoView.h"
#import "YGCommon.h"

@interface MarkerInfoView ()
@property (nonatomic, strong) UILabel                   *titleLabel;
@property (nonatomic, strong) UILabel                   *subTitleLabel;
@property (nonatomic, strong) UILabel                   *subTitleLabel1;
@property (nonatomic, strong) LTextRImageBtn            *button1;
@property (nonatomic, strong) TImageBTitleBtn           *button2;
@property (nonatomic, strong) TImageBTitleBtn           *button3;
@property (nonatomic, strong) TImageBTitleBtn           *button4;
@property (nonatomic, strong) TImageBTitleBtn           *button5;
@property (nonatomic, strong) UIActivityIndicatorView   *activityIndicatorView;
@end

@implementation MarkerInfoView
#pragma mark - life cyle
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.subTitleLabel1];
    [self addSubview:self.activityIndicatorView];
    
    if(self.needBtn) {
        [self addSubview:self.button1];
        [self addSubview:self.button2];
        [self addSubview:self.button3];
        [self addSubview:self.button4];
        [self addSubview:self.button5];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowOffset = CGSizeMake(0, -5);
    self.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    
    self.hidden = YES;
    
    [self rac];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.frame;
    
    frame.size.height = 130;
    frame.size.width = self.superview.frame.size.width;
    self.frame = frame;
    
    CGFloat rightBtnWidth = 65;
    CGFloat rightBtnSideGap = 6;
    
    frame.origin.x = 5;
    frame.origin.y = 5;
    frame.size.width = self.frame.size.width - frame.origin.x - (self.needBtn?(rightBtnSideGap*2 + rightBtnWidth):frame.origin.x);
    frame.size.height = self.titleLabel.font.lineHeight;
    self.titleLabel.frame = frame;
    
    frame.origin.y = CGRectGetMaxY(frame) + 5;
    frame.size.height = self.subTitleLabel.font.lineHeight;
    self.subTitleLabel.frame = frame;
    
    frame.origin.y = CGRectGetMaxY(frame) + 5;
    frame.size.height = self.subTitleLabel1.font.lineHeight*self.subTitleLabel1.numberOfLines;
    self.subTitleLabel1.frame = frame;
    
    self.activityIndicatorView.frame = frame;
    
    if(self.needBtn) {
        
        frame.size.height = 40;
        frame.size.width = rightBtnWidth;
        frame.origin.x = self.frame.size.width - rightBtnSideGap - rightBtnWidth - rightBtnSideGap;
        frame.origin.y = (self.frame.size.height - frame.size.height)/2;
        self.button1.frame = frame;
        
        CGFloat btnHeight = 55;
        CGFloat btnGap = 0;
        frame.origin.x = btnGap;
        frame.origin.y = CGRectGetMaxY(self.subTitleLabel1.frame) + 15;
        frame.size.width = (self.bounds.size.width - btnGap*5)/4;
        frame.size.height = btnHeight;
        self.button2.frame = frame;
        
        frame.origin.x = CGRectGetMaxX(self.button2.frame) + btnGap;
        self.button3.frame = frame;
        
        frame.origin.x = CGRectGetMaxX(self.button3.frame) + btnGap;
        self.button4.frame = frame;
        
        frame.origin.x = CGRectGetMaxX(self.button4.frame) + btnGap;
        self.button5.frame = frame;
    }
    
    frame.origin.x = 0;
    frame.size.width = self.superview.frame.size.width;
    frame.size.height = CGRectGetMaxY(frame) + 10;
    frame.origin.y = self.superview.frame.size.height - (self.hidden?0:(frame.size.height + self.tabHeight));
    self.frame = frame;
}

#pragma mark - public methods
- (void)show {
    if(!self.hidden) return;
    [self layoutSubviews];
    CGRect frame = self.frame;
    frame.origin.y = self.superview.frame.size.height;
    self.frame = frame;
    [UIView animateWithDuration:KAnimationInterval animations:^{
        self.hidden = NO;
        CGRect frame1 = self.frame;
        frame1.origin.y = self.superview.frame.size.height - (frame.size.height + self.tabHeight);
        self.frame = frame1;
    } completion:^(BOOL finished) {
        self.hidden = NO;
    }];
}

- (void)hiden {
    if(self.hidden) return;
    CGRect frame = self.frame;
    frame.origin.y = self.superview.frame.size.height;
    self.frame = frame;
    self.hidden = YES;
}

#pragma mark - private methods
- (void)rac {
    @weakify(self);
    [[self.button1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(markerInfoViewBtn1Pressed:)]) {
            [self.delegate markerInfoViewBtn1Pressed:self];
        }
    }];
    
    [[self.button2 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(markerInfoViewBtn2Pressed:)]) {
            [self.delegate markerInfoViewBtn2Pressed:self];
        }
    }];
    
    [[self.button3 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(markerInfoViewBtn3Pressed:)]) {
            [self.delegate markerInfoViewBtn3Pressed:self];
        }
    }];
    
    [[self.button4 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(markerInfoViewBtn4Pressed:)]) {
            [self.delegate markerInfoViewBtn4Pressed:self];
        }
    }];
    
    [[self.button5 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(markerInfoViewBtn5Pressed:)]) {
            [self.delegate markerInfoViewBtn5Pressed:self];
        }
    }];
}

#pragma mark - getters and setters
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = _subTitle;
}

- (void)setSubTitle1:(NSString *)subTitle1 {
    _subTitle1 = subTitle1;
    self.subTitleLabel1.text = _subTitle1;
}

- (void)setBtnTitle1:(NSString *)btnTitle1 {
    _btnTitle1 = btnTitle1;
    [self.button1 setTitle:_btnTitle1 forState:UIControlStateNormal];
}

- (void)setBtnTitle2:(NSString *)btnTitle2 {
    _btnTitle2 = btnTitle2;
    [self.button2 setTitle:_btnTitle2 forState:UIControlStateNormal];
}

- (void)setBtnTitle3:(NSString *)btnTitle3 {
    _btnTitle3 = btnTitle3;
    [self.button3 setTitle:_btnTitle3 forState:UIControlStateNormal];
}

- (void)setIsLoadingAddress:(BOOL)isLoadingAddress {
    _isLoadingAddress = isLoadingAddress;
    if(_isLoadingAddress) {
        [self.activityIndicatorView startAnimating];
        self.subTitleLabel1.text = nil;
    }else {
        [self.activityIndicatorView stopAnimating];
    }
}

- (UILabel*)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _titleLabel;
}

- (UILabel*)subTitleLabel {
    if(_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [UIColor blackColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subTitleLabel;
}

- (UILabel*)subTitleLabel1 {
    if(_subTitleLabel1 == nil) {
        _subTitleLabel1 = [[UILabel alloc] init];
        _subTitleLabel1.backgroundColor = [UIColor clearColor];
        _subTitleLabel1.textColor = [UIColor blackColor];
        _subTitleLabel1.font = [UIFont systemFontOfSize:14];
        _subTitleLabel1.numberOfLines = 3;
        _subTitleLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _subTitleLabel1;
}

- (UIActivityIndicatorView*)activityIndicatorView {
    if(_activityIndicatorView == nil) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        _activityIndicatorView.color = [UIColor grayColor];
    }
    return _activityIndicatorView;
}

- (LTextRImageBtn*)button1 {
    if(_button1 == nil) {
        _button1 = [LTextRImageBtn buttonWithType:UIButtonTypeCustom];
        _button1.titleLabel.font = [UIFont systemFontOfSize:12];
        [_button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button1 setTitle:@"详情" forState:UIControlStateNormal];
        [_button1 setImage:[UIImage imageNamed:@"rightArrow"] forState:UIControlStateNormal];
        _button1.titleLabel.textAlignment = NSTextAlignmentRight;
    }
    return _button1;
}

- (TImageBTitleBtn*)button2 {
    if(_button2 == nil) {
        _button2 = [TImageBTitleBtn buttonWithType:UIButtonTypeCustom];
        _button2.titleLabel.font = [UIFont systemFontOfSize:11];
        [_button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button2 setTitle:@"回放" forState:UIControlStateNormal];
        [_button2 setImage:[UIImage imageNamed:@"plackBack"] forState:UIControlStateNormal];
        _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _button2;
}

- (TImageBTitleBtn*)button3 {
    if(_button3 == nil) {
        _button3 = [TImageBTitleBtn buttonWithType:UIButtonTypeCustom];
        _button3.titleLabel.font = [UIFont systemFontOfSize:11];
        [_button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button3 setTitle:@"导航" forState:UIControlStateNormal];
        [_button3 setImage:[UIImage imageNamed:@"iconNavigation"] forState:UIControlStateNormal];
        _button3.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _button3;
}

- (TImageBTitleBtn*)button4 {
    if(_button4 == nil) {
        _button4 = [TImageBTitleBtn buttonWithType:UIButtonTypeCustom];
        _button4.titleLabel.font = [UIFont systemFontOfSize:11];
        [_button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button4 setTitle:@"追踪" forState:UIControlStateNormal];
        [_button4 setImage:[UIImage imageNamed:@"track"] forState:UIControlStateNormal];
        _button4.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _button4;
}

- (TImageBTitleBtn*)button5 {
    if(_button5 == nil) {
        _button5 = [TImageBTitleBtn buttonWithType:UIButtonTypeCustom];
        _button5.titleLabel.font = [UIFont systemFontOfSize:11];
        [_button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_button5 setTitle:@"街景" forState:UIControlStateNormal];
        [_button5 setImage:[UIImage imageNamed:@"streetView"] forState:UIControlStateNormal];
        _button5.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _button5;
}

@end
