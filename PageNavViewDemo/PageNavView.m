//
//  PageNavView.m
//  PageNavViewDemo
//
//  Created by 罗成 on 16/11/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "PageNavView.h"

#define kTitleColorNormal [UIColor colorWithRed:0.40f green:0.40f blue:0.41f alpha:1.00f]
#define kTitleColorSelect [UIColor colorWithRed:0.86f green:0.39f blue:0.30f alpha:1.00f]
#define kButtonH 44.0f
@interface PageNavView ()

@property (strong, nonatomic) NSArray *titleArray;
@property (strong, nonatomic) NSMutableArray  *btnArray;
@property (strong, nonatomic) UIView *line;

@end

@implementation PageNavView

- (NSMutableArray *)btnArray {

    if (_btnArray == nil) {
        
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (instancetype)initWithTitleArray:(NSArray *)array frame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.titleArray = array;
        [self setupUI];
        [self setLine];
    }
    return self;
}

- (void)setupUI {

    CGFloat btnW = self.frame.size.width / self.titleArray.count;
    //根据titlearray 创建按钮
    for (int i = 0 ; i < self.titleArray.count; i ++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 100 + i;
        [btn setTitleColor:kTitleColorNormal forState:UIControlStateNormal];
        [btn setTitleColor:kTitleColorSelect forState:UIControlStateSelected];
        [btn setTitleColor:kTitleColorSelect forState:UIControlStateHighlighted | UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:16];
        btn.frame = CGRectMake(i * btnW, 0, btnW, kButtonH);
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        
        if(i == 0) {btn.selected = YES ;}
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }
}

- (void)setLine {

    CGFloat lineH = 1;

    //获取第一个btn位置
    UIButton *btn = self.btnArray [0];
    CGRect frame = btn.frame;
    frame.origin.y = btn.frame.size.height;
    frame.size.height = lineH;
    
    UIView *line = [[UIView alloc]initWithFrame:frame];
    self.line = line;
    line.backgroundColor = [UIColor redColor];
    [self addSubview:line];
    
}

- (void)setLineColor:(UIColor *)lineColor {

    _lineColor = lineColor;
    self.line.backgroundColor = _lineColor;
}

- (void)setTitleColor:(UIColor *)titleColor {

    for (UIButton *btn  in self.btnArray) {

        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor {

    for (UIButton *btn  in self.btnArray) {
        
        [btn setTitleColor:titleSelectColor forState:UIControlStateNormal];
    }

}

- (void)btnClick:(UIButton *)btn {
    
    btn.selected = YES;
    
    [self unSelectedAllButtonExcept:btn];
    
    [self sideLineAnimationWithIndex:btn.tag - 100];
    
    if ([self.delegate respondsToSelector:@selector(pageNavViewWithIndex:)]) {
        [self.delegate pageNavViewWithIndex:btn.tag - 100];
    }
}

- (void)transToControllerAtSourceIndexToTargetIndex:(NSInteger)sourceIndex targetIndex:(NSInteger) targetIndex {

     UIButton *btn = (UIButton *)[self viewWithTag:sourceIndex + 100];
     btn.selected = YES;
    [self unSelectedAllButtonExcept:btn];
    [self sideLineAnimationWithIndex:sourceIndex];
    
}

//将除了当前按钮之外的所有按钮置为非选中状态
- (void)unSelectedAllButtonExcept:(UIButton *)btn {
    
    for (UIButton *button in self.btnArray) {
        if (button != btn) {
            button.selected = NO;
        }
    }
}

- (void)sideLineAnimationWithIndex:(NSInteger)index {
    
    UIButton *btn = self.btnArray[index];
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = self.line.frame;
        frame.origin.x = btn.frame.origin.x;
        self.line.frame = frame;
    }];
    
}


@end
