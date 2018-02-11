//
//  ViewController.m
//  CommentView
//
//  Created by ggt on 2018/2/8.
//Copyright © 2018年 ggt. All rights reserved.
//

#import "ViewController.h"
#import "GPController.h"
#import "Masonry.h"

@interface ViewController ()



@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupConstraints];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - UI

- (void)setupUI {
    
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)


#pragma mark - IBActions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    GPController *VC = [[GPController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol


#pragma mark - 懒加载

@end
