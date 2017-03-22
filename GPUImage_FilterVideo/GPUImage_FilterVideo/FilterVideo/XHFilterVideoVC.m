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
#import "RecordButton.h"
#import "GPUImageBeautifyFilter.h"

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.width)
#define PathToMovie ([NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.mp4"])


@interface XHFilterVideoVC ()<GPUImageVideoCameraDelegate,OETabbarDelegate>

@property (nonatomic , strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic , strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic , strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic , strong) GPUImageView *filterView;

//BeautifyFace美颜滤镜
@property (nonatomic, strong) GPUImageBeautifyFilter *beautifyFilter;


@property (nonatomic,strong) OETabbar *tabbar;


@property (strong, nonatomic) AVCaptureMetadataOutput *medaDataOutput;
@property (strong, nonatomic) dispatch_queue_t captureQueue;
@property (nonatomic, strong) NSArray *faceObjects;

@property (nonatomic,strong) UILabel * faceBorderLab;

@end

@implementation XHFilterVideoVC

- (instancetype)init {
    if (self = [super init]) {
//        [self setupView];
        [self setupCameraView];
        [self setupTabbar];
//        [self setupPopupAnimation];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)setupCameraView {
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    [_videoCamera addAudioInputsAndOutputs];
    _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    _videoCamera.delegate = self;
    
    _filter = [[GPUImageBeautifyFilter alloc] init];
    CGRect frame = CGRectMake(0, 70.f, ScreenWidth , ScreenWidth);
    _filterView = [[GPUImageView alloc] initWithFrame:frame];
    _filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.view addSubview: _filterView];
    

    
    [_videoCamera addTarget:_filter];
    [_filter addTarget:_filterView];
    [_videoCamera startCameraCapture];
    

    
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
//    if (self.videoMaxTime>0){
//        [self stopTimer];
//    }
}
-(void)tabbarDidRecordComplete {
    
//    if (self.videoMaxTime > 0.0 && self.timer == nil){//时间到与手势完成重复执行了stopCamre方法 判断避免重复保存
//        return;
//    }
    [self stopCamre];
//    if (self.videoMaxTime > 0.0){
//        [self stopTimer];
//    }
    
}
-(void)tabbarDidRecord {
    [self startCamre];
//    if (self.videoMaxTime>0){
//        //        [self.tabbar progressStart];
//        [self startTimer];
//    }
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
//    if ([self.delegate respondsToSelector:@selector(popVideoControllerWillOutputSampleBuffer:)]) {
//        _videoCamera.delegate = self;
//    }

    
//    if ([self.delegate respondsToSelector:@selector(popVideoControllerDidSave:)]) {
        NSURL *movieURL = [NSURL fileURLWithPath:PathToMovie];
        unlink([PathToMovie UTF8String]); // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480, 640)];
        _movieWriter.encodingLiveVideo = YES;
        [_filter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];
//    }
}
- (void)cancelCamre {
    _videoCamera.delegate = nil;
    [_filter removeTarget:_movieWriter];
    _videoCamera.audioEncodingTarget = nil;
    [_movieWriter cancelRecording];
    _movieWriter = nil;
}

- (void)stopCamre {
    
//    if ([self.delegate respondsToSelector:@selector(popVideoControllerWillOutputSampleBuffer:)]) {
//        _videoCamera.delegate = nil;
//    }
    
//    if ([self.delegate respondsToSelector:@selector(popVideoControllerDidSave:)]) {
        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecordingWithCompletionHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.delegate popVideoControllerDidSave:PathToMovie];
                
                //保存
                 [self savePhoneLibrary:PathToMovie];
            });
        }];
//    }
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


-(void)changeEffct:(GPUImageFilter *)mFilter withBtn:(UIButton *)btn{
    
//    //移除上一个效果
//    [_mCamera removeTarget:_mFilter];
//    
//    _mFilter = mFilter;
//    
//    // 添加滤镜到相机上
//    [_mCamera addTarget:_mFilter];
//    [_mFilter addTarget:_mGPUImageView];
//    
//    //调用收缩滤镜方法的方法
//    [self resumeState];
//    [self btnState:btn];
    
}

//
//- (void)btnAction:(UIButton *)btn{
//    
//    switch (btn.tag) {
//        case (EffctTypeOne):{
//            //创建一个新的滤镜
//            GPUImageBulgeDistortionFilter *mfilter = [[GPUImageBulgeDistortionFilter alloc]init];
//            
//            //调用切换滤镜方法
//            [self changeEffct:mfilter withBtn:btn];
//        }
//            break;
//        case (EffctTypeTwo):{
//            GPUImagePinchDistortionFilter *mfilter = [[GPUImagePinchDistortionFilter alloc]init];
//            [self changeEffct:mfilter withBtn:btn];
//        }
//            break;
//        case (EffctTypeThree):{
//            GPUImageStretchDistortionFilter *mfilter = [[GPUImageStretchDistortionFilter alloc]init];
//            [self changeEffct:mfilter withBtn:btn];
//        }
//            break;
//        case (EffctTypeFour):{
//            GPUImageGlassSphereFilter *mfilter = [[GPUImageGlassSphereFilter alloc]init];
//            
//            [self changeEffct:mfilter withBtn:btn];
//        }
//            break;
//        case (EffctTypeFive):{
//            GPUImageVignetteFilter *mfilter = [[GPUImageVignetteFilter alloc]init];
//            [self changeEffct:mfilter withBtn:btn];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
