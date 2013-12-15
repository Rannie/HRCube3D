//
//  ViewController.m
//  Cube3D
//
//  Created by Rannie on 13-12-15.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "ViewController.h"
#import "HRCube.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    HRCube *cube = [HRCube cube3DWithFrame:self.view.bounds side:100.0 autoAnimate:NO];
    [self.view addSubview:cube];
}

@end
