//
//  System.h
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Atom.h"

@interface System : NSObject

//store all the atoms
@property (strong, nonatomic) NSMutableArray *atomsArray;
@property (nonatomic) NSInteger numberOfAtoms;
//properties of this system
@property (nonatomic) double systemPotentialEnergy;
@property (nonatomic) double systemKineticEnergy;
@property (nonatomic) double systemTotalEnergy;
@property (nonatomic) double systemTemprature;

//initilize with coordination array of atoms (hopefully could implement a file parser later)
-(instancetype)initWithAtomCoordinateArray:(NSArray *)atomCoordinateInputArray;

//execute for certain steps, e.g. 50
-(void)proceedWithNumberOfSteps:(NSUInteger)numberOfSteps;





@end
