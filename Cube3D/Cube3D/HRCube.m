//
//  HRCube.m
//  Cube3D
//
//  Created by Rannie on 13-12-15.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "HRCube.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>

#define kBlackColor [UIColor blackColor].CGColor
#define kGrayColor [UIColor grayColor].CGColor

@interface HRCube ()
{
    CALayer             *_cubeLayer;            //main layer
    GLKMatrix4          _rotMatrix;
}

@property (nonatomic, assign, readwrite) CGFloat side;

@end

@implementation HRCube

+ (HRCube *)cube3DWithFrame:(CGRect)frame side:(CGFloat)side autoAnimate:(BOOL)animate
{
    HRCube *cube3D = [[HRCube alloc] initWithFrame:frame];
    cube3D.side = side;
    cube3D.autoAnimate = animate;
    
    return cube3D;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cubeLayer = [CALayer layer];
        _cubeLayer.frame = self.bounds;
        _cubeLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)setSide:(CGFloat)side
{
    _side = side;
    
//    NSLog(@"%@", NSStringFromCGRect(_cubeLayer.bounds));
    
    //正
    [self addCubeLayer:@[@0, @0, @(_side/2), @0, @0, @0, @0]];
    //背
    [self addCubeLayer:@[@0, @0, @(-_side/2), @(M_PI), @0, @0, @0]];
    //左
    [self addCubeLayer:@[@(-_side/2), @0, @0, @(-M_PI_2), @0, @1, @0]];
    //右
    [self addCubeLayer:@[@(_side/2), @0, @0, @(M_PI_2), @0, @1, @0]];
    //上
    [self addCubeLayer:@[@0, @(-_side/2), @0, @(-M_PI_2), @1, @0, @0]];
    //下
    [self addCubeLayer:@[@0, @(_side/2), @0, @(M_PI_2), @1, @0, @0]];
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0/2000;
    _cubeLayer.sublayerTransform = transform3D;
    
    [self.layer addSublayer:_cubeLayer];
}

- (void)setAutoAnimate:(BOOL)autoAnimate
{
    if (autoAnimate) [self addAnimation];
    else {
        [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRotate:)]];
    }
}

#pragma mark - PanGesture
- (void)panRotate:(UIPanGestureRecognizer *)ges
{
    static CGPoint start;
    if (ges.state == UIGestureRecognizerStateBegan) {
        start = [ges locationInView:self];
    } else if (ges.state == UIGestureRecognizerStateChanged) {
        CATransform3D transform = _cubeLayer.sublayerTransform;
        _rotMatrix = GLKMatrix4MakeWithArray((void *)&transform);
        
        CGPoint loc = [ges locationInView:self];
        CGPoint diff = CGPointMake(start.x-loc.x, start.y-loc.y);
        
        float rotX = 1 * GLKMathDegreesToRadians(diff.y/2.0);
        float rotY = -1 * GLKMathDegreesToRadians(diff.x/2.0);
        
        bool isInvertible;
        GLKVector3 xAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(_rotMatrix, &isInvertible),
                                                     GLKVector3Make(1, 0, 0));
        _rotMatrix = GLKMatrix4Rotate(_rotMatrix, rotX, xAxis.x, xAxis.y, xAxis.z);
        GLKVector3 yAxis = GLKMatrix4MultiplyVector3(GLKMatrix4Invert(_rotMatrix, &isInvertible),
                                                     GLKVector3Make(0, 1, 0));
        _rotMatrix = GLKMatrix4Rotate(_rotMatrix, rotY, yAxis.x, yAxis.y, yAxis.z);
        
        _cubeLayer.sublayerTransform = *((CATransform3D *)&_rotMatrix);
        
        start = loc;
    }
}

#pragma mark - Private
//添加自定义旋转展示动画
- (void)addAnimation
{
    _cubeLayer.sublayerTransform = CATransform3DRotate(_cubeLayer.sublayerTransform, M_PI/9.0, 0.5, 0.5, 0.5);
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"sublayerTransform.rotation.y"];
    animation.toValue = @(MAXFLOAT);
    animation.duration = MAXFLOAT;
    [_cubeLayer addAnimation:animation forKey:@"rotation"];
}

//添加sublayers
- (void)addCubeLayer:(NSArray *)params
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.contentsScale = [UIScreen mainScreen].scale;
    gradient.bounds = CGRectMake(0, 0, _side, _side);
    gradient.position = self.center;
    gradient.colors = @[(id)kGrayColor, (id)kBlackColor];
    gradient.locations = @[@0, @1];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    //抗锯齿
    gradient.shouldRasterize = YES;
    
    CATransform3D trans3D = CATransform3DMakeTranslation([params[0] floatValue], [params[1] floatValue], [params[2] floatValue]);
    CATransform3D rotate3D = CATransform3DRotate(trans3D , [params[3] floatValue], [params[4] floatValue], [params[5] floatValue], [params[6] floatValue]);
    CATransform3D transform3D = rotate3D;
//    CATransform3D transform3D = CATransform3DRotate(trans3D, [params[3] floatValue], [params[4] floatValue], [params[5] floatValue], [params[6] floatValue]);
    
    gradient.transform = transform3D;
    
    [_cubeLayer addSublayer:gradient];
}

@end
