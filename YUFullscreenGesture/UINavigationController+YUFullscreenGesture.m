//
//  UINavigationController+YUFullscreenGesture.m
//  YUFullscreenGestureDemo
//
//  Created by 马裕博 on 2017/3/13.
//  Copyright © 2017年 马裕博. All rights reserved.
//

#import "UINavigationController+YUFullscreenGesture.h"
#import <objc/runtime.h>

@interface _YUFullscreenPopGestureRecognizerDelegate : NSObject <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@end

@implementation _YUFullscreenPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    // Ignore when no view controller is pushed into the navigation stack.
    // -- 忽略 没有 "view controller" 被推入 "navigation" 栈中时的情况
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // Ignore when the active view controller doesn't allow interactive pop.
    // -- 忽略 活跃的 "view controller" 不允许 "interactive pop" 的情况
    UIViewController *topViewController = self.navigationController.viewControllers.lastObject;
    if (topViewController.yu_interactivePopDisabled) {
        return NO;
    }
    
    // Ignore when the beginning location is beyond max allowed initial distance to left edge.
    // -- 忽略 开始位置超过初始距离到左边缘的最大值 的情况
    CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
    CGFloat maxAllowedInitialDistance = topViewController.yu_interactivePopMaxAllowedInitialDistanceToLeftEdge;
    if (maxAllowedInitialDistance > 0 && beginningLocation.x > maxAllowedInitialDistance) {
        return NO;
    }
    
    // Ignore pan gesture when the navigation controller is currently in transition.
    // -- 忽略 "pan gesture" 当 "navigation controller" 目前在转变 的情况
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // Prevent calling the handler when the gesture begins in an opposite direction.
    // 当手势在相反的方向开始，防止调用处理程序
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return YES;
}

@end


typedef void (^_YUViewControllerWillAppearInjectBlock)(UIViewController *viewController, BOOL animated);

@interface UIViewController (YUFullscreenPopGesturePrivate)

@property (nonatomic, copy) _YUViewControllerWillAppearInjectBlock yu_willAppearInjectBlock;

@end

@implementation UIViewController (YUFullscreenPopGesturePrivate)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(yu_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)yu_viewWillAppear:(BOOL)animated
{
    // Forward to primary implementation.
    // 前往主要的实现
    [self yu_viewWillAppear:animated];
    
    if (self.yu_willAppearInjectBlock) {
        self.yu_willAppearInjectBlock(self, animated);
    }
}

- (_YUViewControllerWillAppearInjectBlock)yu_willAppearInjectBlock
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setYu_willAppearInjectBlock:(_YUViewControllerWillAppearInjectBlock)block
{
    objc_setAssociatedObject(self, @selector(yu_willAppearInjectBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end

@implementation UINavigationController (YUFullscreenGesture)

+ (void)load
{
    // Inject "-pushViewController:animated:"
    // 注入 "-pushViewController:animated:"
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(pushViewController:animated:);
        SEL swizzledSelector = @selector(yu_pushViewController:animated:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)yu_pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.yu_fullscreenPopGestureRecognizer]) {
        
        // Add our own gesture recognizer to where the onboard screen edge pan gesture recognizer is attached to.
        // 添加我们的手势识别到屏幕板的边缘附加的 "pan" 手势识别上
        [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.yu_fullscreenPopGestureRecognizer];
        
        // Forward the gesture events to the private handler of the onboard gesture recognizer.
        // 指向手势事件的板上手势识别的私有处理者
        NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
        id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
        SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
        self.yu_fullscreenPopGestureRecognizer.delegate = self.yu_popGestureRecognizerDelegate;
        [self.yu_fullscreenPopGestureRecognizer addTarget:internalTarget action:internalAction];
        
        // Disable the onboard gesture recognizer.
        // 禁用板上的手势识别
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    // Handle perferred navigation bar appearance.
    // 处理选择的 "navigation bar appearance"
    [self yu_setupViewControllerBasedNavigationBarAppearanceIfNeeded:viewController];
    
    // Forward to primary implementation.
    // 前往主要的实现
    if (![self.viewControllers containsObject:viewController]) {
        [self yu_pushViewController:viewController animated:animated];
    }
}

- (void)yu_setupViewControllerBasedNavigationBarAppearanceIfNeeded:(UIViewController *)appearingViewController
{
    if (!self.yu_viewControllerBasedNavigationBarAppearanceEnabled) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    _YUViewControllerWillAppearInjectBlock block = ^(UIViewController *viewController, BOOL animated) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf setNavigationBarHidden:viewController.yu_prefersNavigationBarHidden animated:animated];
        }
    };
    
    // Setup will appear inject block to appearing view controller.
    // Setup disappearing view controller as well, because not every view controller is added into
    // stack by pushing, maybe by "-setViewControllers:".
    
    // 生成 "will appear" 注入 "block" 用于展现 "view controller"。
    // 同时生成 消失 "disappearing"，因为不是每个 "view controller" 是通过 "pushing" 进入栈中的，
    // 也许是通过 "-setViewControllers:"
    appearingViewController.yu_willAppearInjectBlock = block;
    UIViewController *disappearingViewController = self.viewControllers.lastObject;
    if (disappearingViewController && !disappearingViewController.yu_willAppearInjectBlock) {
        disappearingViewController.yu_willAppearInjectBlock = block;
    }
}

- (_YUFullscreenPopGestureRecognizerDelegate *)yu_popGestureRecognizerDelegate
{
    _YUFullscreenPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    
    if (!delegate) {
        delegate = [[_YUFullscreenPopGestureRecognizerDelegate alloc] init];
        delegate.navigationController = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIPanGestureRecognizer *)yu_fullscreenPopGestureRecognizer
{
    UIPanGestureRecognizer *panGestureRecognizer = objc_getAssociatedObject(self, _cmd);
    
    if (!panGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] init];
        panGestureRecognizer.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGestureRecognizer;
}

- (BOOL)yu_viewControllerBasedNavigationBarAppearanceEnabled
{
    NSNumber *number = objc_getAssociatedObject(self, _cmd);
    if (number) {
        return number.boolValue;
    }
    self.yu_viewControllerBasedNavigationBarAppearanceEnabled = YES;
    return YES;
}

- (void)setYu_viewControllerBasedNavigationBarAppearanceEnabled:(BOOL)enabled
{
    SEL key = @selector(yu_viewControllerBasedNavigationBarAppearanceEnabled);
    objc_setAssociatedObject(self, key, @(enabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIViewController (YUFullscreenPopGesture)

- (BOOL)yu_interactivePopDisabled
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYu_interactivePopDisabled:(BOOL)disabled
{
    objc_setAssociatedObject(self, @selector(yu_interactivePopDisabled), @(disabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)yu_prefersNavigationBarHidden
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setYu_prefersNavigationBarHidden:(BOOL)hidden
{
    objc_setAssociatedObject(self, @selector(yu_prefersNavigationBarHidden), @(hidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)yu_interactivePopMaxAllowedInitialDistanceToLeftEdge
{
#if CGFLOAT_IS_DOUBLE
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
#else
    return [objc_getAssociatedObject(self, _cmd) floatValue];
#endif
}

- (void)setYu_interactivePopMaxAllowedInitialDistanceToLeftEdge:(CGFloat)distance
{
    SEL key = @selector(yu_interactivePopMaxAllowedInitialDistanceToLeftEdge);
    objc_setAssociatedObject(self, key, @(MAX(0, distance)), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

