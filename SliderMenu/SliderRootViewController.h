//
//  SliderRootViewController.h
//  SliderMenu
//
//  Created by Wynter on 15/12/31.
//  Copyright © 2015年 Wynter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderRootViewController : UIViewController
/*!
 *  动画时间  默认时间是0.5s
 */
@property (nonatomic,assign)  NSTimeInterval toggleAnimationDuration;

/*!
 *  后视图宽度 默认宽度是120
 */
@property (nonatomic) CGFloat rearViewRevealWidth;

/*!
 *  是否有反弹效果 默认是开启的
 */
@property (nonatomic,assign) BOOL isBounceBackOnOverdraw;

/*!
 *  左边菜单控制器
 */
@property (nonatomic,strong) UIViewController *leftViewController;

/*!
 *  展示区域控制器
 */
@property (nonatomic,strong) UIViewController *mainViewController;

/*!
 *  左边菜单View
 */
@property (nonatomic,strong) UIView *leftView;

/*!
 *  展示区域View
 */
@property (nonatomic,strong) UIView *mainView;

/*!
 *  是否左边划出
 */
@property (nonatomic,assign) BOOL isShowLeft;

/*!
 *  选择的下标
 */
@property (nonatomic,assign) NSInteger selectIndex;

/*!
 *  添加做菜单和主控制器视图
 *
 *  @param leftVC 左边菜单
 *  @param mainVC 主控制器视图
 */
- (void)addChildViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC;
/*!
 *  显示左边控制器
 */
- (void)showLeftView;

/*!
 *  隐藏左边控制器
 */
- (void)hiddenLeftView;

/*!
 *  关闭抽屉菜单
 */
- (void)closeSlideBar;

@end
