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

//half velocity change
- (void)halfVelocityChangeOfAnAtom:(Atom *)thisAtom;

//velocity change
- (void)velocityChangeOfAnAtom:(Atom *)thisAtom;

//force change
- (void)forceChangeOfAnAtom:(Atom *)thisAtom;

//accelaration change
- (void)accelerationChangeOfAnAtom:(Atom *)thisAtom;

@end

@implementation System

#pragma mark - Constants
double timeSlice = 2.0; //of each time stamp ?measurement
double bigSigma = 1.0; //kJ/mol
double littleSigma = 0.3; //nm
double edgeLength = 4.0; //nm
double cutoffDistance = 1.5; //nm
double atomMass = 10.0; //amu = 1.66053892E-27 kg


#pragma mark - Initialization Methods
- (instancetype)initWithAtomCoordinateArray:(NSArray *)atomCoordinateInputArray
{
    self = [super init];
    
    if (self) {

        _atomsArray = [[NSMutableArray alloc] initWithCapacity:[atomCoordinateInputArray count]];
        
        for (int i = 0; i < [atomCoordinateInputArray count]; i++) {
            
            double x = [[[atomCoordinateInputArray objectAtIndex:i] objectAtIndex:xValue] doubleValue];
            double y = [[[atomCoordinateInputArray objectAtIndex:i] objectAtIndex:yValue] doubleValue];
            double z = [[[atomCoordinateInputArray objectAtIndex:i] objectAtIndex:zValue] doubleValue];
            
            
            [_atomsArray insertObject:[[Atom alloc] initAtom:i WithCoordinateX:x Y:y Z:z] atIndex:i];
            
        };
        
        for (int i = 0; i < [atomCoordinateInputArray count]; i++) {
            
            [self forceChangeOfAnAtom:[_atomsArray objectAtIndex:i]];
            
        }
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


#pragma mark - Critical Changing Sequence v1
//1. coordinate change
/*
 - (void)coordinateChangeOfAnAtom:(Atom *)thisAtom
{
    //cache coordinate data to prevent replacing by coordinate change method
    _lastCoordinateCache = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithDouble:thisAtom.coordinateX], [NSNumber numberWithDouble:thisAtom.coordinateY], [NSNumber numberWithDouble:thisAtom.coordinateZ],nil];
    
    thisAtom.coordinateX = 2 * thisAtom.coordinateX - thisAtom.lastCoordinateX + thisAtom.accelerationX * timeSlice * timeSlice;
    thisAtom.coordinateY = 2 * thisAtom.coordinateY - thisAtom.lastCoordinateY + thisAtom.accelerationY * timeSlice * timeSlice;
    thisAtom.coordinateZ = 2 * thisAtom.coordinateZ - thisAtom.lastCoordinateZ + thisAtom.accelerationZ * timeSlice * timeSlice;
    
    //NSLog(@"Coordinate change of Atom [%ld] completed!", (long)thisAtom.atomId);
    
    thisAtom.lastCoordinateX = [[_lastCoordinateCache objectAtIndex:xValue] doubleValue];
    thisAtom.lastCoordinateY = [[_lastCoordinateCache objectAtIndex:yValue] doubleValue];
    thisAtom.lastCoordinateZ = [[_lastCoordinateCache objectAtIndex:zValue] doubleValue];
}
 */

//2. force change
/*
- (void)forceChangeOfAnAtom:(Atom *)thisAtom
{
    for (int i = 0; i < [self.atomsArray count]; i++) {
        if (i != thisAtom.atomId) {
            
            NSArray *forceChange = [self forceBetweenAnAtom:thisAtom andTheOtherAtom:[self.atomsArray objectAtIndex:i]];
            
            double forceChangeX = [[forceChange objectAtIndex:xValue] doubleValue];
            double forceChangeY = [[forceChange objectAtIndex:yValue] doubleValue];
            double forceChangeZ = [[forceChange objectAtIndex:zValue] doubleValue];
            
            NSLog(@"force changed on x: %f", forceChangeX);
            
            [thisAtom changeForceX:forceChangeX Y:forceChangeY Z:forceChangeZ];
        }
    }
    
    //NSLog(@"Force change of atom %ld completed!", (long)thisAtom.atomId);
}
 */

//3. accelaration change
/*
- (void)accelerationChangeOfAnAtom:(Atom *)thisAtom
{
    double accelerationX = thisAtom.forceX /atomMass;
    double accelerationY = thisAtom.forceY /atomMass;
    double accelerationZ = thisAtom.forceZ /atomMass;
    
    [thisAtom setAccelerationX:accelerationX];
    [thisAtom setAccelerationY:accelerationY];
    [thisAtom setAccelerationZ:accelerationZ];
    
    //NSLog(@"Acceleration change of Atom [%ld] completed!", (long)thisAtom.atomId);
}
*/

//4. velocity change
/*
- (void)velocityChangeOfAnAtom:(Atom *)thisAtom
{
    double velocityX = (thisAtom.coordinateX - thisAtom.lastCoordinateX) / (2 * timeSlice);
    double velocityY = (thisAtom.coordinateY - thisAtom.lastCoordinateY) / (2 * timeSlice);
    double velocityZ = (thisAtom.coordinateZ - thisAtom.lastCoordinateZ) / (2 * timeSlice);
    
    [thisAtom setVelocityX:velocityX];
    [thisAtom setVelocityY:velocityY];
    [thisAtom setVelocityZ:velocityZ];
    
    //NSLog(@"Velocity change of Atom [%ld] completed!", (long)thisAtom.atomId);

    
}
 */


#pragma mark - Critical Changing Sequence v2
//1. Velocity Change
- (void)halfVelocityChangeOfAnAtom:(Atom *)thisAtom
{
    thisAtom.halfVelocityX = thisAtom.velocityX + thisAtom.accelerationX * timeSlice / 2.0;
    thisAtom.halfVelocityY = thisAtom.velocityY + thisAtom.accelerationY * timeSlice / 2.0;
    thisAtom.halfVelocityZ = thisAtom.velocityZ + thisAtom.accelerationZ * timeSlice / 2.0;
    
}

//2. Coordinate Change
- (void)coordinateChangeOfAnAtom:(Atom *)thisAtom
{
    thisAtom.coordinateX = thisAtom.coordinateX + thisAtom.halfVelocityX * timeSlice;
    thisAtom.coordinateY = thisAtom.coordinateY + thisAtom.halfVelocityY * timeSlice;
    thisAtom.coordinateZ = thisAtom.coordinateZ + thisAtom.halfVelocityZ * timeSlice;
}


//3. Force Change
- (void)forceChangeOfAnAtom:(Atom *)thisAtom
{
    thisAtom.forceX = 0.0;
    thisAtom.forceY = 0.0;
    thisAtom.forceZ = 0.0;
    
    for (int i = 0; i < [self.atomsArray count]; i++) {
        if (i != thisAtom.atomId) {
            
            NSArray *forceChange = [self forceBetweenAnAtom:thisAtom andTheOtherAtom:[self.atomsArray objectAtIndex:i]];
            
            double forceChangeX = [[forceChange objectAtIndex:xValue] doubleValue];
            double forceChangeY = [[forceChange objectAtIndex:yValue] doubleValue];
            double forceChangeZ = [[forceChange objectAtIndex:zValue] doubleValue];
            
            
            [thisAtom changeForceX:forceChangeX Y:forceChangeY Z:forceChangeZ];
            
        }
    }
    
    //NSLog(@"Force change of atom %ld completed!", (long)thisAtom.atomId);
}

//4. Acceleration Change
- (void)accelerationChangeOfAnAtom:(Atom *)thisAtom
{
    double accelerationX = thisAtom.forceX /atomMass;
    double accelerationY = thisAtom.forceY /atomMass;
    double accelerationZ = thisAtom.forceZ /atomMass;
    
    [thisAtom setAccelerationX:accelerationX];
    [thisAtom setAccelerationY:accelerationY];
    [thisAtom setAccelerationZ:accelerationZ];
    
    //NSLog(@"Acceleration change of Atom [%ld] completed!", (long)thisAtom.atomId);
}

//5. Velocity Change
- (void)velocityChangeOfAnAtom:(Atom *)thisAtom
{
    thisAtom.velocityX = thisAtom.halfVelocityX + thisAtom.accelerationX * timeSlice / 2.0;
    thisAtom.velocityY = thisAtom.halfVelocityY + thisAtom.accelerationY * timeSlice / 2.0;
    thisAtom.velocityZ = thisAtom.halfVelocityZ + thisAtom.accelerationZ * timeSlice / 2.0;
}



#pragma mark - proceed method

- (void)proceedWithNumberOfSteps:(NSUInteger)numberOfSteps
{
    for (int steps = 0; steps < numberOfSteps; steps++) {
        
        //iterate through every atom
        for (int i = 0; i < [self.atomsArray count]; i++) {
            [self halfVelocityChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
            [self coordinateChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
        };
        for (int i = 0; i < [self.atomsArray count]; i++) {
            [self forceChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
            [self accelerationChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
            [self velocityChangeOfAnAtom:[self.atomsArray objectAtIndex:i]];
        }
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
    double dx;
    double dy;
    double dz;
    
    if (fabs(otherAtom.coordinateX - anAtom.coordinateX) > (edgeLength / 2.0)) {
        dx = edgeLength - fabs(otherAtom.coordinateX - anAtom.coordinateX);
        //NSLog(@"Distance x between Atom [%ld] and Atom [%ld] is altered!", anAtom.atomId, otherAtom.atomId);
    } else {
        dx = fabs(otherAtom.coordinateX - anAtom.coordinateX);
    }
    
    
    if (fabs(otherAtom.coordinateY - anAtom.coordinateY) > (edgeLength / 2.0)) {
        dy = edgeLength - fabs(otherAtom.coordinateY - anAtom.coordinateY);
        //NSLog(@"Distance y between Atom [%ld] and Atom [%ld] is altered!", anAtom.atomId, otherAtom.atomId);

    } else {
        dy = fabs(otherAtom.coordinateY - anAtom.coordinateY);
    }
    
    if (fabs(otherAtom.coordinateZ - anAtom.coordinateZ) > (edgeLength / 2.0)) {
        dz = edgeLength - fabs(otherAtom.coordinateZ - anAtom.coordinateZ);
        //NSLog(@"Distance z between Atom [%ld] and Atom [%ld] is altered!", anAtom.atomId, otherAtom.atomId);

    } else {
        dz = fabs(otherAtom.coordinateZ - anAtom.coordinateZ);
    }

    
    
    //double dx = (fabs(otherAtom.coordinateX - anAtom.coordinateX) > (edgeLength / 2)) ? (fabs(otherAtom.coordinateX - anAtom.coordinateX) - edgeLength) : fabs(otherAtom.coordinateX - anAtom.coordinateX);
    //double dy = (fabs(otherAtom.coordinateY - anAtom.coordinateY) > (edgeLength / 2)) ? (fabs(otherAtom.coordinateY - anAtom.coordinateY) - edgeLength) : fabs(otherAtom.coordinateY - anAtom.coordinateY);
    //double dz = (fabs(otherAtom.coordinateZ - anAtom.coordinateZ) > (edgeLength / 2)) ? (fabs(otherAtom.coordinateZ - anAtom.coordinateZ) - edgeLength) : fabs(otherAtom.coordinateZ - anAtom.coordinateZ);
    
    double r = sqrt(pow(dx, 2.0) + pow(dy, 2.0) + pow(dz, 2.0));
    
    //NSLog(@"Distance between Atom %ld and Atom %ld is %f. \n", anAtom.atomId, otherAtom.atomId, r);
    
    return r;
}

- (double)potentialEnergyBetweenAnAtom:(Atom *)anAtom andTheOtherAtom:(Atom *)otherAtom
{
    double r = [self distanceBetweenAnAtom:anAtom andTheOtherAtom:otherAtom];
    return 4.0 * bigSigma * (pow(littleSigma / r, 12) - pow(littleSigma / r, 6));
}

- (double)potentialEnergyOfAtomAtIndex:(NSInteger)indexOfAtom
{
    double potentialEnergyOfAtom = 0.0;
    
    for (NSInteger i = indexOfAtom + 1; i < [_atomsArray count]; i++) {
        potentialEnergyOfAtom = potentialEnergyOfAtom + [self potentialEnergyBetweenAnAtom:[_atomsArray objectAtIndex:indexOfAtom] andTheOtherAtom:[_atomsArray objectAtIndex:i]];
    }
    
    return potentialEnergyOfAtom;
}

#pragma mark - getter
- (double)systemKineticEnergy
{
    
    _systemKineticEnergy = 0.0;
    
    for (int i = 0; i < [_atomsArray count]; i++) {
        _systemKineticEnergy = _systemKineticEnergy + [[_atomsArray objectAtIndex:i] atomKineticEnergy];
    }
    
    return _systemKineticEnergy;
}

- (double)systemPotentialEnergy
{
    _systemPotentialEnergy = 0.0;
    
    for (int i = 0; i < [_atomsArray count]; i++) {
        _systemPotentialEnergy =  _systemPotentialEnergy+ [self potentialEnergyOfAtomAtIndex:i];
    }
    
    return _systemPotentialEnergy;
}

- (double)systemTotalEnergy
{
    
    _systemTotalEnergy = _systemPotentialEnergy + _systemKineticEnergy;
    
    return _systemTotalEnergy;
}

- (double)systemTemprature
{
    _systemTemprature = 0.0;
    
    for (int i = 0; i < [_atomsArray count]; i++) {
        _systemTemprature = _systemTemprature + [[_atomsArray objectAtIndex:i] atomTemprature];
    }
    
    return _systemTemprature;
}


@end
