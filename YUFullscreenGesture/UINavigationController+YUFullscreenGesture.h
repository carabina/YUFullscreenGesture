//
//
//  关注微博：裕之都
//  微博地址：http://weibo.com/gou9527
//
//  Github：https://github.com/yuzhidu
//

#import <UIKit/UIKit.h>

/**
 "UINavigation+FDFullscreenPopGesture" extends UINavigationController's swipe-to-pop 
 behavior in iOS 7+ by supporting fullscreen pan gesture. Instead of screen edge, 
 you can now swipe from any place on the screen and the onboard interactive pop transition 
 works seamlessly.
 Adding the implementation file of this category to your target will
 automatically patch UINavigationController with this feature.
 
 "UINavigation+YUFullscreenGesture" 扩展了 "UINavigationController" 的 "swipe-to-pop" 行为，
 支持 "iOS7" 以上系统全屏 "pan" 手势。替代了屏幕边缘，你现在可以在屏幕的任何地方轻扫，在交互板上
 "pop transition" 可以无缝工作。
 添加这个分类文件，会自动将这个功能添加到 UINavigationController 上。
 */

@interface UINavigationController (YUFullscreenGesture)

/**
 The gesture recognizer that actually handles interactive pop.
 
 确定手势识别处理了交互的 "pop"
 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *yu_fullscreenPopGestureRecognizer;

/**
 A view controller is able to control navigation bar's appearance by itself,
 rather than a global way, checking "fd_prefersNavigationBarHidden" property.
 Default to YES, disable it if you don't want so.
 
 一个 "view controller" 可以自己控制 "navigation bar" 的出现，
 而不是用一个全局方法，检查 "yu_prefersNavigationBarHidden" 属性。
 默认是 "YES"，如果你不想用就设置 "NO"。
 */
@property (nonatomic, assign) BOOL yu_viewControllerBasedNavigationBarAppearanceEnabled;

@end


/**
 Allows any view controller to disable interactive pop gesture, which might
 be necessary when the view controller itself handles pan gesture in some cases.
 
 允许任何 "view controller" 禁用 "interactive pop gesture"，在某些情况下，
 "view controller" 可能自己需要处理 "pan gesture"。
 */
@interface UIViewController (YUFullscreenPopGesture)

/**
 Whether the interactive pop gesture is disabled when contained in a navigation stack.
 
 当被包含在导航栈中，"interactive pop gesture" 是否被禁用
 */
@property (nonatomic, assign) BOOL yu_interactivePopDisabled;

/**
 Indicate this view controller prefers its navigation bar hidden or not,
 checked when view controller based navigation bar's appearance is enabled.
 Default to NO, bars are more likely to show.
 
 指示这个 "view controller" 选择它的 "navigation bar" 隐藏或者不隐藏，
 当 "view controller" 基于 "navigation bar's appearance" 是激活的时候检查。
 默认是 "NO"，"bars" 更可能展现。
 */
@property (nonatomic, assign) BOOL yu_prefersNavigationBarHidden;

/**
 Max allowed initial distance to left edge when you begin the interactive pop
 gesture. 0 by default, which means it will ignore this limit.
 
 最大值允许初始距离到左边缘，当你开始 "interactive pop" 手势。
 默认值是0，意味着忽视这个限制。
 */
@property (nonatomic, assign) CGFloat yu_interactivePopMaxAllowedInitialDistanceToLeftEdge;

@end
