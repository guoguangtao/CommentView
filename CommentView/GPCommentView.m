//
//  GPCommentView.m
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import "GPCommentView.h"
#import "GPTextView.h"
#import "Masonry.h"

@interface GPCommentView ()

@property (nonatomic, strong) GPTextView *textView;

@end

@implementation GPCommentView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = YES;
        
        [self setupUI];
        [self setupConstraints];
        [self addObserver];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI

- (void)setupUI {
    
    // 输入框
    _textView = [[GPTextView alloc] init];
    _textView.placeholder = @"请输入内容";
    [self addSubview:_textView];
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    // 输入框
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)


#pragma mark - IBActions


#pragma mark - Public


#pragma mark - Private

/**
 添加通知
 */
- (void)addObserver {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 键盘通知
 */
- (void)keyboardChange:(NSNotification *)notifi {
    
    NSDictionary *userInfo = notifi.userInfo;
    CGFloat duration = [[userInfo valueForKeyPath:@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGFloat keyboardHeight = [[userInfo valueForKeyPath:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].size.height;  /**< 键盘的高度 */
    if ([notifi.name isEqualToString:UIKeyboardWillShowNotification]) {
        // 键盘弹起
        [self updateBottomConstraintsWithHeight:keyboardHeight duration:duration];
        
    } else if ([notifi.name isEqualToString:UIKeyboardWillHideNotification]) {
        // 键盘收起
        [self updateBottomConstraintsWithHeight:0 duration:duration];
    }
}

- (void)updateBottomConstraintsWithHeight:(CGFloat)height duration:(CGFloat)duration {
    
    self.bottomConstraint.offset(-height);
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}


#pragma mark - Protocol


#pragma mark - 懒加载

@end
