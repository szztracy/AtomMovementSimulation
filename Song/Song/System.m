//
//  System.m
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import "System.h"
#import <Math.h>

//to use in arrays
#define xValue 0
#define yValue 1
#define zValue 2

@interface System()

//last coordinate cache
@property (strong, nonatomic) NSMutableArray *lastCoordinateCache;
//coordinate change
- (void)coordinateChangeOfAnAtom:(Atom *)thisAtom;

//velocity change
- (void)velocityChangeOfAnAtom:(Atom *)thisAtom;

//force change
- (void)forceChangeOfAnAtom:(Atom *)thisAtom;

//accelaration change
- (void)accelerationChangeOfAnAtom:(Atom *)thisAtom;

@end

@implementation System

#pragma mark - Constants
NSInteger timeSlice = 1; //of each time stamp ?measurement
double bigSigma = 1.0; //kJ/mol
double littleSigma = 0.3; //nm
double edgeLength = 2.0; //nm
double cutoffDistance = 1.5; //nm
double atomMass; //amu = 1.66053892E-27 kg


#pragma mark - Initialization Methods
- (instancetype)initWithAtomCoordinateArray:(NSArray *)atomCoordinateInputArray
{
    self = [super init];
    
    _atomsArray = [[NSMutableArray alloc] initWithCapacity:[atomCoordinateInputArray count]];
    
    if (self) {
        for (int i = 0; i < [atomCoordinateInputArray count]; i++) {
            
            double x = [[[atomCoordinateInputArray objectAtIndex:i] objectAtIndex:xValue] doubleValue];
            double y = [[[atomCoordinateInputArray objectAtIndex:i] objectAtIndex:yValue] doubleValue];
            double z = [[[atomCoordinateInputArray objectAtIndex:i] objectAtIndex:zValue] doubleValue];
            
            
            [_atomsArray addObject:[[Atom alloc] initAtom:i WithCoordinateX:x Y:y Z:z]];
            
        };
    }
    
    return self;
}

- (NSInteger)numberOfAtoms
{
    if (!_numberOfAtoms) {
        _numberOfAtoms = [_atomsArray count];
    }
    
    return _numberOfAtoms;
}


#pragma mark - Critical Changing Sequence
//1. coordinate change
- (void)coordinateChangeOfAnAtom:(Atom *)thisAtom
{
    //cache coordinate data to prevent replacing by coordinate change method
    _lastCoordinateCache = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:thisAtom.coordinateX], [NSNumber numberWithDouble:thisAtom.coordinateY], [NSNumber numberWithDouble:thisAtom.coordinateZ],nil];
    
    thisAtom.coordinateX = 2 * thisAtom.coordinateX - thisAtom.lastCoordinateX + thisAtom.accelerationX * timeSlice * timeSlice;
    thisAtom.coordinateY = 2 * thisAtom.coordinateY - thisAtom.lastCoordinateY + thisAtom.accelerationY * timeSlice * timeSlice;
    thisAtom.coordinateZ = 2 * thisAtom.coordinateZ - thisAtom.lastCoordinateZ + thisAtom.accelerationZ * timeSlice * timeSlice;
}

//2. force change
- (void)forceChangeOfAnAtom:(Atom *)thisAtom
{
    for (int i = 0; i < [self.atomsArray count]; i++) {
        if (i != thisAtom.atomId) {
            
            NSArray *forceChange = [self forceBetweenAnAtom:thisAtom andTheOtherAtom:[self.atomsArray objectAtIndex:i]];
            
            double forceChangeX = [[forceChange objectAtIndex:xValue] doubleValue];
            double forceChangeY = [[forceChange objectAtIndex:yValue] doubleValue];
            double forceChangeZ = [[forceChange objectAtIndex:zValue] doubleValue];
            
            [thisAtom changeForceX:forceChangeX Y:forceChangeY Z:forceChangeZ];
        }
    }
    
    NSLog(@"Force change of atom %ld completed!", (long)thisAtom.atomId);
}

