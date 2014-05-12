//
//  AtomAppViewController.m
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import "AtomAppViewController.h"
#import "System.h"
#import <AVFoundation/AVFoundation.h>

@interface AtomAppViewController ()
@property (strong, nonatomic) System *atomSystem;
@property (strong, nonatomic) NSMutableArray *atomCoordinateInputArray;
@end

@implementation AtomAppViewController



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
    //update steps executed
    [[self stepsExecutedField] setIntegerValue:[self.stepsExecutedField integerValue] + [_numberOfStepsField integerValue]];
    
    NSLog(@"Executed %ld steps! \n", [_stepsExecutedField integerValue]);
    
    [self updateUI];
    
    [self writeSystemInfoToFile];
    
    [self runBtnPushed:(NSButton *)sender];
    
    
}

- (IBAction)initializeBtnPushed:(NSButton *)sender {
    
    [self readFile];
    
    if ([self atomSystem]) {
        NSLog(@"Initialization sequence succeeded with %ld atoms !\n\n", [_atomSystem.atomsArray count]);
        
    } else {
        NSLog(@"Initialization sequence failed! \n");
    }
    
    [self initAtomNumberBtn];
    [self updateUI];
    
    //disable this init button
    [[self initializeBtn] setEnabled:NO];
    [[self runBtn] setEnabled:YES];
    [[self resetBtn] setEnabled:YES];
    [_atomNumberBtn setEnabled:YES];
    [[self numberOfStepsField] setEnabled:YES];
    [[self numberOfStepsField] setIntegerValue:0];
    [[self stepsExecutedField] setIntegerValue:0];
    
    
}

- (IBAction)resetBtnPushed:(NSButton *)sender {
    
    
    _atomSystem = nil;
    
    [[self initializeBtn] setEnabled:YES];
    [[self runBtn] setEnabled:NO];
    [[self stepsExecutedField] setIntegerValue:0];
    [[self numberOfStepsField] setStringValue:@""];
    [[self numberOfStepsField] setEnabled:NO];
    [[self resetBtn] setEnabled:NO];
    [[self atomNumberBtn] removeAllItems];
    [self updateUI];

    NSLog(@"\nReseting sequence completed!\n\n");
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
    
    //NSLog(@"Atom %ld selected! \n", indexOfAtom);
    
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
    [_atomKineticEnergyField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] atomKineticEnergy]];
    [_atomTempratureField setDoubleValue:[[[_atomSystem atomsArray] objectAtIndex:indexOfAtom] atomTemprature]];
}

- (void)readFile
{
    NSString *inputString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lj" ofType:nil] encoding:NSASCIIStringEncoding error:nil];
    
    NSArray *inputArray = [inputString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];

    _atomCoordinateInputArray = [[NSMutableArray alloc] initWithCapacity:[inputArray count] / 3];
    
    for (int i = 0; i < [inputArray count] / 3; i++) {
        
        double x = [[inputArray objectAtIndex:i] doubleValue] * 0.1;
        double y = [[inputArray objectAtIndex:i + 512] doubleValue] * 0.1;
        double z = [[inputArray objectAtIndex:i + 512 * 2] doubleValue] * 0.1;
        
        NSArray *anAtomCoordinate = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:x],[NSNumber numberWithDouble:y], [NSNumber numberWithDouble:z], nil];
        
        [_atomCoordinateInputArray addObject:anAtomCoordinate];
        
    }
    
}

- (NSButton *)resetBtn
{
    if (_resetBtn) {
        NSColor *color = [NSColor redColor];
        
        NSMutableAttributedString *colorTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[_resetBtn attributedTitle]];
        NSRange titleRange = NSMakeRange(0, [colorTitle length]);
        
        [colorTitle addAttribute:NSForegroundColorAttributeName value:color range:titleRange];
        
        [_resetBtn setAttributedTitle:colorTitle];
    }
    
    return _resetBtn;
}

#pragma mark - write log to file

//export system info to a log file
-(void) writeSystemInfoToFile
{
    
    NSString *content = [NSString stringWithFormat:@"%ld\t%lf\t%lf\t%lf\t%lf\n", [_stepsExecutedField integerValue], [_potentialEnergyField doubleValue], [_kineticEnergyField doubleValue], [_totalEnergyField doubleValue], [_totalTempratureField doubleValue]];
    
    //get the documents directory:
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Desktop"];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"SystemLog.txt"];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
    
    //if SystemLog.txt is existed, append to it, otherwise create the file
    if (fileHandle){
        [fileHandle seekToEndOfFile];
        [fileHandle writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandle closeFile];
    }
    else{
        [content writeToFile:fileName
                  atomically:NO
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
    }
}

@end
