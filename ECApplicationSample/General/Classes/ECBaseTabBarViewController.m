//
//  ECBaseTabBarViewController.m
//  ECApplicationSample
//
//  Created by Xenon Chau on 15/8/2.
//  Copyright (c) 2015年 EasyCoding & Play4Fun. All rights reserved.
//

#import "ECBaseTabBarViewController.h"

#import "ECRootViewController.h"
#import "ECFunctionViewController.h"

@interface ECBaseTabBarViewController ()

@end

@implementation ECBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _rootViewController = [[ECRootViewController alloc] init];
    UINavigationController * rootNavi = [[UINavigationController alloc] initWithRootViewController:_rootViewController];
    
//    _functionViewController = [[ECFunctionViewController alloc] init];
    _functionViewController = [[ECFunctionViewController alloc] initWithNibName:@"ECFunctionViewController" bundle:nil];
    UINavigationController * funcNavi = [[UINavigationController alloc] initWithRootViewController:_functionViewController];
    
    
    [self setViewControllers:@[rootNavi, funcNavi] animated:YES];
}

@end
