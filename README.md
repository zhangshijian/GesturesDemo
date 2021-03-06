# 手势识别以及手势冲突处理

## 概述

手势识别器是处理视图中的触摸或者按压事件最简单的方法，我们可以在任意视图上附加一个或多个手势识别器。手势识别器封装了处理和解释该视图的触摸事件所需的所有逻辑，并将其与已知模式进行匹配。当触摸事件与已知模式匹配时，手势识别器会通知其关联的目标对象进行处理。手势识别器使用`target-action`设计模式去发送通知，如下图所示。当`UITapGestureRecognizer`对象在视图中检测到单指轻敲时，会调用视图所属的视图控制器的操作方法来回应。

![图1-1 手势识别器通知其关联到目标对象](https://docs-assets.developer.apple.com/published/7c21d852b9/0c8c5e29-c846-4a16-988b-3d809eafbb6b.png)

手势识别器有两种类型：离散型和连续型。当识别出手势后，**离散型手势识别器**只会调用一次其关联目标对象的操作方法。**连续型手势识别器**则可能会多次调用其关联目标对象的操作方法，包括手势的开始和结束以及跟踪手势细节的变化。例如，使用拖拽手势识别器时，只要触摸事件的位置发生变化，`UIPanGestureRecognizer`对象就会调用其关联对象的操作方法。

## 配置手势识别器

配置手势识别器分为以下三步：

- 使用代码创建一个手势识别器对象，并将其附加到视图上。或者，使用`storyboard`，直接将手势识别器拖动到视图上。
- 实现识别手势后目标对象要调用的操作方法。
- 调用手势识别器对象的`addTarget:action:`方法将目标对象和目标对象要调用的操作方法与手势识别器关联起来。或者，使用`storyboard`，右键单击手势识别器将其**Sent Action selector**连接到目标对象来创建关联操作方法。

## 回应手势

与手势识别器关联的操作方法为应用程序提供了对该手势的响应。对于离散型手势，其关联的操作方法与按钮的操作方法类似。只有手势识别成功后，才会调用其关联对象的操作方法作出响应。对于连续型手势，其关联的操作方法不仅可以对手势识别成功后作出响应，还可以在识别手势之前跟踪手势细节的变化。

手势识别器的`state`属性可以反映当前的手势识别状态。对于连续型手势，手势识别器会在手势识别过程中将此属性值从`UIGestureRecognizerStateBegan`变更为`UIGestureRecognizerStateChanged`，手势被识别后变更为`UIGestureRecognizerStateEnded`。

### 点击手势

点击手势识别器`UITapGestureRecognizer`对象会简要地检测一个或多个手指点击屏幕。**在点击手势被识别成功前**，涉及手势的手指不能从初始触摸点**显著移动**到其他地方，但可以配置手指必须触摸屏幕的次数。例如，可以配置点击手势识别器来检测单击，双击或者三击。

![图3-1 Tap gestures](https://docs-assets.developer.apple.com/published/7c21d852b9/14d1769c-c081-4c4a-9466-e5dca8a2e053.png)

点击手势属于离散型手势，只有当点击手势识别成功后才会调用其关联对象的操作方法。由于手势可以被取消的原因有很多，所以在操作方法中回应手势前，检查`state`属性可以确保不会出错。

如果触摸屏幕后没有调用与手势识别器关联的对象的操作方法，请检查下列条件是否成立：

- 视图的`userInteractionEnabled`属性设置为`YES`。`UIImageView`和`UILabel`类默认将此属性设为`NO`。
- 点击次数等于`numberOfTapsRequired`属性中指定的次数。
- 手指个数等于`numberOfTouchesRequired`属性中指定的个数。

### 长按手势

长按手势识别器`UILongPressGestureRecognizer`对象检测一个或者多个手指长时间触摸屏幕。**在长按手势被识别成功前**，涉及手势的手指不能从初始触摸点**显著移动**到其他地方，但可以配置手指必须触摸屏幕的次数以及长按手势的最短持续时间。手势识别器仅由触摸的持续时间而不是与其相关的力触发。

![图3-2 Long-press gesture](https://docs-assets.developer.apple.com/published/7c21d852b9/c57fc4b9-4419-4ef9-9067-d27f474504af.png)

长按手势根据触摸的持续时间来确定手势的成功或者失败，它属于连续型手势，手势关联对象的操作方法可能会随着手势状态的变化而被多次调用。长按手势识别器在用户手指停留在屏幕上一定时间后(用户手指仍旧停留在屏幕上)进入`UIGestureRecognizerStateBegan`状态，当触摸事件更新时，进入`UIGestureRecognizerStateChanged`状态，用户手指离开屏幕时，进入`UIGestureRecognizerStateEnded`状态。

如果触摸屏幕后没有调用与手势识别器关联的对象的操作方法，请检查下列条件是否成立：

- 视图的`userInteractionEnabled`属性设置为`YES`。`UIImageView`和`UILabel`类默认将此属性设为`NO`。
- 点击次数等于`numberOfTapsRequired`属性中指定的次数。
- 手指个数等于`numberOfTouchesRequired`属性中指定的个数。
- 触摸持续时间大于`minimumPressDuration`属性中指定的时间。

### 拖拽手势

拖拽手势识别器`UIPanGestureRecognizer`对象检测一个或者多个手指在屏幕上移动。屏幕边缘拖拽手势是限定触摸位置在屏幕边缘的拖拽手势，使用`UIScreenEdgePanGestureRecognizer`对象来识别屏幕边缘拖拽手势。

![图3-3 Pan gesture](https://docs-assets.developer.apple.com/published/7c21d852b9/92edf0c4-8d94-469b-b81d-c00a20e74f5e.png)

拖拽手势属于连续型手势，在手势识别过程中，会多次调用手势关联对象的操作方法。当手指开始移动时，拖拽手势识别器进入`UIGestureRecognizerStateBegan`状态，继续移动会导致手势识别器进入`UIGestureRecognizerStateChanged`状态。当手指离开屏幕时，进入`UIGestureRecognizerStateEnded`状态。

使用`UIPanGestureRecognizer`对象的`translationInView:`方法可以获取手指从初始触摸位置移动的距离。在手势开始时，拖拽手势识别器会存储初始触摸点。如果手势涉及多个手指，则手势识别器会使用多个手指的触摸点的中心点。

如果触摸屏幕后没有调用与手势识别器关联的对象的操作方法，请检查下列条件是否成立：

- 视图的`userInteractionEnabled`属性设置为`YES`。`UIImageView`和`UILabel`类默认将此属性设为`NO`。
- 触摸次数在`minimumNumberOfTouches`和`maximumNumberOfTouches`属性中指定的值之间。
- 如果是屏幕边缘拖拽手势，应确保触摸位置在`edges`属性中指定的区域中。

### 轻扫手势

轻扫手势识别器`UISwipeGestureRecognizer`对象检测屏幕上一个或多个手指在特定的水平或垂直方向上移动。轻扫手势的方向和手指的数量是可以配置的，其属于离散型手势，只有在手势被成功识别后才会调用手势关联对象的操作方法。当我们只关注手势的结果而不关注手指的移动时，轻扫手势是最合适的。

![图3-4 Swipe gesture](https://docs-assets.developer.apple.com/published/7c21d852b9/7fa694cb-f654-4f71-a653-ea908b5bb27c.png)

如果触摸屏幕后没有调用与手势识别器关联的对象的操作方法，请检查下列条件是否成立：

- 视图的`userInteractionEnabled`属性设置为`YES`。`UIImageView`和`UILabel`类默认将此属性设为`NO`。
- 触摸次数等于`numberOfTouchesRequired`属性中指定的值之间。
- 滑动的方向与`direction`属性值相匹配。

### 捏合手势

捏合手势属于连续型手势，其跟踪最先触摸屏幕的两根手指之间的距离，使用`UIPinchGestureRecognizer`对象来检测捏合手势。

![图3-5 Pinch gestures](https://docs-assets.developer.apple.com/published/7c21d852b9/46733a3e-1a59-4ca3-acb3-dc14958374a7.png)

当两个手指间的距离开始改变时，会更新捏合手势识别器对象的手指间当前距离与初始距离的比例`scale`属性值，然后调用手势关联目标对象的操作方法。捏合手势常用于更改屏幕上的对象或者内容的大小。**在缩放内容大小时，应该取`scale`值和内容初始大小的积。**

如果触摸屏幕后没有调用与手势识别器关联的对象的操作方法，请检查下列条件是否成立：

- 视图的`userInteractionEnabled`属性设置为`YES`。`UIImageView`和`UILabel`类默认将此属性设为`NO`。
- 至少两根手指同时触摸屏幕。
- 正在使用`scale`值缩放内容大小。

### 旋转手势

旋转手势属于连续型手势，其跟踪触摸屏幕的两根手指旋转的角度，使用`UIRotationGestureRecognizer`对象来检测旋转手势。

![图3-6 Rotation gesture](https://docs-assets.developer.apple.com/published/7c21d852b9/0d8b92d2-dbfc-4316-97fd-aa2f6ee22db3.png)

当手指开始在屏幕上旋转时，会更新旋转手势识别器对象的从初始到现在已旋转角度`rotation`属性值，然后调用手势关联目标对象的操作方法。可以使用旋转手势来旋转视图或者更新自定义控件的值。

如果触摸屏幕后没有调用与手势识别器关联的对象的操作方法，请检查下列条件是否成立：

- 视图的`userInteractionEnabled`属性设置为`YES`。`UIImageView`和`UILabel`类默认将此属性设为`NO`。
- 至少两根手指同时触摸屏幕。
- 正在使用`rotation`旋转内容。

## 处理手势冲突

在视图上附加多个手势识别器时，多个手势识别器会同时跟踪传入的触摸事件。但**默认**情况下UIKit只允许在单个视图中一次只识别一个手势，也就是说当某个手势识别器成功识别手势后，其他手势识别器就不会再继续去识别该手势。一次只识别一个手势可以防止用户一次触发多个动作，但这种**默认**识别行为可能会导致意想不到的副作用。例如，在包含拖拽和轻扫手势识别器的视图中，轻扫手势永远不会被识别。这是因为拖拽手势是连续的，所以它总是在轻扫手势之前被识别。

UIKit通过调用手势识别器的委托对象的代理方法来确定一个手势是否必须在其他手势之前或之后被识别，或者两个手势是否可以被同时识别。对于涉及潜在冲突的两个手势识别器，只需要其中一个手势识别器去关联委托对象，该委托对象需要遵循`UIGestureRecognizerDelegate`协议。

### 确定在视图中识别手势的顺序

当视图上附加有单击和双击手势时，单击手势会始终在双击手势之前被识别，但是可以通过实现单击手势委托对象的`gestureRecognizer:shouldRequireFailureOfGestureRecognizer:`方法去延后单击手势的识别直到双击手势被识别失败，代码如下：
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.singleTap && otherGestureRecognizer == self.doubleTap)
    {
        return YES;
    }
    return NO;
}
```

当视图上附加有轻扫和拖拽手势时，拖拽手势会始终在轻扫手势之前被识别。在这种情况下，可以通过实现轻扫手势委托对象的`gestureRecognizer:shouldBeRequiredToFailByGestureRecognizer:`方法实现在识别轻扫手势失败后才识别拖拽手势，代码如下：
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.swip && otherGestureRecognizer == self.pan)
    {
        return YES;
    }
    return NO;
}
```
也可以通过实现拖拽手势委托对象的`gestureRecognizer:shouldRequireFailureOfGestureRecognizer:`方法去延后拖拽手势的识别直到轻扫手势被识别失败，代码如下：
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.pan && otherGestureRecognizer == self.swip)
    {
        return YES;
    }
    return NO;
}
```

### 允许同时识别多个手势

在默认情况下，UIkit在单个视图中一次只允许识别一个手势，但如果有需要，也可以在单个视图中同时识别多个手势。要允许在单个视图中同时识别多个手势，需要手势委托对象实现`gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:`方法。UIKit会调用此方法来判断是否允许同时识别两个手势，默认返回`NO`。

当一个视图上同时附加有拖拽、 缩放和旋转手势时，允许用户在屏幕上可以同时拖动、 缩放和旋转视图，代码如下：
```
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 允许同时识别在同一视图上的特定手势
    if (gestureRecognizer.view == self.targetView && otherGestureRecognizer.view == self.targetView)
    {
        // 排除长按手势
        if (![gestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]] && ![otherGestureRecognizer isMemberOfClass:[UILongPressGestureRecognizer class]])
        {
            return YES;
        }
    }
    return NO;
}
```

**要同时识别多个手势，它们的委托对象都要实现`gestureRecognizer:shouldRecognizeSimultaneouslyWithGestureRecognizer:`方法，如果只有其中一个手势的委托对象实现了，但其它手势的委托对象没有实现，那么UIKit也不会同时识别它们。**

## 自定义手势识别器

当UIKit定义的手势类型不能满足我们需求时，我们也可以自定义手势识别器来处理特定的触摸事件。自定义手势识别器的详情可以参看[Implementing a Custom Gesture Recognizer](https://developer.apple.com/documentation/uikit/touches_presses_and_gestures/implementing_a_custom_gesture_recognizer)

## Demo

示例代码下载地址：https://github.com/zhangshijian/GesturesDemo.git
