//
//  ViewController.m
//  PageNavViewDemo
//
//  Created by 罗成 on 16/11/29.
//  Copyright © 2016年 LC. All rights reserved.
//

#import "ViewController.h"
#import "PageNavView.h"

static NSString *ContentCellID = @"ContentCellID";

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource, PageNavViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *childVCs;
@property (nonatomic, assign) CGFloat startOffsetX;
@property (nonatomic, strong) PageNavView *pageView;
@end

@implementation ViewController

- (UICollectionView *)collectionView {

    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layer = [[UICollectionViewFlowLayout alloc]init];
        layer.itemSize = self.view.bounds.size;
        layer.minimumLineSpacing = 0;
        layer.minimumInteritemSpacing = 0;
        layer.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layer];
        _collectionView.showsHorizontalScrollIndicator = false;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = false;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:ContentCellID];
    }
    
    return _collectionView;
}

- (NSMutableArray *)childVCs {

    if (!_childVCs) {
        
        _childVCs = [NSMutableArray array];
        
    }
    return _childVCs;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.navigationController.navigationBar.translucent = NO;
    PageNavView *pageView = [[PageNavView alloc]initWithTitleArray:@[@"xi",@"hu",@"wx",@"ef"] frame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    pageView.delegate = self;
    self.pageView = pageView;
    self.navigationItem.titleView = pageView;
    
    [self.view addSubview:self.collectionView];
    
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor whiteColor];
        [self.childVCs addObject:vc];
        UIViewController *vc1 = [[UIViewController alloc]init];
        vc1.view.backgroundColor = [UIColor grayColor];
        [self.childVCs addObject:vc1];
        UIViewController *vc2 = [[UIViewController alloc]init];
        vc2.view.backgroundColor = [UIColor blueColor];
        [self.childVCs addObject:vc2];
        UIViewController *vc3 = [[UIViewController alloc]init];
        vc3.view.backgroundColor = [UIColor orangeColor];
        [self.childVCs addObject:vc3];

}

#pragma mark --UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.childVCs.count;

}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ContentCellID forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
        UIViewController *vc = self.childVCs[indexPath.item];
        vc.view.frame = cell.contentView.bounds;
        [cell.contentView addSubview:vc.view];
    return cell;

}

#pragma mark --UICollectionViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

    //判断左滑还是右滑
    self.startOffsetX = scrollView.contentOffset.x;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    //判断左滑还是右滑
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    NSInteger sourceIndex;
    NSInteger targetIndex;
    CGFloat progress;
    if (currentOffsetX > _startOffsetX) { //左滑
         progress = (currentOffsetX / scrollViewW) - floor(currentOffsetX / scrollViewW);
         sourceIndex = (NSInteger) currentOffsetX / scrollViewW;
         targetIndex = sourceIndex + 1;
        
        if (targetIndex >= self.childVCs.count) {
            targetIndex = self.childVCs.count - 1;
        }
        if (currentOffsetX - _startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
        if (progress == 0 || progress == 1) {
         [self transToControllerAtSourceIndexToTargetIndex:sourceIndex targetIndex:targetIndex];
        }
    }else { //右滑
        progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));

        targetIndex = (NSInteger) currentOffsetX / scrollViewW;

         sourceIndex = targetIndex + 1;
        if (sourceIndex >= self.childVCs.count) {
            sourceIndex = self.childVCs.count - 1;
        }
        if (progress == 0 || progress == 1) {//判断完全滑动的状态
            [self transToControllerAtSourceIndexToTargetIndex:targetIndex targetIndex:sourceIndex];
        }
    }
}

- (void)transToControllerAtSourceIndexToTargetIndex:(NSInteger)sourceIndex targetIndex:(NSInteger) targetIndex  {

    [self.pageView transToControllerAtSourceIndexToTargetIndex:sourceIndex targetIndex:targetIndex];

}

#pragma mark --PageNavViewDelegate
- (void)pageNavViewWithIndex:(NSInteger)index {

    [_collectionView setContentOffset:CGPointMake(_collectionView.frame.size.width * index, 0)  animated:NO];
    
}




@end
