//
//  GPTextView.m
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import "GPTextView.h"
#import "Masonry.h"

@interface GPTextView ()

@property (nonatomic, assign) CGFloat textHeight; /**< 文本高度 */
@property (nonatomic, assign) CGFloat maxTextHeight; /**< 文本最大高度 */
@property (nonatomic, strong) UILabel *placeholderLabel; /**< 占位文字 */

@end

@implementation GPTextView

#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont systemFontOfSize:14.0f];
        self.numberOfLines = 4;
        self.scrollEnabled = NO;
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        [self setupUI];
        [self setupConstraints];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"%s", __func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - UI

- (void)setupUI {
    
    // 占位文字
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = [UIColor grayColor];
    [self addSubview:_placeholderLabel];
}


#pragma mark - Constraints

- (void)setupConstraints {
    
    // 占位文字
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(self.textContainerInset.top);
        make.left.equalTo(self).offset(self.textContainerInset.left + 4);
    }];
}


#pragma mark - Custom Accessors (Setter 与 Getter 方法)

/**
 设置最大行数，计算最大高度

 @param numberOfLines 行数
 */
- (void)setNumberOfLines:(NSInteger)numberOfLines {
    
    _numberOfLines = numberOfLines;
    
    if (numberOfLines == 0) {
        self.maxTextHeight = MAXFLOAT;
    } else {
        self.maxTextHeight = self.font.lineHeight * numberOfLines + self.textContainerInset.top + self.textContainerInset.bottom;
    }
}

/**
 设置占位文字
 */
- (void)setPlaceholder:(NSString *)placeholder {
    
    self.placeholderLabel.text = placeholder;
}

/**
 设置占位文字字体
 */
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    
    self.placeholderLabel.font = placeholderFont;
}

/**
 设置占位文字颜色
 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    self.placeholderLabel.textColor = placeholderColor;
}


#pragma mark - IBActions


#pragma mark - Public


#pragma mark - Private

- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.text.length > 0 ? YES : NO;
    
    NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
    
    if (self.textHeight != height) { // 高度不一样，就改变了高度
        
        // 当高度大于最大高度时，需要滚动
        self.scrollEnabled = height > self.maxTextHeight && self.maxTextHeight > 0;
        
        self.textHeight = height;
        
        //当不可以滚动（即 <= 最大高度）时，传值改变textView高度
        if (self.scrollEnabled == NO) {
            if (self.superview) {
                [self.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
            }
        }
    }
}


#pragma mark - Protocol


#pragma mark - 懒加载

@end
