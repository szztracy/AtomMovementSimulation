//
//  AtomAppViewController.m
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import "AtomAppViewController.h"
#import "System.h"

@interface AtomAppViewController ()
@property (strong, nonatomic) System *atomSystem;
@property (strong, nonatomic) NSArray *atomCoordinateInputArray;
@end

@implementation AtomAppViewController

#pragma mark - test input
double Atom0X = -19.934;
double Atom0Y = -16.679;
double Atom0Z = -13.492;
double Atom1X = -4.623;
double Atom1Y = 10.388;
double Atom1Z = -16.936;
double Atom2X = -7.584;
double Atom2Y = 11.509;
double Atom2Z = 4.949;

#pragma mark - init methods
- (System *)atomSystem
{
    if (!_atomSystem) {
        _atomSystem = [[System alloc] initWithAtomCoordinateArray:_atomCoordinateInputArray];
    }
    return _atomSystem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


#pragma mark - button methods
- (IBAction)atomNumberBtnPushed:(NSPopUpButton *)sender {
    
    [self updateUI];

}

- (IBAction)runBtnPushed:(NSButton *)sender {
    [_atomSystem proceedWithNumberOfSteps:[_numberOfStepsField integerValue]];
    [self updateUI];
}

- (IBAction)initializeBtnPushed:(NSButton *)sender {
    
    //temprorily input coordinate here
    NSArray *inputValuesOfAtom0 = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:Atom0X], [NSNumber numberWithDouble:Atom0Y], [NSNumber numberWithDouble:Atom0Z], nil];
    NSArray *inputValuesOfAtom1 = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:Atom1X], [NSNumber numberWithDouble:Atom1Y], [NSNumber numberWithDouble:Atom1Z], nil];
    NSArray *inputValuesOfAtom2 = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:Atom2X], [NSNumber numberWithDouble:Atom2Y], [NSNumber numberWithDouble:Atom2Z], nil];
    _atomCoordinateInputArray = [[NSArray alloc] initWithObjects:inputValuesOfAtom0, inputValuesOfAtom1, inputValuesOfAtom2, nil];
    
    if ([self atomSystem]) {
        NSLog(@"Initialization sequence succeeded with %ld atoms !\n", [_atomSystem.atomsArray count]);
        
    } else {
        NSLog(@"Initialization sequence failed! \n");
    }
    
    [self initAtomNumberBtn];
    
}



#pragma mark - aux methods
- (void)initAtomNumberBtn
{
    
    //use an array to list all the atom ID's
    NSMutableArray *atomNumberArray = [[NSMutableArray alloc] initWithCapacity:_atomSystem.numberOfAtoms];
    
    for (int i = 0; i < _atomSystem.numberOfAtoms; i++) {
        NSString *atomId = [NSString stringWithFormat:@"Atom %ld", [[_atomSystem.atomsArray objectAtIndex:i] atomId]];
        [atomNumberArray addObject:atomId];
    }
    
    [self.atomNumberBtn removeAllItems];
    
    [self.atomNumberBtn addItemsWithTitles:atomNumberArray];
}

- (void)updateUI
{
    //update system info
    [_potentialEnergyField setDoubleValue:[_atomSystem systemPotentialEnergy]];
    [_kineticEnergyField setDoubleValue:[_atomSystem systemKineticEnergy]];
    [_totalEnergyField setDoubleValue:[_atomSystem systemTotalEnergy]];
    [_totalTempratureField setDoubleValue:[_atomSystem systemTemprature]];
    
    //update atom info
    NSInteger indexOfAtom = [_atomNumberBtn indexOfSelectedItem];
    NSLog(@"Atom %ld selected! \n", indexOfAtom);
    //display coordinate info
    [_coordinateXField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] coordinateX]];
    [_coordinateYField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] coordinateY]];
    [_coordinateZField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] coordinateZ]];
    //display velocity info
    [_velocityXField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] velocityX]];
    [_velocityYField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] velocityY]];
    [_velocityZField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] velocityZ]];
    //diplay force info
    [_forceXField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] forceX]];
    [_forceYField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] forceY]];
    [_forceZField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] forceZ]];
    //display energy info
    [_atomPotentialEnergyField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] atomPotentialEnergy]];
    [_atomKineticEnergyField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] atomKineticEnergy]];
    
}
@end