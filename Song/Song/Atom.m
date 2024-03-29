//
//  Atom.m
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import "Atom.h"
#import <math.h>

@implementation Atom

#pragma mark - Constants
double anAtomMass = 10.0; //amu = 1.66053892E-27 kg
double N = 6.02214129e23; //mol^-1
double kB = 1.3806488e-23; //J/K
double boxEdgeLength = 4.0; //nm

#pragma mark - init method

- (instancetype)initAtom:(NSInteger)atomId WithCoordinateX:(double)coordinateX Y:(double)coordinateY Z:(double)coordinateZ
{
    self = [super init];
    
    if (self) {
        _coordinateX = coordinateX;
        _coordinateY = coordinateY;
        _coordinateZ = coordinateZ;
        _atomId = atomId;
    }
    
    NSLog(@"Atom %ld created! \n", self.atomId);
    return self;
}


//return an NSNumber array of coordinate info
-(NSArray *)coordinate
{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:self.coordinateX], [NSNumber numberWithDouble:self.coordinateY], [NSNumber numberWithDouble:self.coordinateZ], nil];
}

//set coordinate info and return an NSNumber array
-(NSArray *)setCoordinateX:(float)coordinateX Y:(float)coordinateY Z:(float)coordinateZ;
{
    self.coordinateX = coordinateX;
    self.coordinateY = coordinateY;
    self.coordinateZ = coordinateZ;
    
    return [self coordinate];
}

//return an NSNumber array of velocity info
-(NSArray *)velocity
{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:self.velocityX], [NSNumber numberWithDouble:self.velocityY], [NSNumber numberWithDouble:self.velocityZ], nil];
}

//set velocity info and return an NSNumber array
-(NSArray *)setVelocityX:(float)velocityX Y:(float)velocityY Z:(float)velocityZ;
{
    self.velocityX = velocityX;
    self.velocityY = velocityY;
    self.velocityZ = velocityZ;
    
    return [self velocity];
}

//return an NSNumber array of force info
-(NSArray *)force
{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:self.forceX], [NSNumber numberWithDouble:self.forceY], [NSNumber numberWithDouble:self.forceZ], nil];
}

//set force info and return an NSNumber array
-(NSArray *)setForceX:(float)forceX Y:(float)forceY Z:(float)forceZ
{
    self.forceX = forceX;
    self.forceY = forceY;
    self.forceZ = forceZ;
    
    return [self force];
}

//change force by adding forceChange values to each dimention
//add forceChange values to the current values
-(NSArray *)changeForceX:(float)forceChangeX Y:(float)forceChangeY Z:(float)forceChangeZ
{

    self.forceX = self.forceX + forceChangeX;
    self.forceY = self.forceY + forceChangeY;
    self.forceZ = self.forceZ + forceChangeZ;
    
    return [self force];
}

//return an NSNumber array of acceleration info
-(NSArray *)acceleration
{
    return [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:self.accelerationX], [NSNumber numberWithDouble:self.accelerationY], [NSNumber numberWithDouble:self.accelerationZ], nil];
}

//set acceleration info and return an NSNumber array
-(NSArray *)setAccelerationX:(float)accelerationX Y:(float)accelerationY Z:(float)accelerationZ
{
    self.accelerationX = accelerationX;
    self.accelerationY = accelerationY;
    self.accelerationZ = accelerationZ;
    
    return [self acceleration];
}

-(double)atomKineticEnergy
{
    _atomKineticEnergy = 0.5 * anAtomMass * (pow(self.velocityX, 2) + pow(self.velocityY, 2) + pow(self.velocityZ, 2));
    
    return _atomKineticEnergy;
}

-(double)atomTemprature
{
    _atomTemprature = anAtomMass * sqrt (pow(_velocityX, 2) + pow(_velocityY, 2) + pow(_velocityZ, 2)) / ((3.0 * N - 3) *kB);
    
    return _atomTemprature;
}

-(double)accelerationX
{
    return _forceX / anAtomMass;
}

-(double)accelerationY
{
    return _forceY / anAtomMass;
}

-(double)accelerationZ
{
    return _forceZ / anAtomMass;
}

//setter of coordinate values

-(void)setCoordinateX:(double)coordinateX
{
    if (coordinateX > boxEdgeLength) {
        _coordinateX = coordinateX - boxEdgeLength;
    } else {
        _coordinateX = coordinateX;
    }
    
}

-(void)setCoordinateY:(double)coordinateY
{
    if (coordinateY > boxEdgeLength) {
        _coordinateY = coordinateY - boxEdgeLength;
    } else {
        _coordinateY = coordinateY;
    }
}

-(void)setCoordinateZ:(double)coordinateZ
{
    if (coordinateZ > boxEdgeLength) {
        _coordinateZ = coordinateZ - boxEdgeLength;
    } else {
        _coordinateZ = coordinateZ;
    }
}



@end
