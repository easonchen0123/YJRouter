# YJRouter

## <a id="How to use YJRouter"></a>How to use YJRouter
* Installation with CocoaPods：`pod 'YJRouter'`

## <a id="AppDelegate.m"></a>AppDelegate.m
```objc
[YJRouter sharedInstance].navigationClassName = @"UINavigationController";					// 或者你自己的UINavigationController的子类
[YJRouter sharedInstance].appPrefixName = @"app";											// 默认为‘app’
[YJRouter registerURLPattern:@"app://first" forClass:@"FirstViewController"];           	// 将FirstViewController注册为first，对应URL则为app://first
[YJRouter registerURLPattern:@"app://second/:id/:name" forClass:@"FirstViewController"];	// 将SecondViewController注册为second，对应URL则为app://
[YJRouter registerURLPatternWithArray:array];                                               // 可以由一个配置文件生成一个数组，数组中的元素为字典，key为controller和url_pattern
second
```

## <a id="需要打开新页面的地方"></a>需要打开新页面的地方

```objc
[YJRouter openURL:@"app://first"];															// 将以push的方式打开FirstViewController
[YJRouter openURL:@"app://first?showtype=present" withObject:@[@"1", @"2"]];                // 将以modal的方式打开FirstViewController, 并传递一个数组对象
[YJRouter openURL:@"app://second/12/yjrouter?desc=description"];							// 打开SecondViewController,同时传递id,name,desc三个参数
```


## <a id="获取传递过来的参数"></a>获取传递过来的参数

```objc
- (void)viewDidLoad {
	[super viewDidLoad];

	NSDictionary *dic = [YJRouter extractParam:@"first"];
    if (dic != nil) {
        NSString *ID = [dic objectForKey:@"id"];
        NSString *name = [dic objectForKey:@"name"];
        NSString *desc = [dic objectForKey:@"desc"];

        if (dic[YJRouterParameterObject] != nil) {
            NSArray *array = dic[YJRouterParameterObject];
        }
    }
}
```