//
//  AtomAppViewController.h
//  Song
//
//  Created by Mac Wang on 5/7/14.
//  Copyright (c) 2014 Kansas State University. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AtomAppViewController : NSViewController

@property (weak) IBOutlet NSTextField *potentialEnergyField;
@property (weak) IBOutlet NSTextField *kineticEnergyField;
@property (weak) IBOutlet NSTextField *totalEnergyField;
@property (weak) IBOutlet NSTextField *totalTempratureField;

@property (weak) IBOutlet NSTextField *stepsExecutedField;

@property (weak) IBOutlet NSPopUpButton *atomNumberBtn;
- (IBAction)atomNumberBtnPushed:(NSPopUpButton *)sender;

@property (weak) IBOutlet NSTextField *coordinateXField;
@property (weak) IBOutlet NSTextField *coordinateYField;
@property (weak) IBOutlet NSTextField *coordinateZField;

@property (weak) IBOutlet NSTextField *velocityXField;
@property (weak) IBOutlet NSTextField *velocityYField;
@property (weak) IBOutlet NSTextField *velocityZField;

@property (weak) IBOutlet NSTextField *forceXField;
@property (weak) IBOutlet NSTextField *forceYField;
@property (weak) IBOutlet NSTextField *forceZField;


@property (weak) IBOutlet NSTextField *atomKineticEnergyField;

@property (weak) IBOutlet NSTextField *numberOfStepsField;

@property (weak) IBOutlet NSButton *runBtn;
- (IBAction)runBtnPushed:(NSButton *)sender;


- (IBAction)initializeBtnPushed:(NSButton *)sender;
@property (weak) IBOutlet NSButton *initializeBtn;
@property (weak, nonatomic) IBOutlet NSButton *resetBtn;
- (IBAction)resetBtnPushed:(NSButton *)sender;

@end
