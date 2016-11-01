//
//  FirstViewController.m
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

#import "FirstViewController.h"
#import "YJRouter.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor blueColor]];
    
    
    NSDictionary *dic = [YJRouter extractParam:@"first"];
    if (dic != nil) {
        NSString *ID = [dic objectForKey:@"id"];
        NSString *desc = [dic objectForKey:@"desc"];
        NSLog(@"id: %@", ID);
        NSLog(@"desc: %@", desc);
    }
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
