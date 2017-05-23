//
//  XHFilterVideoVC.m
//  GPUImage_FilterVideo
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//



#import "XHFilterVideoVC.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

#import "MBProgressHUD+MJ.h"

#import "OETabbar.h"
#import "GPUImageBeautifyFilter.h"

#import "Masonry.h"

#import "FilterListCollectionView.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define PathToMovie ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.mp4"])


@interface XHFilterVideoVC ()<GPUImageVideoCameraDelegate,OETabbarDelegate , FilterListCollectionViewDelegate>

@property (nonatomic , strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic , strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic , strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic , strong) GPUImageView *filterView;

//BeautifyFace美颜滤镜
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;


@property (nonatomic,strong) OETabbar *tabbar;

@property (nonatomic ,strong) UIButton *FilterListBtn;
@property (nonatomic ,strong) FilterListCollectionView *FilterListCollection;

@end

@implementation XHFilterVideoVC

- (instancetype)init {
    if (self = [super init]) {
//        [self setupView];
        [self setupCameraView];
        [self setupTabbar];
        
        [self setupFilterListBtn];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
}


- (void)setupCameraView {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    [_videoCamera addAudioInputsAndOutputs];
    _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    _videoCamera.delegate = self;
    
    _filter = [[GPUImageBeautifyFilter alloc] init];
    CGRect frame = self.view.bounds;//CGRectMake(0, 0.f, ScreenWidth , ScreenWidth);
    _filterView = [[GPUImageView alloc] initWithFrame:frame];
    _filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview: _filterView];
    

    
    [_videoCamera addTarget:_filter];
    [_filter addTarget:_filterView];
    [_videoCamera startCameraCapture];
    

    
}


- (void)setupFilterListBtn{
    
    _FilterListBtn = [[UIButton alloc]init];
    [self.view addSubview:_FilterListBtn];
    [_FilterListBtn addTarget:self action:@selector(FilterListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _FilterListBtn.backgroundColor = [UIColor redColor];
    [_FilterListBtn setTitle:@"滤镜展开" forState:UIControlStateNormal];
    [_FilterListBtn setTitle:@"滤镜关闭" forState:UIControlStateSelected];
    _FilterListBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_FilterListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(70, 45));
        make.bottom.equalTo(self.tabbar.mas_top).offset(- 50);
        make.left.equalTo(self.tabbar).offset(15);

    }];
    
}


- (void)FilterListBtnClick:(UIButton *)btn{

    if (btn.isSelected) {
        
        //关闭
        self.FilterListCollection.hidden = YES;
        
    }else{
    
        //展开
        self.FilterListCollection.hidden = NO;
    
    }
    
    
    btn.selected = !btn.isSelected;

}


- (void)setupTabbar {
    
    CGRect rect = CGRectMake(0, ScreenHeight-70, ScreenWidth, 70);
    OETabbar *tabbar = [[OETabbar alloc] initWithFrame:rect];
    tabbar.delegate = self;
    tabbar.backgroundColor = [UIColor blackColor];
    [self.view addSubview:tabbar];
    self.tabbar = tabbar;
    
}
-(void)tabbarDidCancelRecord {
    
    [self cancelCamre];

}
-(void)tabbarDidRecordComplete {
    
    [self stopCamre];
    
    self.FilterListBtn.enabled = YES;
    
}
-(void)tabbarDidRecord {
    
    [self startCamre];

    self.FilterListBtn.enabled = NO;

}

#pragma mark - OETabBarDelegate
- (void)tabbarButtonDidClick:(UIButton *)sender {
    switch (sender.tag) {
        case OEConvert:
            [self convertCamre];
            break;
        case OEDismiss:
            [self dismissBtnClick];
            break;
        default:
            break;
    }
}

#pragma mark - tabbar Button
- (void)dismissBtnClick {
//    [self dismissPopupControllerAnimated:YES];
}

- (void)convertCamre {
    [_videoCamera rotateCamera];
}

- (void)startCamre {

        NSURL *movieURL = [NSURL fileURLWithPath:PathToMovie];
        unlink([PathToMovie UTF8String]); // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(540, 960)];
        _movieWriter.encodingLiveVideo = YES;
        [_filter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];

}

- (void)cancelCamre {
    _videoCamera.delegate = nil;
    [_filter removeTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = nil;
    [_movieWriter cancelRecording];
    _movieWriter = nil;
}

- (void)stopCamre {
    

        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecordingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //保存
                 [self savePhoneLibrary:PathToMovie];
            });
        }];
}

//保存到相册
-(void)savePhoneLibrary:(NSString *)url{
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    NSURL *movieURL = [NSURL fileURLWithPath:url];
    
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url))
    {
        [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
         {
             
             if (error) {
                 
                 [MBProgressHUD showError:@"error"];
                
             } else {
                 
                 [MBProgressHUD showSuccess:@"success"];
             }
         }];
    }
    
}


#pragma mark - GPUImageVideoCamreaDelegate   视频实时数据
- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {

    
}

#pragma mark - ------ 滤镜切换


-(void)changeEffct:(GPUImageFilterGroup *)mFilter{
    
//    //移除上一个效果
    [_videoCamera removeTarget:_filter];
    
    _filter = mFilter;
    
    // 添加滤镜到相机上
    [_videoCamera addTarget:_filter];
    [_filter addTarget:_filterView];


    
}



#pragma mark - FilterListCollection Delegate

- (void)FilterSelected:(NSInteger)num{
    
    //创建一个新的滤镜
    
    GPUImageFilterGroup * FilterGroup = [[NSClassFromString(FilterArray[num]) alloc]init];
    //调用切换滤镜方法
    [self changeEffct:FilterGroup];
    
    
    //关闭
    self.FilterListBtn.selected = NO;
    self.FilterListCollection.hidden = YES;
}


- (FilterListCollectionView *)FilterListCollection{
    
    if (!_FilterListCollection) {
        
        _FilterListCollection = [FilterListCollectionView CreateFilterView];
        _FilterListCollection.FilterDelegate = self;
        [self.view addSubview:_FilterListCollection];
        [_FilterListCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        
            make.centerY.equalTo(self.FilterListBtn).offset(0);
            make.left.equalTo(self.FilterListBtn.mas_right).offset(10);
            make.right.equalTo(self.view).offset(-10);
            make.height.mas_equalTo(140);
            
        }];
        
    }
    
    return _FilterListCollection;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
