//
//  ECRootViewController.m
//  ECApplicationSample
//
//  Created by Xenon Chau on 15/8/2.
//  Copyright (c) 2015年 EasyCoding & Play4Fun. All rights reserved.
//

#import "ECRootViewController.h"

@interface ECRootViewController ()

@end

@implementation ECRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self view] setBackgroundColor:[UIColor yellowColor]];
    
    [self setTitle:@"零度可乐"];
    
    [self setTabBarItem:[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0]];
    
    UIButton * switchButton = [[UIButton alloc] initWithFrame:self.view.frame];
    [switchButton setTitle:@"红色" forState:UIControlStateNormal];
    [switchButton setTitle:@"黄色" forState:UIControlStateSelected];
    [switchButton.titleLabel setFont:[UIFont boldSystemFontOfSize:33]];
    [switchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [switchButton setBackgroundColor:[UIColor clearColor]];
    [switchButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];
    
    
}

- (void)switchButtonAction:(UIButton *)button {
    
    [button setSelected:![button isSelected]];
    
    if ([button isSelected]) {
        
        [[self view] setBackgroundColor:[UIColor redColor]];
        
    } else {
        
        [[self view] setBackgroundColor:[UIColor yellowColor]];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
