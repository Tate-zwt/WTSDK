//
//  TestViewController.m
//  WTSDK
//
//  Created by 张威庭 on 16/9/8.
//  Copyright © 2016年 zwt. All rights reserved.
//

#import "TestViewController.h"
#import "WTConst.h"
@interface TestViewController ()
@property (weak, nonatomic) IBOutlet UILabel *htmlLabel;
@property (weak, nonatomic) IBOutlet UILabel *htmlHeightLabel;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *htmlStr = @"<div>Tate<span style='color:#1C86EE;'>《WTSDK》</span> <span style='color:#1C86EE;'>Tate_zwt</span> star <span style='color:#FF3E96;'>源码在WTSDK文件夹里，如果你觉得不错的话，麻烦在GitHub上面点个Star，thank you all!";
    [_htmlLabel htmlString:htmlStr];
    
    [_htmlHeightLabel htmlString:htmlStr labelRowOfHeight:12];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
