//
//  YJRouter.h
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

// V 0.1.0          2016.10.31          by ChenYijun
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




#import <Foundation/Foundation.h>

@interface YJRouter : NSObject

+ (YJRouter *)sharedInstance;

@property (nonatomic, strong) NSString *appPrefixName;
@property (nonatomic, strong) NSString *navigationClassName;
@property (nonatomic, assign) UIViewController *rootViewController;   // present的rootViewController

+ (void)registerURLPatternWithArray:(NSArray *)array;
+ (void)registerURLPattern:(NSString *)URLPattern forClass:(NSString *)className;

+ (void)openURL:(NSString *)URL;
+ (void)openURL:(NSString *)URL withObject:(id)object;
+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo;
+ (void)openURL:(NSString *)URL withObject:(id)object userInfo:(NSDictionary *)userInfo;

+ (id)extractParam:(NSString *)URL;

@end
