//
//  ACIamgeBrowseContainerView.m
//  Tester
//
//  Created by acumen on 16/6/17.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import "ACImageBrowseContainerView.h"
#import "AppDelegate.h"
#import "ACBrowseCell.h"
#import "UIView+Layout.h"

static NSString * BROWSE_IDENTIFIER = @"ACBrowseCell";

@interface ACImageBrowseContainerView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong,nonatomic) UICollectionView *collectionView;
@property (strong,nonatomic) NSMutableArray *localImages;
@property (strong,nonatomic) UIView *maskView;
@property (strong,nonatomic) AppDelegate *appDelegate;
@property (strong,nonatomic) UIImageView *showImageView;
@property (assign,nonatomic) UIImageView *originImageView;
@property (strong,nonatomic) UIImageView *tempImageView;

@end

@implementation ACImageBrowseContainerView

#pragma mark - getter

- (AppDelegate *)appDelegate {
    if(!_appDelegate){
        _appDelegate = [[UIApplication sharedApplication] delegate];
    }
    return _appDelegate;
}

- (UIView *)maskView {
    if(!_maskView){
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_maskView setBackgroundColor:[UIColor blackColor]];
    }
    return _maskView;
}

- (UICollectionView *)collectionView{
    if(!_collectionView){
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor blackColor];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[ACBrowseCell class] forCellWithReuseIdentifier:BROWSE_IDENTIFIER];
    }
    return _collectionView;
}

#pragma mark - layout 

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.horizontalSpacing = 5.0;
    self.verticalSpacing = 5.0;
    
    CGFloat currentX = 0.0;
    CGFloat currentY = 0.0;
    CGFloat nextLine = 0.0;
    
    CGFloat currentWidth = 0.0;
    CGFloat currentHeight = 0.0;
    
    for (NSInteger i = 0; i < self.localImages.count; i++) {
        UIImageView *imageview = self.localImages[i];
        currentWidth = imageview.width;
        currentHeight = imageview.height;
        CGFloat needsHorizontalSpacing = currentX == 0 ? 0 : self.horizontalSpacing;
        
        if((currentX + currentWidth + needsHorizontalSpacing) <= self.width){
            [imageview setX:currentX];
            [imageview setY:currentY];
            currentX = imageview.right + self.horizontalSpacing;
            nextLine = imageview.bottom;
        } else {
            currentY = nextLine + self.verticalSpacing;
            [imageview setX:0.0];
            [imageview setY:currentY];
            
            currentX = imageview.right + self.horizontalSpacing;
            nextLine = imageview.bottom;
        }
        
        self.viewHeight = imageview.bottom + self.verticalSpacing;
    }
    
    [self setHeight:self.viewHeight];
}

#pragma mark - 图片绘制

- (void)generateLocalImages {
    [self.localImages removeAllObjects];
    [self removeAllSubViews];
    self.viewHeight = 0.0;
    self.localImages = [@[] mutableCopy];
    
    for (NSInteger i = 0; i < self.imageNames.count; i++) {
        NSString *imageName = self.imageNames[i];
        
        UIImageView *imageview = [[UIImageView alloc] init];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageview setImage:image];
        
        [imageview setWidth:self.acWidth];
        [imageview setHeight:self.acHeight];
        [[imageview layer] setMasksToBounds:YES];
        [[imageview layer] setCornerRadius:5.0];
        
        [imageview setUserInteractionEnabled:YES];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToBrowseImage:)];
        [imageview addGestureRecognizer:tap];
        
        [self.localImages addObject:imageview];
        [self addSubview:imageview];
        
        [self.myDelegate addMaskViewInImageView:imageview
                                      imageName:imageName];
    }
    
    [self layoutSubviews];
}

- (void)renderImagesLayout {
    self.horizontalSpacing = 5.0;
    self.verticalSpacing = 5.0;

    CGFloat currentX = 0.0;
    CGFloat currentY = 0.0;
    CGFloat nextLine = 0.0;
    
    CGFloat currentWidth = 0.0;
    CGFloat currentHeight = 0.0;
    
    for (NSInteger i = 0; i < self.localImages.count; i++) {
        UIImageView *imageview = self.localImages[i];
        
        currentWidth = imageview.width;
        currentHeight = imageview.height;
        CGFloat needsHorizontalSpacing = currentX == 0 ? 0 : self.horizontalSpacing;
            
        if((currentX + currentWidth + needsHorizontalSpacing) <= self.width){
            [imageview setX:currentX];
            [imageview setY:currentY];
                
            currentX = imageview.right + self.horizontalSpacing;
            nextLine = imageview.bottom;
        } else {
            currentY = nextLine + self.verticalSpacing;
            [imageview setX:0.0];
            [imageview setY:currentY];
                
            currentX = imageview.right + self.horizontalSpacing;
            nextLine = imageview.bottom;
        }
        self.viewHeight = imageview.bottom + self.verticalSpacing;
    }
    
    [self setHeight:self.viewHeight];
}


#pragma mark - 手势方法

- (void)tapToBrowseImage:(UITapGestureRecognizer *)tapGesture {
    self.originImageView = (UIImageView *)tapGesture.view;
    
    //convert to center of screen
    CGRect clickRect = [self convertRect:_originImageView.frame toView:self.appDelegate.window];
    
    self.tempImageView = [[UIImageView alloc] init];
    [self.tempImageView setImage:self.originImageView.image];
    [self.tempImageView setFrame:clickRect];
    
    [self.appDelegate.window addSubview:self.tempImageView];
    [self.appDelegate.window addSubview:self.maskView];
    [self.appDelegate.window bringSubviewToFront:self.tempImageView];
    
    NSInteger index = [self.localImages indexOfObject:self.originImageView];
    
    [UIView animateWithDuration:0.3f animations:^{
        float width = kScreenWidth - 10.0;
        float height = (width / self.originImageView.image.size.width) * self.originImageView.image.size.height;
        
        [self.tempImageView setSize:CGSizeMake(width, height)];
        [self.tempImageView setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tempImageView removeFromSuperview];
            [self.maskView removeFromSuperview];
            
            [self.appDelegate.window addSubview:self.collectionView];
            [self.collectionView reloadData];
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }];
}

#pragma mark - UICollectionView代理方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.localImages count];
}

//加载大图
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ACBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BROWSE_IDENTIFIER forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[ACBrowseCell alloc] init];
    }
    
    cell.cellID = (NSInteger)indexPath.row + 1;
    cell.sum = [self.localImages count];
    cell.font = 17.0;
    
    [cell setNumberLabelWithNumber:cell.cellID];
    [cell generateSmallImage:self.localImages[indexPath.row]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.originImageView = self.localImages[indexPath.row];

    CGRect originRect = [self convertRect:_originImageView.frame toView:self.appDelegate.window];
    {
        CGFloat width = kScreenWidth - 10.0;
        CGFloat height = (width / _originImageView.image.size.width) * _originImageView.image.size.height;
    
        [self.tempImageView setSize:CGSizeMake(width, height)];
        [self.tempImageView setCenter:CGPointMake(kScreenWidth/2.0, kScreenHeight/2.0)];
    }
    [self.tempImageView setImage:self.originImageView.image];
    
    [self.appDelegate.window addSubview:self.tempImageView];
    [collectionView removeFromSuperview];

    [UIView animateWithDuration:0.3f animations:^{
        [self.tempImageView setFrame:originRect];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self.tempImageView removeFromSuperview];
        }
    }];
    
}

@end
