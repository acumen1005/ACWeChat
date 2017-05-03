//
//  ACIamgeBrowseContainerView.h
//  Tester
//
//  Created by acumen on 16/6/17.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ACImageBrowseContainerView <NSObject>

- (void)addMaskViewInImageView:(UIImageView *)image imageName:(NSString *)imageName;

@end

@interface ACImageBrowseContainerView : UIView

//本地图片
@property (strong,nonatomic) NSArray *imageNames;

//图片size
@property (assign,nonatomic) CGFloat acWidth;
@property (assign,nonatomic) CGFloat acHeight;

@property (assign,nonatomic) CGFloat horizontalSpacing;
@property (assign,nonatomic) CGFloat verticalSpacing;

@property (assign,nonatomic) CGFloat viewHeight;

@property (weak,nonatomic) id<ACImageBrowseContainerView> myDelegate;

- (void)generateLocalImages;
- (void)drawImagesLayout;

@end
