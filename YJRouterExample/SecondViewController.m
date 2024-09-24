//
//  SecondViewController.m
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

#import "SecondViewController.h"
#import "YJRouter.h"

@interface SecondViewController ()

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, strong) UIButton *button2;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"button" forState:UIControlStateNormal];
    [_button setFrame:CGRectMake(100, 100, 100, 30)];
    [_button addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button2 setTitle:@"button2" forState:UIControlStateNormal];
    [_button2 setFrame:CGRectMake(100, 200, 100, 30)];
    [_button2 addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_button2];
    
    
    NSDictionary *dic = [YJRouter extractParam:@"second"];
    if (dic != nil) {
        NSString *ID = [dic objectForKey:@"id"];
        NSString *desc = [dic objectForKey:@"desc"];
        NSArray *array = dic[YJRouterParameterUserInfo];
        NSDictionary *userinfo = dic[YJRouterParameterObject];
        
        NSLog(@"id: %@", ID);
        NSLog(@"desc: %@", desc);
        NSLog(@"array: %@", array);
        NSLog(@"userinfo: %@", userinfo);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)onTouchUpInside:(id)sender {
    if (sender == self.button) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender == self.button2) {
        
        [YJRouter openURL:@"app://second/200?showtype=present"];
//        SecondViewController *vc = [[SecondViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        nav.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:nav animated:YES completion:nil];
    }
}


@end
