//
//  ViewController.m
//  GPUImage_FilterVideo
//
//  Created by apple on 2017/3/22.
//  Copyright © 2017年 chenxianghong. All rights reserved.
//

#import "ViewController.h"
#import "XHFilterVideoVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    UIButton *btn = [[UIButton alloc]init];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"滤镜拍摄" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 100, 100, 35);
    
    
}

- (void)click{

    XHFilterVideoVC *vc = [[XHFilterVideoVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
