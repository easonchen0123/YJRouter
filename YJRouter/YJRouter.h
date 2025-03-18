//
//  YJRouter.h
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

// v 1.0.0          2016.10.31          by ChenYijun
//
// 如果要弹出样式，url带上?showtype=present

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const YJRouterParameterURL;
extern NSString *const YJRouterParameterCompletion;
extern NSString *const YJRouterParameterUserInfo;
extern NSString *const YJRouterParameterObject;

/**
 *  routerParameters 里内置的几个参数会用到上面定义的 string
 */
typedef void (^MGJRouterHandler)(NSDictionary *routerParameters);
typedef UINavigationController * _Nullable (^GetNavigationControllerBlock)(void);




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
 *  特殊框架下自定义获取NavigationController的Block
 */
@property (nonatomic, strong) GetNavigationControllerBlock getNavigationControllerBlock;



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
+ (UIViewController *)openURL:(NSString *)URL;


/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param completion           block
 */
+ (UIViewController *)openURL:(NSString *)URL completion:(void (^ __nullable)(void))completion;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param object                       参数对象
 */
+ (UIViewController *)openURL:(NSString *)URL withObject:(id)object;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param userInfo                     参数字典
 */
+ (UIViewController *)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo;

/**
 *  打开一个新页面
 *
 *  @param URL                          URL
 *  @param object                       参数对象
 *  @param userInfo                     参数字典
 */
+ (UIViewController *)openURL:(NSString *)URL withObject:(id _Nullable)object userInfo:(NSDictionary * _Nullable)userInfo completion:(void (^ __nullable)(void))completion;

/**
 *  提取参数
 *
 *  @param URL                          URLPattern
 *  @return                             对象
 */
+ (id)extractParam:(NSString *)URL;

@end

NS_ASSUME_NONNULL_END
