//
//  OETabbar.m
//  LearnOpenGLESWithGPUImage
//
//  Created by apple on 16/7/9.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "OETabbar.h"
//#import "OEProgressView.h"
#define OEScreenWidth ([UIScreen mainScreen].bounds.size.width)
@interface OETabbar()

@property (nonatomic,weak) UIButton *videoButton;
@property (nonatomic,strong) UILabel *upCancelAlertLabel;
@end

@implementation OETabbar

-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupButtons];
//        [self addSubview:self.progressView];
    }
    return self;
}

#pragma mark - Getter

-(OEProgressView *)progressView{
    if( _progressView == nil) {
//        _progressView = [[OEProgressView alloc] initWithFrame:CGRectMake(0, 0, OEScreenWidth, 3)];
//        _progressView.backgroundColor = [UIColor greenColor];
        
    }
    return _progressView;
    
}


- (void)setupButtons {
    
    
    CGFloat baseWidth = OEScreenWidth/8;
    UIButton *videoButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
//    [videoButton setImage:[UIImage imageNamed:@"录制"] forState:UIControlStateNormal];
//    [videoButton setImage:[UIImage imageNamed:@"录制"] forState:UIControlStateHighlighted];
//    
//    [videoButton setImage:[UIImage imageNamed:@"结束"] forState:UIControlStateSelected];
    
    [videoButton setTitle:@"录制" forState:UIControlStateNormal];
    [videoButton setTitle:@"录制" forState:UIControlStateHighlighted];
    [videoButton setTitle:@"结束" forState:UIControlStateSelected];

    
    videoButton.imageView.contentMode = UIViewContentModeCenter;
    [videoButton addTarget:self action:@selector(VideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    videoButton.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height/2);
    self.videoButton = videoButton;
    
    
//    UIButton *convertCamreBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
//    convertCamreBtn.tag = OEConvert;
//    convertCamreBtn.contentMode = UIViewContentModeCenter;
//    [convertCamreBtn setBackgroundImage:[UIImage imageNamed:@"convert"] forState:UIControlStateNormal];
//    [convertCamreBtn setTitle:@"切换" forState:UIControlStateNormal];
//    [convertCamreBtn setBackgroundImage:[UIImage imageNamed:@"convert"] forState:UIControlStateHighlighted];
//    convertCamreBtn.center = CGPointMake(baseWidth, 35);
//    [convertCamreBtn addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
//    dismissBtn.tag = OEDismiss;
//    convertCamreBtn.contentMode = UIViewContentModeScaleAspectFit;
//    dismissBtn.center = CGPointMake(baseWidth*7, 35);
//    [dismissBtn addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
//    [dismissBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
//    [dismissBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [dismissBtn setBackgroundImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateHighlighted];
//    
//    [self addSubview:dismissBtn];
//    [self addSubview:convertCamreBtn];
    [self addSubview:videoButton];
}


- (void)VideoBtnClick:(UIButton *)btn{
    
    if (btn.isSelected) {
        
        if ([self.delegate respondsToSelector:@selector(tabbarDidRecordComplete)]) {
            
            btn.selected = NO;
            
            [self.delegate tabbarDidRecordComplete];
            
        }
        
    }else{
        
        if ([self.delegate respondsToSelector:@selector(tabbarDidRecord)]) {
            
            btn.selected = YES;
            
            [self.delegate tabbarDidRecord];
            
        }
    }
    
}


@end