//3. accelaration change
- (void)accelerationChangeOfAnAtom:(Atom *)thisAtom
{
    double accelerationX = thisAtom.forceX /atomMass;
    double accelerationY = thisAtom.forceY /atomMass;
    double accelerationZ = thisAtom.forceZ /atomMass;
    
    [thisAtom setAccelerationX:accelerationX];
    [thisAtom setAccelerationY:accelerationY];
    [thisAtom setAccelerationZ:accelerationZ];
}

//4. velocity change
- (void)velocityChangeOfAnAtom:(Atom *)thisAtom
{
    double velocityX = (thisAtom.coordinateX - thisAtom.lastCoordinateX) / (2 * timeSlice);
    double velocityY = (thisAtom.coordinateY - thisAtom.lastCoordinateY) / (2 * timeSlice);
    double velocityZ = (thisAtom.coordinateZ - thisAtom.lastCoordinateZ) / (2 * timeSlice);
    
    [thisAtom setVelocityX:velocityX];
    [thisAtom setVelocityY:velocityY];
    [thisAtom setVelocityZ:velocityZ];
    
    NSLog(@"Velocity change of Atom [%ld] completed!", (long)thisAtom.atomId);
}

#pragma mark - proceed method

- (void)proceedWithNumberOfSteps:(NSUInteger)numberOfSteps
{
    for (int steps = 0; steps < numberOfSteps; steps++) {
        
        //iterate through every atom
        for (int i = 0; i < [self.atomsArray count]; i++) {
            [self coordinateChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
            [self forceChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
            [self accelerationChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
            [self velocityChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
        };
    };
    
    NSLog(@"Executed %ld steps! \n", numberOfSteps);
}

#pragma mark - aux methods
//each force change
- (NSArray *)forceBetweenAnAtom:(Atom *)thisAtom andTheOtherAtom:(Atom *)otherAtom
{
    
    double r = [self distanceBetweenAnAtom:thisAtom andTheOtherAtom:otherAtom];
    
    NSArray *forceArray;
    
    if (r > cutoffDistance) { //put aside this atom if the distance is more than the cutoff
        forceArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:0.0], [NSNumber numberWithDouble:0.0], nil];
    } else {
        double x = (24 * bigSigma / pow(r, 2)) * (2 * pow(littleSigma / r, 12) - pow(littleSigma / r, 6)) * (otherAtom.coordinateX - thisAtom.coordinateX);
        double y = (24 * bigSigma / pow(r, 2)) * (2 * pow(littleSigma / r, 12) - pow(littleSigma / r, 6)) * (otherAtom.coordinateY - thisAtom.coordinateY);
        double z = (24 * bigSigma / pow(r, 2)) * (2 * pow(littleSigma / r, 12) - pow(littleSigma / r, 6)) * (otherAtom.coordinateZ - thisAtom.coordinateZ);
        
        forceArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:x], [NSNumber numberWithDouble:y], [NSNumber numberWithDouble:z], nil];
    }
    
    return forceArray;
    
}

//distance between two atoms
- (double)distanceBetweenAnAtom:(Atom *)anAtom andTheOtherAtom:(Atom *)otherAtom
{
    double dx = (fabs(otherAtom.coordinateX - anAtom.coordinateX) > (edgeLength / 2)) ? ((otherAtom.coordinateX - anAtom.coordinateX) - edgeLength) : (otherAtom.coordinateX - anAtom.coordinateX);
    double dy = (fabs(otherAtom.coordinateY - anAtom.coordinateY) > (edgeLength / 2)) ? ((otherAtom.coordinateY - anAtom.coordinateY) - edgeLength) : (otherAtom.coordinateY - anAtom.coordinateY);
    double dz = (fabs(otherAtom.coordinateZ - anAtom.coordinateZ) > (edgeLength / 2)) ? ((otherAtom.coordinateZ - anAtom.coordinateZ) - edgeLength) : (otherAtom.coordinateZ - anAtom.coordinateZ);
    
    return sqrt(pow(dx, 2.0) + pow(dy, 2.0) + pow(dz, 2.0));;
}



@end
