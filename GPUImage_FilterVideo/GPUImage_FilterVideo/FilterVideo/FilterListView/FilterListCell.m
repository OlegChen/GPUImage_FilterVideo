//
//  FilterListCell.m
//  GPUImage_FilterVideo
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//

#import "FilterListCell.h"

@implementation FilterListCell

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        UILabel *label = [[UILabel alloc]init];
        self.title = label;
        [self.contentView addSubview:label];
        label.frame = CGRectMake(0, 0, 100, 20);
        label.text = @"000";
        
        
    }

    return self;
}

@end
