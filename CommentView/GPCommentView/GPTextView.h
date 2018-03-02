//
//  GPTextView.h
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ChangeTextHeight)(NSString *text, CGFloat height, BOOL autoChangeHeight); /**< 改变输入框高度回调 */

@interface GPTextView : UITextView

#pragma mark - Property

@property (nonatomic, copy) NSString *placeholder; /**< 占位文字 */
@property (nonatomic, strong) UIColor *placeholderColor; /**< 占位文字颜色 */
@property (nonatomic, strong) UIFont *placeholderFont; /**< 占位文字字体大小 */
@property (nonatomic, assign) NSInteger numberOfLines; /**< 行数 0-无限行 */


#pragma mark - Method

/**
 改变输入框的高度
 */
- (void)textHeightDidChange:(ChangeTextHeight)changeText;

@end
