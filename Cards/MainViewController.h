//
//  MainViewController.h
//  Cards
//
//  Created by Buffalo Hird on 8/20/12.
//  Copyright (c) 2012 Buffalo Hird. All rights reserved.
//

#import "FlipsideViewController.h"

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "Card.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSString *deckChoice;
@property (strong, nonatomic) NSMutableArray *cardsArray;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *drawButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *GameButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cardCounterLabel;
@property (nonatomic) int cardCounter;
@property (nonatomic) int cardMax;
@property (nonatomic) BOOL endBool;
@property (nonatomic) BOOL toggleBool;
@property (nonatomic) BOOL shuffleBool;
@property (strong, nonatomic) IBOutlet UIImageView *cardView;
@property (strong, nonatomic) IBOutlet UIImageView *nextCardView;
@property (strong, nonatomic) IBOutlet UIImageView *secondCardView;
@property (strong, nonatomic) IBOutlet UIImageView *thirdCardView;
@property (strong, nonatomic) IBOutlet UIImageView *cardContainer;
@property (strong, nonatomic) IBOutlet UIImageView *tapCenterView;
@property (strong, nonatomic) IBOutlet UINavigationBar *topBar;
@property (strong, nonatomic) IBOutlet UIToolbar *bottomBar;
@property (strong, nonatomic) UIImage *previousCardImage;
@property (nonatomic) int shuffleCounter;
@property (strong, nonatomic) NSTimer *shuffleTimer;
@property (nonatomic) BOOL fiveBool;


- (IBAction)newGame;
- (IBAction)drawCard;
- (void)animateCard:(int)direction;
- (void)shuffleCard;
- (void)toggleBars;
@end
