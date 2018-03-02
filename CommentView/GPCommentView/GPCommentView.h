//
//  GPCommentView.h
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface GPCommentView : UIView

#pragma mark - Property
@property (nonatomic, weak) UIViewController *contoller; /**< 将控制器传入，跳转相册 */
@property (nonatomic, weak) MASConstraint *bottomConstraint; /**< CommentView 的底部约束，键盘弹起和收起时更新约束 */


#pragma mark - Method

@end
