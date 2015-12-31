//
//  SliderRootViewController.m
//  SliderMenu
//
//  Created by Wynter on 15/12/31.
//  Copyright © 2015年 Wynter. All rights reserved.
//

#import "SliderRootViewController.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define HIDDENLEFTVIEW   @"hiddenLeftView"
@interface SliderRootViewController ()<UIGestureRecognizerDelegate>{
    
    UIPanGestureRecognizer *_panGestureRec;
    
    UITapGestureRecognizer *_tapGestureRec;
    
    UIScreenEdgePanGestureRecognizer *_edgePanGestureRec;
}

@end

@implementation SliderRootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenLeftView) name:HIDDENLEFTVIEW object:nil];
    
}

#pragma mark 重写初始化方法
- (id)init{
    
    if (self = [super init]) {
        
        _isBounceBackOnOverdraw = YES;
        _rearViewRevealWidth = 120;
        _toggleAnimationDuration = 0.4;
        
        [self addSubView];
        
        [self addGestureRec];
        
    }
    return self;
}

#pragma make 添加View
- (void)addSubView
{
    _leftView = [[UIView alloc]initWithFrame:CGRectMake(-SCREEN_WIDTH, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    [self.view addSubview:_leftView];
    
    _mainView = [[UIView alloc]initWithFrame:SCREEN_BOUNDS];
    [self.view addSubview:_mainView];
    [self.view bringSubviewToFront:_leftView];
}

#pragma mark 添加操作手势
- (void)addGestureRec
{
    
    _edgePanGestureRec = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(moveViewWithGesture:)];
    _edgePanGestureRec.edges = UIRectEdgeLeft;
    _edgePanGestureRec.delegate = self;
    [_mainView addGestureRecognizer:_edgePanGestureRec];
    
    _tapGestureRec = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeSlideBar)];
    _tapGestureRec.delegate = self;
    _tapGestureRec.enabled = NO;
    [_mainView addGestureRecognizer:_tapGestureRec];
    
    _panGestureRec = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveViewWithGesture:)];
    _panGestureRec.enabled = NO;
    _panGestureRec.delegate = self;
    [_mainView addGestureRecognizer:_panGestureRec];
    [self.view addGestureRecognizer:_panGestureRec];
}
#pragma mark 添加控制器
- (void)addChildViewController:(UIViewController *)leftVC mainViewController:(UIViewController *)mainVC
{
    
    if (leftVC) {
        _leftViewController = leftVC;
        [self addChildViewController:leftVC];
        leftVC.view.frame = CGRectMake( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [_leftView addSubview:leftVC.view];
    }
    
    if (mainVC) {
        _mainViewController = mainVC;
        [self addChildViewController:mainVC];
        mainVC.view.frame = _mainView.frame;
        [_mainView addSubview:mainVC.view];
    }
    
}


#pragma mark 滑动手势
- (void)moveViewWithGesture:(UIGestureRecognizer *)panGestureRec{
    
    static CGFloat startX;
    static CGFloat lastX;
    static CGFloat durationX;
    CGPoint touchPoint = [panGestureRec locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (panGestureRec.state == UIGestureRecognizerStateBegan)
    {
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }
    
    if (panGestureRec.state == UIGestureRecognizerStateChanged)
    {
        CGFloat currentX = touchPoint.x;
        durationX = currentX - lastX;
        lastX = currentX;
        
        if (durationX > 0)
        {
            if(!_isShowLeft)
            {
                _isShowLeft = YES;
                [self.view bringSubviewToFront:_leftView];
            }
        }
        
        if (_isShowLeft)
        {
            if (_leftView.frame.origin.x >= -_rearViewRevealWidth && durationX > 0)
            {
                return;
            }
            
            float x = durationX + _leftView.frame.origin.x;
            [_leftView setFrame:CGRectMake(x, _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height)];
        }
        else    //transX < 0
        {
            
            if (_leftView.frame.origin.x >= -_rearViewRevealWidth && durationX > 0)
            {
                return;
            }
            
            float x = durationX + _leftView.frame.origin.x;
            [_leftView setFrame:CGRectMake(x, _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height)];
        }
        
    }
    else if (panGestureRec.state == UIGestureRecognizerStateEnded)
    {
        if (_isShowLeft)
        {
            if (_leftView==nil)
            {
                return;
            }
            
            if ((_leftView.frame.origin.x + _leftView.frame.size.width) > (_leftView.frame.size.width - _rearViewRevealWidth)/2)
            {
                [self showLeftView];
                
            }else
            {
                [self hiddenLeftView];
            }
            
            return;
        }
        
    }
}

#pragma mark 显示左边菜单
- (void)showLeftView{
    
    if (_isBounceBackOnOverdraw)
    {
        [UIView animateWithDuration:_toggleAnimationDuration delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
            [_mainView setAlpha:0.5];
            [_leftView setFrame:CGRectMake(-_rearViewRevealWidth, _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height)];
        } completion:^(BOOL finished){
            _tapGestureRec.enabled = YES;
        }];
    }
    else
    {
        [UIView animateWithDuration:_toggleAnimationDuration animations:^{
            [_mainView setAlpha:0.5];
            [_leftView setFrame:CGRectMake(-_rearViewRevealWidth, _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height)];
        }completion:^(BOOL finished){
            _tapGestureRec.enabled = YES;
        }];
    }
    
    _edgePanGestureRec.enabled = NO;
    _panGestureRec.enabled = YES;
    
}

#pragma mark 隐藏左边菜单
- (void)hiddenLeftView{
    
    
    if (_isBounceBackOnOverdraw)
    {
        [UIView animateWithDuration:_toggleAnimationDuration delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:1 options:UIViewAnimationOptionTransitionNone animations:^{
            [_mainView setAlpha:1];
            [_leftView setFrame:CGRectMake(-_leftView.frame.size.width, _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height)];
        } completion:^(BOOL finished){
            [self.view sendSubviewToBack:_leftView];
            _isShowLeft = NO;
            _tapGestureRec.enabled = NO;
            [_mainView setAlpha:1];
        }];
    }
    else
    {
        [UIView animateWithDuration:_toggleAnimationDuration animations:^{
            [_mainView setAlpha:1];
            [_leftView setFrame:CGRectMake(-_leftView.frame.size.width, _leftView.frame.origin.y, _leftView.frame.size.width, _leftView.frame.size.height)];
        }completion:^(BOOL finished){
            [self.view sendSubviewToBack:_leftView];
            _isShowLeft = NO;
            _tapGestureRec.enabled = NO;
            [_mainView setAlpha:1];
        }];
    }
    _edgePanGestureRec.enabled = YES;
    _panGestureRec.enabled = NO;
}

#pragma mark 关闭抽屉菜单
- (void)closeSlideBar{
    
    if (_isShowLeft)
    {
        [self hiddenLeftView];
    }
    
}

#pragma mark RecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
@end

