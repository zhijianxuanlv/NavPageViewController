//
//  PageNavView.h
//  PageNavViewDemo
//
//  Created by 罗成 on 16/11/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PageNavViewDelegate  <NSObject>

- (void)pageNavViewWithIndex:(NSInteger)index;

@end


@interface PageNavView : UIView

- (instancetype)initWithTitleArray:(NSArray *)array frame:(CGRect)frame;

@property (nonatomic, weak) id <PageNavViewDelegate> delegate;

@property (nonatomic, strong) UIColor *lineColor;/** defult is red color  */

@property (nonatomic, strong) UIColor *titleNormalColor; /** defult is black color  */
@property (nonatomic, strong) UIColor *titleSelectColor; /** defult is red color  */

- (void)transToControllerAtSourceIndexToTargetIndex:(NSInteger)sourceIndex targetIndex:(NSInteger) targetIndex;

@end
