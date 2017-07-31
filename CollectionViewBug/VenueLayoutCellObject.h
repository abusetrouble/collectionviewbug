//
//  VenueLayoutCellObject.h
//  CollectionViewBug
//
//  Created by Artem Zolotuhin on 31.07.17.
//  Copyright © 2017 artemz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, VenueLayoutObjectType) {
    VenueLayoutObjectTypeEmptySpace = 0,
    VenueLayoutObjectTypeEmptyTable = 1,
    VenueLayoutObjectTypeClosedTable = 2,
    VenueLayoutObjectTypeTableWithReservation = 3,
    VenueLayoutObjectTypeCombinedTable = 4,
    VenueLayoutObjectTypeObjectTopLeft = 5,
    VenueLayoutObjectTypeObjectTopRight = 6,
    VenueLayoutObjectTypeObjectBottomLeft = 7,
    VenueLayoutObjectTypeObjectBottomRight = 8,
    VenueLayoutObjectTypeObjectTopLeftRight = 9,
    VenueLayoutObjectTypeObjectRightTopBottom = 10,
    VenueLayoutObjectTypeObjectLeftTopBottom = 11,
    VenueLayoutObjectTypeObjectBottomLeftRight = 12,
    VenueLayoutObjectTypeObjectDefault = 13,
    VenueLayoutObjectTypeObjectTopLine = 14,
    VenueLayoutObjectTypeObjectBotLine = 15,
    VenueLayoutObjectTypeObjectLeftLine = 16,
    VenueLayoutObjectTypeObjectRightLine = 17,
    
    VenueLayoutObjectTypeObjectTopLeftLine = 18,
    VenueLayoutObjectTypeObjectTopRightLine = 19,
    VenueLayoutObjectTypeObjectBotLeftLine = 20,
    VenueLayoutObjectTypeObjectBotRightLine = 21,
};

@interface VenueLayoutCellObject : NSObject

@property (nonatomic, assign, readwrite) VenueLayoutObjectType type;
@property (nonatomic, assign) NSInteger xPos;
@property (nonatomic, assign) NSInteger yPos;
@property (nonatomic, strong) UIColor *objectColor;


@end
