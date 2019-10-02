//
//  YJRouter.m
//  YJRouter
//
//  Created by ChenEason on 2016/10/31.
//  Copyright © 2016年 easonchen. All rights reserved.
//

#import "YJRouter.h"

static NSString * const MGJ_ROUTER_WILDCARD_CHARACTER = @"~";
static NSString *specialCharacters = @"/?&.";

NSString *const YJRouterParameterURL = @"YJRouterParameterURL";
NSString *const YJRouterParameterCompletion = @"YJRouterParameterCompletion";
NSString *const YJRouterParameterUserInfo = @"YJRouterParameterUserInfo";
NSString *const YJRouterParameterObject = @"YJRouterParameterObject";

@interface YJRouter ()

@property (nonatomic, strong) NSMutableDictionary *routes;          // url pattern
@property (nonatomic, strong) NSMutableDictionary *classes;         // url:class
@property (nonatomic, strong) NSMutableDictionary *parameters;      // 传递参数

@end

@implementation YJRouter

+ (YJRouter *)sharedInstance {
    static YJRouter *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init]; // or some other init method
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appPrefixName = @"app";
        self.navigationClassName = @"UINavigationController";
    }
    return self;
}

- (NSMutableDictionary *)routes {
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

- (NSMutableDictionary *)classes {
    if (!_classes) {
        _classes = [[NSMutableDictionary alloc] init];
    }
    return _classes;
}

- (NSMutableDictionary *)parameters {
    if (!_parameters) {
        _parameters = [[NSMutableDictionary alloc] init];
    }
    return _parameters;
}

#pragma mark - Private
- (NSArray *)pathComponentsFromURL:(NSString*)URL {
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        //        if ((pathSegments.count == 2 && ((NSString *)pathSegments[1]).length) || pathSegments.count < 2) {
        [pathComponents addObject:MGJ_ROUTER_WILDCARD_CHARACTER];
        //        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

// 获取顶层的NavigationController
+ (UINavigationController *)getCurrentNavigationController {
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    
    // 是否是TabBarViewController
    if ([topVC isKindOfClass:[UITabBarController class]]) {
        // 是否是NavigationController
        UITabBarController *tabBarViewController = (UITabBarController *)topVC;
        UINavigationController *vc = [tabBarViewController.viewControllers objectAtIndex:tabBarViewController.selectedIndex];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            return vc;
        }
    } else if ([topVC isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)topVC;
    }
    
    return nil;
}

+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern {
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSInteger index = 0;
    NSMutableDictionary *subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString *pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    return subRoutes;
}

#pragma mark - Utils
- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[YJRouterParameterURL] = url;
    
    NSMutableDictionary *subRoutes = self.routes;
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    // borrowed from HHRouter(https://github.com/Huohua/HHRouter)
    for (NSString *pathComponent in pathComponents) {
        BOOL found = NO;
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys = [subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString *key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:MGJ_ROUTER_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                NSString *newKey = [key substringFromIndex:1];
                NSString *newPathComponent = pathComponent;
                // 再做一下特殊处理，比如 :id.html -> :id
                if ([self.class checkIfContainsSpecialCharacter:key]) {
                    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
                    NSRange range = [key rangeOfCharacterFromSet:specialCharacterSet];
                    if (range.location != NSNotFound) {
                        // 把 pathComponent 后面的部分也去掉
                        newKey = [newKey substringToIndex:range.location - 1];
                        NSString *suffixToStrip = [key substringFromIndex:range.location];
                        newPathComponent = [newPathComponent stringByReplacingOccurrencesOfString:suffixToStrip withString:@""];
                    }
                }
                parameters[newKey] = newPathComponent;
                break;
            }
        }
        // 如果没有找到该 pathComponent 对应的 handler，则以上一层的 handler 作为 fallback
        if (!found && !subRoutes[@"_"]) {
            return nil;
        }
    }
    
    // Extract Params From Query.
    NSArray *pathInfo = [url componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        NSString *parametersString = [pathInfo objectAtIndex:1];
        NSArray *paramStringArr = [parametersString componentsSeparatedByString:@"&"];
        for (NSString *paramString in paramStringArr) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                parameters[key] = value;
            }
        }
    }
    
    if (subRoutes[@"_"]) {
        parameters[@"block"] = [subRoutes[@"_"] copy];
    }
    
    return parameters;
}

