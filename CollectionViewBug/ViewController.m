//
//  ViewController.m
//  CollectionViewBug
//
//  Created by Artem Zolotuhin on 31.07.17.
//  Copyright © 2017 artemz. All rights reserved.
//

#import "ViewController.h"
#import "VenueLayoutCellObject.h"
#import "VenueLayoutCell.h"

@interface ViewController () <UICollectionViewDelegate,
                              UICollectionViewDataSource>

// IBOutlets
@property (weak, nonatomic) IBOutlet UICollectionView *activeCollectionView;

// Constraints

// Models

// Properties
@property (nonatomic, assign) CGFloat venueLayoutZoom;
@property (nonatomic, strong) NSMutableArray *activeCollectionViewObjects;
@property (nonatomic, assign) CGFloat widthAndHeightForActiveCollectionView;
@property (nonatomic, assign) NSInteger increasedWidthInitialIndex;


@end

@implementation ViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    
    NSString *pathString = [self layoutFilePath];
    
    NSMutableData *pData = [[NSMutableData alloc] initWithContentsOfFile:pathString];
    NSArray *result = nil;
    if (pData) {
        NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:pData];
         result = [[NSArray alloc] initWithCoder:unArchiver];
        [unArchiver finishDecoding];
    }
    self.venueLayoutZoom = 1.f;
    self.activeCollectionViewObjects = [[NSMutableArray alloc] init];
    
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.activeCollectionView addGestureRecognizer:gesture];
    
    UINib *venueLayoutCell = [UINib nibWithNibName:@"VenueLayoutCell" bundle:nil];
    [self.activeCollectionView registerNib:venueLayoutCell forCellWithReuseIdentifier:kVenueLayoutCellReuseIdentifier];
    
    self.activeCollectionViewObjects = [result mutableCopy];//[[self venueLayoutSectionsAndRowsFromArray:result] mutableCopy];
    
    self.widthAndHeightForActiveCollectionView = [self widthAndHeightForActiveCollectionViewItem];
    
    [self.activeCollectionView reloadData];
}

#pragma mark - Property Set

- (void)setActiveCollectionViewObjects:(NSMutableArray *)activeCollectionViewObjects
{
    self->_activeCollectionViewObjects = activeCollectionViewObjects;
    if (activeCollectionViewObjects) {
        self.widthAndHeightForActiveCollectionView = [self widthAndHeightForActiveCollectionViewItem];
    }
}

- (void)setVenueLayoutZoom:(CGFloat)venueLayoutZoom
{
    CGFloat lowerBound = 1.f;
    CGFloat upperBound = 4.f;
    
    if (venueLayoutZoom < lowerBound) {
        self->_venueLayoutZoom = lowerBound;
    } else if (venueLayoutZoom > upperBound) {
        self->_venueLayoutZoom = upperBound;
    } else {
        self->_venueLayoutZoom = venueLayoutZoom;
    }
}

#pragma mark - Helpers

- (NSString *)layoutFilePath
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = @"layout";
    NSString *pathString = [[pathArray objectAtIndex:0] stringByAppendingPathComponent:filename];
    return pathString;
}

- (NSArray<NSArray *> *)venueLayoutSectionsAndRowsFromArray:(NSArray<VenueLayoutCellObject *> *)objects
{
    NSNumber *maxRow = [objects valueForKeyPath:@"@max.yPos"];
    NSMutableArray<NSMutableArray *> *resultArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < maxRow.integerValue; i++) {
        [resultArray addObject:[@[] mutableCopy]];
    }
    [objects enumerateObjectsUsingBlock:^(VenueLayoutCellObject * _Nonnull object, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger yPos = object.yPos;
        if (resultArray.count > yPos) {
            NSMutableArray *currentArray = resultArray[yPos];
            [currentArray addObject:object];
        }
    }];
    
    NSArray *sortedArray = [resultArray sortedArrayUsingComparator:^NSComparisonResult(NSArray *array1, NSArray *array2) {
        VenueLayoutCellObject *obj1 = array1.firstObject;
        VenueLayoutCellObject *obj2 = array2.firstObject;
        return [@(obj1.xPos) compare:@(obj2.xPos)];
    }];
    return sortedArray;
}

