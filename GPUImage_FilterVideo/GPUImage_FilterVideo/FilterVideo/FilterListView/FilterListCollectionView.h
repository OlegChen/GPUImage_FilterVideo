//
//  FilterListCollectionView.h
//  GPUImage_FilterVideo
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//



// 34 #import "GPUImageSepiaFilter.h"                     //褐色（怀旧）

#import "FWAmaroFilter.h"
#import "GPUImageSoftEleganceFilter.h"//复古
#import "FWNashvilleFilter.h"
#import "FWRiseFilter.h"
#import "FWInkwellFilter.h"

#define FilterArray @[@"GPUImageBeautifyFilter"/*美化*/,@"FWNashvilleFilter" /* HDR*/ , @"FWRiseFilter" /*彩虹瀑*/,@"GPUImageSoftEleganceFilter"/*复古*/,@"FWInkwellFilter"/*黑白*/,@"GPUImageSketchFilter"/*素描*/, @"GPUImagePosterizeFilter"/*色调分离*/,]

#define FilterArrayName @[@"美化",@"HDR",@"彩虹瀑",@"复古",@"黑白",@"素描",@"色调分离",]

typedef void(^FilterSelected)(NSInteger num);


@protocol FilterListCollectionViewDelegate <NSObject>

- (void)FilterSelected:(NSInteger)num;

@end

#import <UIKit/UIKit.h>

@interface FilterListCollectionView : UICollectionView


+ (FilterListCollectionView *)CreateFilterView;


//@property (nonatomic ,copy) FilterSelected SelectBlock;

@property (nonatomic ,weak) id <FilterListCollectionViewDelegate> FilterDelegate;

@end
