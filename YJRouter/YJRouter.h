//
//  YJRouter.h
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

// V 0.1.2          2016.10.31          by ChenYijun
//
// 如果要弹出样式，url带上?showtype=present

#import <UIKit/UIKit.h>

extern NSString *const YJRouterParameterURL;
extern NSString *const YJRouterParameterCompletion;
extern NSString *const YJRouterParameterUserInfo;
extern NSString *const YJRouterParameterObject;

/**
 *  routerParameters 里内置的几个参数会用到上面定义的 string
 */
typedef void (^MGJRouterHandler)(NSDictionary *routerParameters);





@interface YJRouter : NSObject

/**
 *  YJRouter实例
 */
+ (YJRouter *)sharedInstance;

/**
 *  内部url前缀
 *  默认为"app"
 */
@property (nonatomic, strong) NSString *appPrefixName;
/**
 *  NavigationController的类名
 *  默认为"UINavigationController"
 */
@property (nonatomic, strong) NSString *navigationClassName;
/**
 *  present viewcontroller的父controller
 */
@property (nonatomic, assign) UIViewController *rootViewController;

/**
 *  通过数组注册ViewController
 *
 *  @param array                        字典数组，字典元素为url_pattern，controller
 */
+ (void)registerURLPatternWithArray:(NSArray *)array;

/**
 *  注册ViewController
 *
 *  @param URLPattern                   URL
 *  @param className                    类名
 */
+ (void)registerURLPattern:(NSString *)URLPattern forClass:(NSString *)className;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 */
+ (void)openURL:(NSString *)URL;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param object                       参数对象
 */
+ (void)openURL:(NSString *)URL withObject:(id)object;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param userInfo                     参数字典
 */
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param object                       参数对象
 *  @param userInfo                     参数字典
 */
+ (void)openURL:(NSString *)URL withObject:(id)object userInfo:(NSDictionary *)userInfo;

/**
 *  提取参数
 *
 *  @param URL                          URLPattern
 *  @return                             对象
 */
+ (id)extractParam:(NSString *)URL;

@end