- (CGFloat)widthAndHeightForActiveCollectionViewItem
{
    NSArray *array = self.activeCollectionViewObjects;
    __block NSInteger maxCount = 0;
    [array enumerateObjectsUsingBlock:^(NSArray *subArray, NSUInteger idx, BOOL * _Nonnull stop) {
        if (subArray.count > maxCount) {
            maxCount = subArray.count;
        }
    }];
    if (maxCount > 0) {
        NSInteger width = CGRectGetWidth(self.activeCollectionView.bounds);
        CGFloat widthAndHeight = (width / 1.f) / maxCount;
        NSNumber *widthNumber = @(CGRectGetWidth(self.activeCollectionView.bounds));
        NSInteger count = widthNumber.integerValue % maxCount;
        maxCount--;
        self.increasedWidthInitialIndex = maxCount - count;
        return widthAndHeight;
    }
    return 0;
}

- (NSArray *)removeColumnsCount:(NSInteger)count from:(NSArray<NSArray<VenueLayoutCellObject *> *> *)layoutArray
{
    NSMutableArray *newResultArray = [[NSMutableArray alloc] init];
    [layoutArray enumerateObjectsUsingBlock:^(NSArray<VenueLayoutCellObject *> * _Nonnull row, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *rowCopy = [row mutableCopy];
        for (int i = 0; i < count; i++) {
            [rowCopy removeLastObject];
        }
        [newResultArray addObject:[rowCopy copy]];
    }];
    return newResultArray;
}

- (NSArray *)removeRowsCount:(NSInteger)count from:(NSArray *)layoutArray
{
    NSMutableArray *result = [layoutArray mutableCopy];
    for (int i = 0; i < count; i++) {
        [result removeLastObject];
    }
    return [result copy];
}

#pragma mark - Api Calls

#pragma mark - UI Actions

- (IBAction)touchUpInsideRemoveRowButton:(id)sender
{
    NSArray *layoutArray = self.activeCollectionViewObjects;
    layoutArray = [self removeRowsCount:1 from:layoutArray];
    self.activeCollectionViewObjects = [layoutArray mutableCopy];
    [self.activeCollectionView reloadData];
}

- (IBAction)touchUpInsideRemoveColumnButton:(id)sender
{
    NSArray *layoutArray = self.activeCollectionViewObjects;
    layoutArray = [self removeColumnsCount:1 from:layoutArray];
    self.activeCollectionViewObjects = [layoutArray mutableCopy];
    [self.activeCollectionView reloadData];
}


- (void)didReceivePinchGesture:(UIPinchGestureRecognizer *)gesture
{
    static CGFloat scaleStart;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        scaleStart = self.venueLayoutZoom;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        self.venueLayoutZoom = scaleStart * gesture.scale;
        if([gesture numberOfTouches] >= 2) {
            CGPoint touch1 = [gesture locationOfTouch:0 inView:self.activeCollectionView];
            CGPoint touch2 = [gesture locationOfTouch:1 inView:self.activeCollectionView];
            CGPoint mid;
            mid.x = ((touch2.x - touch1.x) / 2) + touch1.x;
            mid.y = ((touch2.y - touch1.y) / 2) + touch1.y;
            NSIndexPath *currentIndexPath = [self.activeCollectionView indexPathForItemAtPoint:mid];
            [self.activeCollectionView scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
        }
        [self.activeCollectionView.collectionViewLayout invalidateLayout];
    } else {
        //[self.activeCollectionView reloadData];
    }
}

#pragma mark - Collection View Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.activeCollectionViewObjects.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.activeCollectionViewObjects.count > section) {
        NSArray *array = self.activeCollectionViewObjects[section];
        return array.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VenueLayoutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kVenueLayoutCellReuseIdentifier forIndexPath:indexPath];
    if (self.activeCollectionViewObjects.count > indexPath.section) {
        NSArray *rows = self.activeCollectionViewObjects[indexPath.section];
        if (rows.count > indexPath.row) {
            if ([rows[indexPath.row] isKindOfClass:[VenueLayoutCellObject class]]) {
                VenueLayoutCellObject *object = rows[indexPath.row];
                cell.cellObject = object;
                
            }
        }
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    CGFloat widthAndHeight = self.widthAndHeightForActiveCollectionView;
    CGFloat result = lroundf(widthAndHeight * self.venueLayoutZoom);
    CGFloat width = result;
    if (indexPath.row > self.increasedWidthInitialIndex) {
        width++;
    }
    //return CGSizeMake(widthAndHeight * self.venueLayoutZoom, widthAndHeight * self.venueLayoutZoom);
    return CGSizeMake(width, result);
}

@end
