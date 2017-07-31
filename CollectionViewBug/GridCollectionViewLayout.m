//
//  GridCollectionViewLayout.m
//  CollectionViewBug
//
//  Created by Artem Zolotuhin on 31.07.17.
//  Copyright © 2017 artemz. All rights reserved.
//

#import "GridCollectionViewLayout.h"

@interface GridCollectionViewLayout ()

@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat itemSpacing;
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

@implementation GridCollectionViewLayout

- (id)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    id delegate = self.collectionView.delegate;
    if ([delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        self.itemSize = [delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    self.itemSpacing = 0.0;
}

- (void)configureCollectionViewForLayout:(UICollectionView *)collectionView
{
    collectionView.alwaysBounceHorizontal = YES;
    
    [collectionView setCollectionViewLayout:self animated:NO];
}

- (void)prepareLayout
{
    
    [self setup];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (NSInteger item = 0; item < itemCount; item++) {
            indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForIndexPath:indexPath];
            
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    self.layoutInfo = cellLayoutInfo;
}

- (CGRect)frameForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger column = indexPath.row;
    NSInteger row = indexPath.section;
    
    CGFloat originX = column * (self.itemSize.width + self.itemSpacing);
    CGFloat originY = row * (self.itemSize.height + self.itemSpacing);
    
    return CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
}

- (CGSize)collectionViewContentSize
{
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    if (sectionCount == 0) {
        return CGSizeZero;
    }
    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    CGFloat width = (self.itemSize.width + self.itemSpacing) * itemCount - self.itemSpacing;
    CGFloat height = (self.itemSize.height + self.itemSpacing) * sectionCount - self.itemSpacing;
    CGSize size = CGSizeMake(width, height);
    
    return size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[indexPath];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [NSMutableArray array];
    
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *stop) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

@end

