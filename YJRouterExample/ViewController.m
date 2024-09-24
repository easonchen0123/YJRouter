//
//  ViewController.m
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

#import "ViewController.h"
#import "YJRouter.h"
#import "TestViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *firstButton;
@property (nonatomic, strong) UIButton *secondButton;
@property (nonatomic, strong) UIButton *thirdButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firstButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_firstButton setTitle:@"first" forState:UIControlStateNormal];
    [_firstButton setFrame:CGRectMake(100, 100, 100, 30)];
    [_firstButton addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_firstButton];
    
    _secondButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_secondButton setTitle:@"second" forState:UIControlStateNormal];
    [_secondButton setFrame:CGRectMake(100, 200, 100, 30)];
    [_secondButton addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_secondButton];
    
    _thirdButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_thirdButton setTitle:@"third" forState:UIControlStateNormal];
    [_thirdButton setFrame:CGRectMake(100, 300, 100, 30)];
    [_thirdButton addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_thirdButton];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (IBAction)onTouchUpInside:(id)sender {
    if (sender == self.firstButton) {
        [YJRouter openURL:@"app://first/404/desc?url=aaaa&url2=12312332"];
    } else if (sender == self.secondButton) {
        
        NSArray *array = @[@"1", @"2", @"3"];
        NSDictionary *dic = @{ @"userinfo" : @"testUser" };
        [YJRouter openURL:@"app://second/200?showtype=present" withObject:array userInfo:dic completion:^{
            int a =0;
        }];
//        SecondViewController *vc = [[SecondViewController alloc] init];
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
//        nav.modalPresentationStyle = UIModalPresentationFullScreen;
//        [self presentViewController:nav animated:YES completion:nil];
    } else if (sender == self.thirdButton) {
        
        NSArray *array = @[@"1", @"2", @"3"];
        NSDictionary *dic = @{ @"userinfo" : @"testUser" };
        
        
        
        [YJRouter openURL:@"app://second/200?showtype=present&modaltype=custom&presentationClass=TestViewController" withObject:array userInfo:dic completion:^{
            int a =0;
        }];
    }
}


@end
