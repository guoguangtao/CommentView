//
//  GPCommentView.m
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import "GPCommentView.h"
#import "GPTextView.h"

@interface GPCommentView () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *contentScrollView; /**< 评论内容 */
@property (nonatomic, strong) UIView *contentView; /**< 内容视图 */
@property (nonatomic, strong) UIImageView *imageView; /**< 图片 */
@property (nonatomic, strong) GPTextView *textView; /**< 输入框 */
@property (nonatomic, strong) UIButton *chooseImageButton; /**< 选择图片按钮 */

@property (nonatomic, assign) CGFloat imageHeight; /**< 图片高度 */
@property (nonatomic, assign) CGFloat commentHeight; /**< 评论框的高度 */

@end

@implementation GPCommentView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 4.0f;
        self.layer.borderColor = [UIColor orangeColor].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.masksToBounds = YES;
        self.imageHeight = 50;
        self.commentHeight = 30;
        
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
    
    // 选择照片
    _chooseImageButton = [[UIButton alloc] init];
    _chooseImageButton.backgroundColor = [UIColor blueColor];
    [_chooseImageButton addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_chooseImageButton];
    
    // ScrollView
    _contentScrollView = [[UIScrollView alloc] init];
    [self addSubview:_contentScrollView];
    
    // contentView
    _contentView = [[UIView alloc] init];
    [_contentScrollView addSubview:_contentView];
    
    // textView
    _textView = [[GPTextView alloc] init];
    _textView.numberOfLines = 3;
    _textView.placeholder = @"请输入内容";
    [_contentView addSubview:_textView];
    __weak typeof(self) wkSelf = self;
    [_textView textHeightDidChange:^(NSString *text, CGFloat height, BOOL autoChangeHeight) {
        [wkSelf updateHeightWithHeight:height autoChangeHeight:autoChangeHeight];
    }];
    
    // imageView
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor purpleColor];
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseImage)]];
    [_contentView addSubview:_imageView];
}

- (void)updateHeightWithHeight:(CGFloat)height autoChangeHeight:(BOOL)autoChangeHeight {
    
    CGFloat imageHeight = self.imageView.image ? self.imageHeight : 0;
    if (autoChangeHeight) {
        // 设置输入框的高度
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(height + imageHeight);
        }];
    }
    // 设置文字可滚动范围
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height + imageHeight);
    }];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self layoutIfNeeded];
}

#pragma mark - Constraints

- (void)setupConstraints {
    
    // 选择照片
    [self.chooseImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.width.height.mas_equalTo(self.commentHeight);
        make.bottom.equalTo(self);
    }];
    
    // ScrollView
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.equalTo(self);
        make.right.equalTo(self.chooseImageButton.mas_left).offset(-12);
    }];
    
    // contentView
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentScrollView);
        make.width.mas_equalTo(self.contentScrollView);
        make.height.mas_equalTo(self.commentHeight);
    }];
    
    // textView
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(self.commentHeight);
    }];
    
    // imageView
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom);
        make.left.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(self.imageHeight);
        make.height.mas_equalTo(0);
    }];
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)


#pragma mark - IBActions

- (void)chooseImage {
    
    if (self.contoller) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.contoller presentViewController:imagePicker animated:YES completion:nil];
    }
}


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

/**
 更新底部约束
 */
- (void)updateBottomConstraintsWithHeight:(CGFloat)height duration:(CGFloat)duration {
    
    self.bottomConstraint.offset(-height);
    [UIView animateWithDuration:duration animations:^{
        [self.superview layoutIfNeeded];
    }];
}

#pragma mark - Protocol

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info valueForKeyPath:@"UIImagePickerControllerOriginalImage"];
    BOOL autoChangeHeight = self.imageView.image ? NO : YES; //  是否需要改变高度 第一次选择图片 YES 切换图片 NO
    self.imageView.image = image;
    [self layoutIfNeeded];
    
    if (autoChangeHeight) {
        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(self.imageHeight);
        }];
        BOOL isMoreThree = CGRectGetHeight(self.textView.frame) > CGRectGetHeight(self.contentScrollView.frame);
        if (isMoreThree) {
            // 设置输入框的高度
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(CGRectGetHeight(self.contentScrollView.frame) + self.imageHeight);
            }];
            // 设置文字可滚动范围
            [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(CGRectGetHeight(self.textView.frame) + self.imageHeight);
            }];
            [self.contentScrollView setContentOffset:CGPointMake(0, self.contentScrollView.contentSize.height - CGRectGetHeight(self.contentScrollView.frame)) animated:YES];
        } else {
            [self updateHeightWithHeight:self.textView.frame.size.height autoChangeHeight:autoChangeHeight];
        }
    }
    [self layoutIfNeeded];
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 懒加载

@end