+ (BOOL)checkIfContainsSpecialCharacter:(NSString *)checkedString {
    NSCharacterSet *specialCharactersSet = [NSCharacterSet characterSetWithCharactersInString:specialCharacters];
    return [checkedString rangeOfCharacterFromSet:specialCharactersSet].location != NSNotFound;
}

- (NSString *)getViewControllerKeyFromURL:(NSString *)URL {
    NSArray *components = [URL pathComponents];
    NSString *key = [components objectAtIndex:1];
    return key;
}

+ (void)registerURLPatternWithArray:(NSArray *)array {
    for (NSDictionary *dic in array) {
        NSString *pattern = [dic objectForKey:@"url_pattern"];
        NSString *controller = [dic objectForKey:@"controller"];
        
        [YJRouter registerURLPattern:pattern forClass:controller];
    }
}

+ (void)registerURLPattern:(NSString *)URLPattern forClass:(NSString *)className {
    YJRouter *router = [self sharedInstance];
    [router addURLPattern:URLPattern];
    
    NSString *key = [router getViewControllerKeyFromURL:URLPattern];
    [router.classes setObject:className forKey:key];
}

#pragma mark - Public OpenURL
+ (void)openURL:(NSString *)URL {
    return [self openURL:URL withObject:nil userInfo:nil];
}

+ (void)openURL:(NSString *)URL withObject:(id)object {
    return [self openURL:URL withObject:object userInfo:nil];
}

+ (void)openURL:(NSString *)URL withUserInfo:(NSDictionary *)userInfo {
    return [self openURL:URL withObject:nil userInfo:userInfo];
}

+ (void)openURL:(NSString *)URL withObject:(id)object userInfo:(NSDictionary *)userInfo {
    if (URL == nil) return;
    
    YJRouter *router = [self sharedInstance];
    
    // 处理解析URL
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *pathComponents = [router pathComponentsFromURL:URL];
    
    if (pathComponents.count <= 2) return;
    
    // 若不是app本身的URL
    if (![pathComponents[0] isEqualToString:router.appPrefixName]) {
        NSURL *url = [NSURL URLWithString:URL];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            return;
        }
    }
    
    // 获取对应的controller
    NSString *key = [pathComponents objectAtIndex:2];
    NSString *className = [router.classes objectForKey:key];
    id class = NSClassFromString(className);
    if (class == nil) {
        return;
    }
    
    // 查找NavigationController
    UINavigationController *navigationController = [self getCurrentNavigationController];
    if (!navigationController && router.getNavigationControllerBlock) {
        navigationController = router.getNavigationControllerBlock();
    }
    if (navigationController == nil) {
        return;
    }
    
    // 创建ViewController
    UIViewController *vc = [[class alloc] init];
    
    // 解析URL参数
    NSDictionary *parameters = [router extractParametersFromURL:URL];
    if (parameters) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        if (object) {
            dic[YJRouterParameterObject] = object;
        }
        if (userInfo) {
            dic[YJRouterParameterUserInfo] = userInfo;
        }
        [router.parameters setObject:dic forKey:key];
    }
    
    NSString *showtype = parameters[@"showtype"];
    NSString *modeltype = parameters[@"modeltype"];
    if (showtype && [showtype isEqualToString:@"present"]) {
        id class2 = NSClassFromString([YJRouter sharedInstance].navigationClassName);
        UIViewController *nav = [[class2 alloc] initWithRootViewController:vc];
        
        if (modeltype && [modeltype isEqualToString:@"pagesheet"]) {
            nav.modalPresentationStyle = UIModalPresentationPageSheet;
        } else {
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        
        if ([YJRouter sharedInstance].rootViewController) {
            [[YJRouter sharedInstance].rootViewController presentViewController:nav animated:YES completion:nil];
        }
    } else {
        [navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Public ExtractParam
+ (id)extractParam:(NSString *)key {
    YJRouter *router = [self sharedInstance];
    
    NSDictionary *dic = [router.parameters objectForKey:key];
    [router.parameters removeObjectForKey:key];
    return dic;
}

@end
