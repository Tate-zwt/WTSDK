//
//  ViewController.m
//  WTSDK
//
//  Created by 张威庭 on 15/12/16.
//  Copyright © 2015年 zwt. All rights reserved.
//

#import "ViewController.h"
#import "WTConst.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *introducingLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_introducingLabel settingLabelHeightofRowString:@"源码在WTSDK文件夹里，如果你觉得不错的话，麻烦在GitHub上面点个Star，thank you all!"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
