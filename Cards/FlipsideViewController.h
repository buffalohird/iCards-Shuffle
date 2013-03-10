//
//  FlipsideViewController.h
//  Cards
//
//  Created by Buffalo Hird on 8/20/12.
//  Copyright (c) 2012 Buffalo Hird. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UISegmentedControl *deckNumber;
@property (strong, nonatomic) IBOutlet UISegmentedControl *deckType;
@property (strong, nonatomic) IBOutlet UISegmentedControl *deckShuffle;

- (IBAction)done:(id)sender;
- (IBAction)deckNumberChange:(id)sender;
- (IBAction)deckTypeChange:(id)sender;

@end
