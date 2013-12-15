//
//  HRCube.h
//  Cube3D
//
//  Created by Rannie on 13-12-15.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HRCube : UIView

@property (nonatomic, assign, readonly) CGFloat side;
@property (nonatomic, assign, readonly) BOOL autoAnimate;

/**
 *  创建一个正方体对象
 *
 *  @param frame   位置
 *  @param side    边长
 *  @param animate 创建后是否自动旋转展示
 *
 *  @return 正方体对象视图
 */
+ (HRCube *)cube3DWithFrame:(CGRect)frame side:(CGFloat)side autoAnimate:(BOOL)animate;

@end
