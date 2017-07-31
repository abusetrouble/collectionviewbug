//
//  VenueLayoutCellObject.m
//  CollectionViewBug
//
//  Created by Artem Zolotuhin on 31.07.17.
//  Copyright © 2017 artemz. All rights reserved.
//

#import "VenueLayoutCellObject.h"
static NSString *kVenueLayoutCellObjectXPosKey = @"xPos";
static NSString *kVenueLayoutCellObjectYPosKey = @"yPos";
static NSString *kVenueLayoutCellObjectTypeKey = @"type";
static NSString *kVenueLayoutCellObjectColorKey = @"objectColor";

@implementation VenueLayoutCellObject

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[VenueLayoutCellObject class]]) {
        return NO;
    }
    
    return [self isEqualToObject:(VenueLayoutCellObject *)object];
}

- (BOOL)isEqualToObject:(VenueLayoutCellObject *)object
{
    if (!object) {
        return NO;
    }
    BOOL haveEqualXPos = self.xPos == object.xPos;
    BOOL haveEqualYPos = self.yPos == object.yPos;
    return haveEqualXPos && haveEqualYPos;
}

- (NSUInteger)hash
{
    return [@(self.type) hash] ^ [@(self.xPos) hash] ^ [@(self.yPos) hash];
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeInteger:self.xPos forKey:kVenueLayoutCellObjectXPosKey];
    [coder encodeInteger:self.yPos forKey:kVenueLayoutCellObjectYPosKey];
    [coder encodeInteger:self.type forKey:kVenueLayoutCellObjectTypeKey];
    [coder encodeObject:self.objectColor forKey:kVenueLayoutCellObjectColorKey];
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self) {
        self.xPos = [coder decodeIntegerForKey:kVenueLayoutCellObjectXPosKey];
        self.yPos = [coder decodeIntegerForKey:kVenueLayoutCellObjectYPosKey];
        self.type = [coder decodeIntegerForKey:kVenueLayoutCellObjectTypeKey];
    }
    return self;
}
@end
