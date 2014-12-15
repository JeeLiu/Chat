//
//  SKYHomeViewController.m
//  Chat
//
//  Created by sky on 14/12/15.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SKYHomeViewController.h"

@interface SKYHomeViewController ()

@end

@implementation SKYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"Balloon"];
    self.view.layer.contents = (id) image.CGImage;
    // 如果需要背景透明加上下面这句
//    self.view.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    // Do any additional setup after loading the view.
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
