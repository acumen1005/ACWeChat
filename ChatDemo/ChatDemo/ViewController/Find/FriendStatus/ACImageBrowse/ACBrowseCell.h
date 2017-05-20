//
//  ACBrowseCell.h
//  Tester
//
//  Created by acumen on 16/6/17.
//  Copyright © 2016年 acumen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ACBrowseCell : UICollectionViewCell

@property (assign,nonatomic) NSInteger cellID;
@property (assign,nonatomic) NSInteger sum;
@property (assign,nonatomic) NSInteger font;

@property (strong,nonatomic) UIImageView *image;

- (void)generateSmallImage:(UIImageView *)imageView;
- (void)setNumberLabelWithNumber:(NSInteger)number;

@end
