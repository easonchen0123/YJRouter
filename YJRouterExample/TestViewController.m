//
//  TestViewController.m
//  PhotoAlbum
//
//  Created by chenyijun on 2024/8/28.
//  Copyright © 2024 easonchen. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController () <UIViewControllerAnimatedTransitioning>

// 黑色半透明背景
@property (nonatomic, strong) UIButton *bgBtn;

@end

@implementation TestViewController

- (CGRect)frameOfPresentedViewInContainerView {
    return CGRectMake(0, 200, self.containerView.window.frame.size.width, self.containerView.window.frame.size.height - 200);
}

- (UIButton *) bgBtn {
    if (! _bgBtn) {
        UIButton *tempBGBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tempBGBtn.frame = self.containerView.bounds;
        tempBGBtn.opaque = NO;
        tempBGBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tempBGBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
        tempBGBtn.alpha = 0.0f;
        [tempBGBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _bgBtn = tempBGBtn;
    }
    return _bgBtn;
}


// 实现 UIViewControllerAnimatedTransitioning 协议，处理动画细节处理。第三步的内容。
#pragma mark - UIViewControllerTransitioningDelegate
/*
 * 来告诉控制器，谁是动画主管(UIPresentationController)，因为此类继承了UIPresentationController，就返回了self
 */
- (UIPresentationController* )presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source {
    return self;
}

// 返回的对象控制Presented时的动画 (开始动画的具体细节负责类)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

// 由返回的控制器控制dismissed时的动画 (结束动画的具体细节负责类)
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

#pragma mark - 重写UIPresentationController个别方法
- (instancetype)initWithPresentedViewController:(UIViewController *)presentedViewController presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    
    if (self) {
        // 必须设置 presentedViewController 的 modalPresentationStyle
        // 在自定义动画效果的情况下，苹果强烈建议设置为 UIModalPresentationCustom
        presentedViewController.modalPresentationStyle = UIModalPresentationCustom;
    }
    
    return self;
}

// 呈现过渡即将开始的时候被调用的
// 可以在此方法创建和设置自定义动画所需的view
- (void)presentationTransitionWillBegin {
    [self.containerView addSubview:self.bgBtn];
    // 获取presentingViewController 的转换协调器，应该动画期间的一个类？上下文？之类的，负责动画的一个东西
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    // 动画期间，背景View的动画方式
    self.bgBtn.alpha = 0.f;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.bgBtn.alpha = 0.4f;
    } completion:nil];
}

#pragma mark 点击了背景遮罩view
- (void)dimmingViewTapped:(UITapGestureRecognizer*)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// 在呈现过渡结束时被调用的，并且该方法提供一个布尔变量来判断过渡效果是否完成
- (void)presentationTransitionDidEnd:(BOOL)completed
{
    // 在取消动画的情况下，可能为NO，这种情况下，应该取消视图的引用，防止视图没有释放
    if (!completed) {
        self.bgBtn = nil;
    }
}

// 消失过渡即将开始的时候被调用的
- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.bgBtn.alpha = 0.f;
    } completion:NULL];
}

// 消失过渡完成之后调用，此时应该将视图移除，防止强引用
- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if (completed){
        [self.bgBtn removeFromSuperview];
        self.bgBtn = nil;
    }
}

- (void)containerViewWillLayoutSubviews
{
    [super containerViewWillLayoutSubviews];
    self.bgBtn.frame = self.containerView.bounds;
}


//  This method is invoked whenever the presentedViewController's
//  preferredContentSize property changes.  It is also invoked just before the
//  presentation transition begins (prior to -presentationTransitionWillBegin).
//  建议就这样重写就行，这个应该是控制器内容大小变化时，就会调用这个方法， 比如适配横竖屏幕时，翻转屏幕时
//  可以使用UIContentContainer的方法来调整任何子视图控制器的大小或位置。
- (void)preferredContentSizeDidChangeForChildContentContainer:(id<UIContentContainer>)container
{
    [super preferredContentSizeDidChangeForChildContentContainer:container];
    
    if (container == self.presentedViewController) {
        [self.containerView setNeedsLayout];
    }
}



#pragma mark UIViewControllerAnimatedTransitioning具体动画实现
// 动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return [transitionContext isAnimated] ? 0.55 : 0;
}

// 核心，动画效果的实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 1.获取源控制器、目标控制器、动画容器View
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    __unused UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // 2. 获取源控制器、目标控制器 的View，但是注意二者在开始动画，消失动画，身份是不一样的：
    // 也可以直接通过上面获取控制器获取，比如：toViewController.view
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    [containerView addSubview:toView];  //必须添加到动画容器View上。
    
    // 判断是present 还是 dismiss
    BOOL isPresenting = (fromViewController == self.presentingViewController);
    
    CGFloat screenW = CGRectGetWidth(containerView.bounds);
    CGFloat screenH = CGRectGetHeight(containerView.bounds);
    
    // 左右留35
    // 上下留80
    
    // 屏幕顶部：
    CGFloat x = 35.f;
    CGFloat y = -1 * screenH;
//    CGFloat w = screenW - x * 2;
//    CGFloat h = screenH - 80.f * 2;
    CGFloat w = screenW;
    CGFloat h = screenH / 2;
    CGRect topFrame = CGRectMake(x, y, w, h);
    
    // 屏幕中间：
    CGRect centerFrame = CGRectMake(0, screenH / 2, w, h);
    
    // 屏幕底部
    CGRect bottomFrame = CGRectMake(0, screenH + 10, w, h);  //加10是因为动画果冻效果，会露出屏幕一点
    
    if (isPresenting) {
        toView.frame = bottomFrame;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    // duration： 动画时长
    // delay： 决定了动画在延迟多久之后执行
    // damping：速度衰减比例。取值范围0 ~ 1，值越低震动越强
    // velocity：初始化速度，值越高则物品的速度越快
    // UIViewAnimationOptionCurveEaseInOut 加速，后减速
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7f initialSpringVelocity:0.3f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (isPresenting)
            toView.frame = centerFrame;
        else
            fromView.frame = bottomFrame;
    } completion:^(BOOL finished) {
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}

- (void)animationEnded:(BOOL) transitionCompleted
{
    // 动画结束...
}

#pragma mark - Button Actions
- (void) bgBtnClick:(UIButton *) btn {
//    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    [UIView animateWithDuration:0.2 animations:^{
        [self.presentedViewController.view setFrame:CGRectMake(0, 200, self.containerView.window.frame.size.width, self.containerView.window.frame.size.height - 200)];
        [self.presentedViewController.view setNeedsLayout];
    }];
}

@end
