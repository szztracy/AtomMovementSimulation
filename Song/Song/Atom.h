//
//  Atom.h
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Atom : NSObject

@property (nonatomic) NSInteger atomId; //from 0 to 511
//coordinate
@property double coordinateX;
@property double coordinateY;
@property double coordinateZ;
//last coordinate
@property double lastCoordinateX;
@property double lastCoordinateY;
@property double lastCoordinateZ;
//velocity
@property double velocityX;
@property double velocityY;
@property double velocityZ;
//Force
@property double forceX;
@property double forceY;
@property double forceZ;
//last force
@property double lastForceX;
@property double lastForceY;
@property double lastForceZ;
//acceleration
@property double accelerationX;
@property double accelerationY;
@property double accelerationZ;
//getter and setter methods of properties
-(NSArray *)coordinate;
-(NSArray *)setCoordinateX:(float)coordinateX Y:(float)coordinateY Z:(float)coordinateZ;
-(NSArray *)velocity;
-(NSArray *)setVelocityX:(float)velocityX Y:(float)velocityY Z:(float)velocityZ;
-(NSArray *)force;
-(NSArray *)setForceX:(float)forceX Y:(float)forceY Z:(float)forceZ;
-(NSArray *)changeForceX:(float)forceChangeX Y:(float)forceChangeY Z:(float)forceChangeZ; //add forceChange values to the current values
-(NSArray *)acceleration;
-(NSArray *)setAccelerationX:(float)accelerationX Y:(float)accelerationY Z:(float)accelerationZ;
//energy
@property (nonatomic) double atomPotentialEnergy;
-(double)setAtomPotentialEnergy;
@property (nonatomic) double atomKineticEnergy;
@property (nonatomic) double atomTotalEnergy;
//initilization
-(instancetype)initAtom:(NSInteger)atomId WithCoordinateX:(double)coordinateX Y:(double)coordinateY Z:(double)coordinateZ;













@end
