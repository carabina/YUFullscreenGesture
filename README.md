# YUFullscreenGesture

全屏加返回手势
支持 iOS 7.0 以上系统

## 一、支持 cocoPods

```
pod 'YUFullscreenGesture'
```

## 二、方法

#### 1.禁用 navigation controller 的 pop 手势

``` objc
navigationController.yu_fullscreenPopGestureRecognizer.enabled = NO;
```

#### 2.禁用 view controller 的 pop 手势

``` objc
viewController.yu_interactivePopDisabled = YES;
```

#### 3.隐藏导航条

可以不用 `-setNavigationBarHidden:animated:` 来隐藏导航条了，用以下方法代替：

``` objc
- (void)viewDidLoad {
    [super viewDidLoad];
    self.yu_prefersNavigationBarHidden = NO;
}
```

#### 4.带 scrollView 的页面

重写这个方法，当scrollView 的 x 偏移量不大于 0 时，手势生效。
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_YUFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}
```

## 三、例子

#### 1.bar -> bar

![snapshot](https://raw.githubusercontent.com/yuzhidu/YUFullscreenGesture/master/Snapshots/snapshot1.gif)

第一个例子中 **Push a VC with bar**
继承了框架就会拥有这项基本功能

#### 2.bar -> without bar 和 without bar -> bar

![snapshot](https://raw.githubusercontent.com/yuzhidu/YUFullscreenGesture/master/Snapshots/snapshot2.gif)

第二个例子，隐藏了导航条，依然可以完美使用

#### 3.带 scrollWith 

![snapshot](https://raw.githubusercontent.com/yuzhidu/YUFullscreenGesture/master/Snapshots/snapshot3.gif)

scrollView 会响应手势，因此要重写
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
```
在 scrollView 的 x 偏移量不大于零时，使用我们框架的 pop 手势

#### 4.带 scrollView 和 tableView

![snapshot](https://raw.githubusercontent.com/yuzhidu/YUFullscreenGesture/master/Snapshots/snapshot4.gif)

这种情况比较常见，但是跟例子3没有本质区别


