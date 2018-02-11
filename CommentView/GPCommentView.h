//
//  GPCommentView.h
//  CommentView
//
//  Created by ggt on 2018/2/7.
//Copyright © 2018年 ggt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@protocol GPCommentViewDelegate;

@interface GPCommentView : UIView

#pragma mark - Property
@property (nonatomic, weak) UIViewController *contoller;
@property (nonatomic, weak) MASConstraint *bottomConstraint;
@property (nonatomic, weak) id <GPCommentViewDelegate> delegate;


#pragma mark - Method

@end

@protocol GPCommentViewDelegate <NSObject>

- (void)commentViewDidSelectedImage:(GPCommentView *)commentView;

@end
