//
//  VenueLayoutCell.m
//  CollectionViewBug
//
//  Created by Artem Zolotuhin on 31.07.17.
//  Copyright © 2017 artemz. All rights reserved.
//

#import "VenueLayoutCell.h"

@interface VenueLayoutCell ()

@property (nonatomic, assign) VenueLayoutObjectType type;

@property (nonatomic, strong) UIColor *deselectedColor;

@property (weak, nonatomic) IBOutlet UIView *viewInside;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewInsideLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewInsideBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewInsideTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewInsideTrailingConstraint;

@property (nonatomic, strong) CALayer *topLineLayer;
@property (nonatomic, strong) CALayer *botLineLayer;
@property (nonatomic, strong) CALayer *leftLineLayer;
@property (nonatomic, strong) CALayer *rightLineLayer;
@property (nonatomic, strong) CAShapeLayer *objectMaskLayer;

@property (nonatomic, assign) CGFloat initialWidthAndHeight;

@end

static CGFloat kVenueLayoutCellDefaultCornerRadiusDivider = 6.f;

@implementation VenueLayoutCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self allocAndAddLayers];
}

- (void)allocAndAddLayers
{
    self.circularLayer = [CALayer layer];
    [self.layer addSublayer:self.circularLayer];
    
    self.topLineLayer = [CALayer layer];
    [self.layer addSublayer:self.topLineLayer];
    
    self.botLineLayer = [CALayer layer];
    [self.layer addSublayer:self.botLineLayer];
    
    self.leftLineLayer = [CALayer layer];
    [self.layer addSublayer:self.leftLineLayer];
    
    self.rightLineLayer = [CALayer layer];
    [self.layer addSublayer:self.rightLineLayer];
    
    self.objectMaskLayer = [CAShapeLayer layer];
    //self.circularLayer.mask = self.objectMaskLayer;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//- (void)dealloc
//{
//    [self removeObservers];
//}

#pragma mark - Property Set

- (void)setCellObject:(VenueLayoutCellObject *)cellObject
{
    self->_cellObject = cellObject;
    self.objectBackgroundColor = cellObject.objectColor;
    self.type = cellObject.type;
}

- (void)prepareForReuse
{
    [self.circularLayer removeFromSuperlayer];
    [self.topLineLayer removeFromSuperlayer];
    [self.botLineLayer removeFromSuperlayer];
    [self.leftLineLayer removeFromSuperlayer];
    [self.rightLineLayer removeFromSuperlayer];
    [self allocAndAddLayers];
}

- (void)setType:(VenueLayoutObjectType)type
{
    self->_type = type;
    //self.circularLayer.backgroundColor = [[UIColor redColor] CGColor];
    [self updateInderfaceDependOnType];
}

- (void)layoutSubviews
{
    //    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    [self updateRoundedCorners];
    //    [self updateRoundedCorners];
    [CATransaction commit];
    [super layoutSubviews];
    //    [self updateRoundedCorners];
}

- (void)updateRoundedCorners
{
    UIRectCorner corners = UIRectCornerAllCorners;
    BOOL isObjectType = YES;
    BOOL isLineType = NO;
    switch (self.type) {
        case VenueLayoutObjectTypeObjectTopLeft:
            corners = UIRectCornerTopLeft;
            break;
        case VenueLayoutObjectTypeObjectTopRight:
            corners = UIRectCornerTopRight;
            break;
        case VenueLayoutObjectTypeObjectBottomLeft:
            corners = UIRectCornerBottomLeft;
            break;
        case VenueLayoutObjectTypeObjectBottomRight:
            corners = UIRectCornerBottomRight;
            break;
        case VenueLayoutObjectTypeObjectTopLeftRight:
            corners = UIRectCornerTopLeft | UIRectCornerTopRight;
            break;
        case VenueLayoutObjectTypeObjectBottomLeftRight:
            corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case VenueLayoutObjectTypeObjectLeftTopBottom:
            corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
            break;
        case VenueLayoutObjectTypeObjectRightTopBottom:
            corners = UIRectCornerBottomRight | UIRectCornerTopRight;
            break;
        case VenueLayoutObjectTypeObjectDefault:
            break;
        case VenueLayoutObjectTypeObjectBotLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectTopLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectLeftLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectRightLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectTopRightLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectTopLeftLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectBotRightLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        case VenueLayoutObjectTypeObjectBotLeftLine:
            isLineType = YES;
            isObjectType = NO;
            break;
        default:
            isObjectType = NO;
            break;
    }
    if (isLineType) {
        CGRect bounds = self.frame;
        CGFloat thickness = lroundf(CGRectGetWidth(bounds) / 10.f);
        switch (self.type) {
            case VenueLayoutObjectTypeObjectTopLine:
                self.topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), thickness);
                break;
            case VenueLayoutObjectTypeObjectBotLine:
                self.botLineLayer.frame = CGRectMake(0, CGRectGetHeight(bounds) - thickness, CGRectGetWidth(bounds), thickness);
                break;
            case VenueLayoutObjectTypeObjectLeftLine:
                self.leftLineLayer.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(bounds));
                break;
            case VenueLayoutObjectTypeObjectRightLine:
                self.rightLineLayer.frame = CGRectMake(CGRectGetWidth(bounds) - thickness, 0, thickness, CGRectGetHeight(bounds));
                break;
            case VenueLayoutObjectTypeObjectTopLeftLine:
                self.topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), thickness);
                self.leftLineLayer.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(bounds));
                break;
            case VenueLayoutObjectTypeObjectTopRightLine:
                self.topLineLayer.frame = CGRectMake(0, 0, CGRectGetWidth(bounds), thickness);
                self.rightLineLayer.frame = CGRectMake(CGRectGetWidth(bounds) - thickness, 0, thickness, CGRectGetHeight(bounds));
                break;
            case VenueLayoutObjectTypeObjectBotLeftLine:
                self.botLineLayer.frame = CGRectMake(0, CGRectGetHeight(bounds) - thickness, CGRectGetWidth(bounds), thickness);
                self.leftLineLayer.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(bounds));
                break;
            case VenueLayoutObjectTypeObjectBotRightLine:
                self.botLineLayer.frame = CGRectMake(0, CGRectGetHeight(bounds) - thickness, CGRectGetWidth(bounds), thickness);
                self.rightLineLayer.frame = CGRectMake(CGRectGetWidth(bounds) - thickness, 0, thickness, CGRectGetHeight(bounds));
                break;
            default:
                break;
        }
        CGColorRef lineColor = [UIColor colorWithRed:128.f/255.f green:128.f/255.f blue:128.f/255.f alpha:1.f].CGColor;
        if (self.type == VenueLayoutObjectTypeObjectTopLine) {
            //lineColor = [[UIColor redColor] CGColor];
        }
        self.topLineLayer.backgroundColor = lineColor;//[UIColor whiteColor].CGColor;
        self.botLineLayer.backgroundColor = lineColor;//[UIColor whiteColor].CGColor;
        self.leftLineLayer.backgroundColor = lineColor;//[UIColor whiteColor].CGColor;
        self.rightLineLayer.backgroundColor = lineColor;//[UIColor whiteColor].CGColor;
        
        //        bounds.size.width = MIN(bounds.size.width, bounds.size.height) * 0.8;
        //        bounds.size.height = bounds.size.width;
        bounds.size.width = MIN(bounds.size.width, bounds.size.height) * 0.8;
        bounds.size.height = bounds.size.width;
        
        self.circularLayer.bounds = bounds;
        self.circularLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGRect rect = self.circularLayer.bounds;
        self.circularLayer.cornerRadius = rect.size.width * 0.5;
        
        [self setLayerBackgroundColor:[UIColor blackColor]];
        
    } else if (isObjectType) {
        CGRect bounds = self.bounds;
        CGRect frame = self.frame;
        //        bounds.size.width = MAX(bounds.size.width, bounds.size.height);
        //        bounds.size.height = bounds.size.width;
        self.circularLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        //self.circularLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
        
        if (self.type != VenueLayoutObjectTypeObjectDefault) {
            CGRect rect = self.circularLayer.bounds;
            CGFloat radius = CGRectGetWidth(rect) / kVenueLayoutCellDefaultCornerRadiusDivider;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
            self.objectMaskLayer.frame = bounds;
            self.objectMaskLayer.path = maskPath.CGPath;
            self.circularLayer.mask = self.objectMaskLayer;
        }
    } else {
        CGRect bounds = self.bounds;
        bounds.size.width = MIN(bounds.size.width, bounds.size.height) * 0.8;
        bounds.size.height = bounds.size.width;
        self.circularLayer.bounds = bounds;
        self.circularLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
        CGRect rect = self.circularLayer.bounds;
        self.circularLayer.cornerRadius = rect.size.width * 0.5;
    }
}

