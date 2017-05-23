//
//  FilterListCollectionView.m
//  GPUImage_FilterVideo
//
//  Created by apple on 2017/3/23.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//

#import "Masonry.h"

#import "FilterListCollectionView.h"
#import "FilterListCell.h"

@interface FilterListCollectionView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@end

@implementation FilterListCollectionView

+ (FilterListCollectionView *)CreateFilterView{

    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake(158, 130);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 12;
    
    FilterListCollectionView *collectionView = [[FilterListCollectionView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 15 - 45 - 30,130) collectionViewLayout:layout];
    
    
//    [self.contentView addSubview:collectionView];
//    
//    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        //                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 15, 10, 15));
//        
//        make.top.equalTo(_BGImageView.mas_bottom).offset(10);
//        make.left.equalTo(self.contentView).offset(PaddingLeftWidth);
//        make.right.equalTo(self.contentView).offset(-PaddingLeftWidth);
//        make.height.mas_equalTo(140);
//        
//    }];

    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.scrollsToTop = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[FilterListCell class] forCellWithReuseIdentifier:FilterListCell_id];
    
    
    return collectionView;
    
}


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    self = [super initWithFrame:frame collectionViewLayout:layout];
    
    if (self) {
        
        
        self.delegate = self;
        self.dataSource = self;
        
        [self reloadData];
        
    }
    
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return FilterArray.count;
}

- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    FilterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FilterListCell_id forIndexPath:indexPath];
    
    cell.title.text = FilterArrayName[indexPath.row];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.FilterDelegate respondsToSelector:@selector(FilterSelected:)]) {
        
        [self.FilterDelegate FilterSelected:indexPath.row];
    }
    
}




@end
