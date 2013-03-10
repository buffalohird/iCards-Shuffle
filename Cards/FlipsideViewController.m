//
//  FlipsideViewController.m
//  Cards
//
//  Created by Buffalo Hird on 8/20/12.
//  Copyright (c) 2012 Buffalo Hird. All rights reserved.
//

#import "FlipsideViewController.h"

#define DECKTYPE1 @""
#define DECKTYPE2 @"b-"
#define DECKTYPE3 @"c-"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

@synthesize deckNumber = _deckNumber;
@synthesize deckType = _deckType;
@synthesize deckShuffle = _deckShuffle;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // register default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // load saved game mode into segmented control
    self.deckNumber.selectedSegmentIndex = [[defaults stringForKey:@"decks"] intValue] - 1;
    
    NSString *selectedDeckType = [NSString stringWithFormat:@"%@", [defaults stringForKey:@"type"]];
    if([selectedDeckType isEqualToString: DECKTYPE1])
        self.deckType.selectedSegmentIndex = 0;
    else if([selectedDeckType isEqualToString: DECKTYPE2])
        self.deckType.selectedSegmentIndex = 1;
    else if([selectedDeckType isEqualToString: DECKTYPE3])
        self.deckType.selectedSegmentIndex = 2;
    //else
        //NSLog(@"deckType segment default error: %@", selectedDeckType);
    
    self.deckShuffle.selectedSegmentIndex = [[defaults stringForKey:@"shuffle"]intValue];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)deckNumberChange:(id)sender
{
    
    // save value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", self.deckNumber.selectedSegmentIndex + 1] forKey:@"decks"];
    [defaults synchronize];
    
    
}

- (IBAction)deckTypeChange:(id)sender
{
    // save value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    int selectedDeckIndex = self.deckType.selectedSegmentIndex;
    NSString *selectedDeckType = [[NSString alloc] init];
    if(selectedDeckIndex == 0)
        selectedDeckType = DECKTYPE1;
    else if(selectedDeckIndex == 1)
        selectedDeckType = DECKTYPE2;
    else if(selectedDeckIndex == 2)
        selectedDeckType = DECKTYPE3;
    //else
        //NSLog(@"deckType setting error: %@", selectedDeckType);
    
    [defaults setObject:[NSString stringWithFormat:@"%@", selectedDeckType] forKey:@"type"];
    [defaults synchronize];
    
    
}

- (IBAction)deckShuffleChange:(id)sender
{
    
    // save value
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%d", self.deckShuffle.selectedSegmentIndex] forKey:@"shuffle"];
    [defaults synchronize];
    
    
}

@end
