//
//  VenueLayoutCell.h
//  CollectionViewBug
//
//  Created by Artem Zolotuhin on 31.07.17.
//  Copyright © 2017 artemz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VenueLayoutCellObject.h"

static NSString * const kVenueLayoutCellReuseIdentifier = @"VenueLayoutCell";

@interface VenueLayoutCell : UICollectionViewCell

@property (nonatomic, strong) UIColor *objectBackgroundColor;

@property (nonatomic, strong) VenueLayoutCellObject *cellObject;

@property (nonatomic, strong) CALayer *circularLayer;

- (void)updateRoundedCorners;

@end
