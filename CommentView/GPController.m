//
//  GPController.m
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import "GPController.h"
#import "Masonry.h"
#import "GPCommentView.h"
#import "UIDevice+DeviceInfo.h"

@interface GPController ()

@property (nonatomic, strong) GPCommentView *commentView;

@end

@implementation GPController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    [self setupConstraints];
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
}


#pragma mark - UI

- (void)setupUI {
    
    // 输入框
    _commentView = [[GPCommentView alloc] init];
    _commentView.contoller = self;
    [self.view addSubview:_commentView];
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    // 输入框
    [self.commentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        self.commentView.bottomConstraint = make.bottom.equalTo(self.view).offset(0);
        make.height.mas_equalTo(30);
    }];
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)


#pragma mark - IBActions

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}


#pragma mark - Public


#pragma mark - Private


#pragma mark - Protocol

#pragma mark - GPCommentViewDelegate


#pragma mark - 懒加载

@end