- (void)setLayerBackgroundColor:(UIColor *)color
{
    self.circularLayer.backgroundColor = color.CGColor;
    self.objectMaskLayer.strokeColor = color.CGColor;
    self.deselectedColor = color;
}

- (void)updateInderfaceDependOnType
{
    UIColor *tempObjectColor = [UIColor grayColor];
    UIColor *objectColor = self.objectBackgroundColor ? : tempObjectColor;
    switch (self.type) {
        case VenueLayoutObjectTypeEmptySpace:
            [self setLayerBackgroundColor:[UIColor blackColor]];
            break;
        case VenueLayoutObjectTypeObjectDefault: {
            [self setLayerBackgroundColor:objectColor];
            break;
        }
        case VenueLayoutObjectTypeObjectTopLeft: {
            [self setLayerBackgroundColor:objectColor];
            break;
        }
        case VenueLayoutObjectTypeObjectTopRight: {
            [self setLayerBackgroundColor:objectColor];
        }
            break;
        case VenueLayoutObjectTypeObjectBottomLeft:
            [self setLayerBackgroundColor:objectColor];
            break;
        case VenueLayoutObjectTypeObjectBottomRight:
            [self setLayerBackgroundColor:objectColor];
            break;
        case VenueLayoutObjectTypeObjectTopLeftRight:
            [self setLayerBackgroundColor:objectColor];
            break;
        case VenueLayoutObjectTypeObjectBottomLeftRight:
            [self setLayerBackgroundColor:objectColor];
            break;
        case VenueLayoutObjectTypeObjectLeftTopBottom:
            [self setLayerBackgroundColor:objectColor];
            break;
        case VenueLayoutObjectTypeObjectRightTopBottom:
            [self setLayerBackgroundColor:objectColor];
            break;
        case VenueLayoutObjectTypeEmptyTable:
            [self setLayerBackgroundColor:[UIColor whiteColor]];
            break;
        case VenueLayoutObjectTypeTableWithReservation:
            [self setLayerBackgroundColor:[UIColor yellowColor]];
            break;
        case VenueLayoutObjectTypeCombinedTable:
            [self setLayerBackgroundColor:[UIColor redColor]];
            break;
        case VenueLayoutObjectTypeClosedTable:
            [self setLayerBackgroundColor:[UIColor blackColor]];
            break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected
{
    
    if (selected) {
        self.circularLayer.backgroundColor = [UIColor yellowColor].CGColor;
    } else {
        self.circularLayer.backgroundColor = self.deselectedColor.CGColor;
    }
    
    [super setSelected:selected];
}

@end
