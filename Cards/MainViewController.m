//
//  MainViewController.m
//  Cards
//
//  Created by Buffalo Hird on 8/20/12.
//  Copyright (c) 2012 Buffalo Hird. All rights reserved.
//

#import "MainViewController.h"

#define CARDWIDTH 306
#define CARDHEIGHT 400
#define SHUFFLEMAX 12


@interface MainViewController ()

@end

@implementation MainViewController

@synthesize cardsArray = _cardsArray;
@synthesize deckChoice = _deckChoice;
@synthesize drawButton = _drawButton;
@synthesize GameButton = _GameButton;
@synthesize cardCounterLabel = _cardCounterLabel;
@synthesize cardCounter = _cardCounter;
@synthesize cardMax = _cardMax;
@synthesize endBool = _endBool;
@synthesize toggleBool = _toggleBool;
@synthesize shuffleBool = _shuffleBool;
@synthesize cardView = _cardView;
@synthesize nextCardView = _nextCardView;
@synthesize secondCardView = _secondCardView;
@synthesize thirdCardView = _thirdCardView;
@synthesize cardContainer = _cardContainer;
@synthesize tapCenterView = _tapCenterView;
@synthesize topBar = _topBar;
@synthesize bottomBar = _bottomBar;
@synthesize previousCardImage = _previousCardImage;
@synthesize shuffleCounter = _shuffleCounter;
@synthesize shuffleTimer = _shuffleTimer;
@synthesize fiveBool = fiveBool;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.height == 568) {
        self.fiveBool = YES;
    } else {
        self.fiveBool = NO;
    }
    
    
    NSMutableDictionary *defaultValues = [[NSMutableDictionary alloc] init];
    [defaultValues setObject:@"1" forKey:@"decks"];
    [defaultValues setObject:@"" forKey:@"type"];
    [defaultValues setObject:@"0" forKey:@"shuffle"];
    
    // register default
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:defaultValues];
    
    self.cardsArray = [[NSMutableArray alloc] initWithObjects: nil];
    self.toggleBool = YES;
        
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(drawCard)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGesture];
    
    self.cardContainer = [[UIImageView alloc] init];
    self.cardContainer.frame = CGRectMake(7.0, 34.0, CARDWIDTH, CARDHEIGHT);
    self.cardContainer.backgroundColor = [UIColor whiteColor];
    self.cardContainer.userInteractionEnabled = YES;
    
    self.cardContainer.layer.shadowColor = [UIColor blackColor].CGColor;
    self.cardContainer.layer.shadowOffset = CGSizeMake(-3.0, -4.0);
    self.cardContainer.layer.shadowOpacity = 0.9;
    self.cardContainer.layer.shadowRadius = 1.0;
    self.cardContainer.layer.cornerRadius = 12.0f;
    self.cardContainer.clipsToBounds = NO;

    
    [self.view addSubview:self.cardContainer];
    
    self.tapCenterView = [[UIImageView alloc] init];
    self.tapCenterView.frame = CGRectMake(0.0, 44.0, 320.0, 372.0);
    self.tapCenterView.backgroundColor = [UIColor clearColor];
    self.tapCenterView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.tapCenterView];
    
    
    self.cardView = [[UIImageView alloc] init];
    self.cardView.frame = CGRectMake(0.0, 0.0, CARDWIDTH, CARDHEIGHT);
    self.cardView.backgroundColor = [UIColor clearColor];
    self.cardView.contentMode = UIViewContentModeScaleToFill;
    
    self.cardView.layer.cornerRadius = 12.0f;
    self.cardView.layer.masksToBounds = YES;
    self.cardView.layer.borderWidth = 2.0f;
    self.cardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    [self.cardContainer addSubview:self.cardView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleBars)];
    [self.tapCenterView addGestureRecognizer:tapGesture];
    
    if(self.fiveBool == YES)
    {
        self.tapCenterView.frame = CGRectMake(0.0, 44.0, 320.0, 460.0);
        self.cardContainer.frame = CGRectMake(7.0, 79.0, CARDWIDTH, CARDHEIGHT);
        
    }
    
    [self newGame];

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

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)prepareForSegue:(	UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}

- (IBAction)newGame
{
    [self.cardsArray removeAllObjects];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // sets the gameplay mode and game title based on the user's choice
    int deckNumber = [[defaults stringForKey:@"decks"] intValue];
    int shuffleChoice = [[defaults stringForKey:@"shuffle"] intValue];
    self.deckChoice = [defaults stringForKey:@"type"];
    
    if(shuffleChoice == 0)
        self.shuffleBool = YES;
    else if(shuffleChoice == 1)
        self.shuffleBool = NO;
    else
        //NSLog(@"%d", shuffleChoice);
    
    self.endBool = NO;
    self.cardCounter = 0;
    self.shuffleCounter = 0;
    
    self.cardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@card-back.png", self.deckChoice]];
    
    
    self.nextCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@card-back.png", self.deckChoice]]];
    
    if(self.fiveBool == YES)
        self.nextCardView.frame = CGRectMake(3.0, 70.0, CARDWIDTH, CARDHEIGHT);
    else
        self.nextCardView.frame = CGRectMake(3.0, 24.0, CARDWIDTH, CARDHEIGHT);
    
    self.nextCardView.layer.cornerRadius = 12.0f;
    self.nextCardView.layer.masksToBounds = YES;
    self.nextCardView.layer.borderWidth = 2.0f;
    self.nextCardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    self.nextCardView.transform = CGAffineTransformMakeRotation(-6 * M_PI/180);
    
    [self.view insertSubview:self.nextCardView belowSubview:self.cardContainer];
    
    
    self.secondCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@card-back.png", self.deckChoice]]];
    
    if(self.fiveBool == YES)
        self.secondCardView.frame = CGRectMake(3.0, 70.0, CARDWIDTH, CARDHEIGHT);
    else
        self.secondCardView.frame = CGRectMake(3.0, 24.0, CARDWIDTH, CARDHEIGHT);
    
    self.secondCardView.layer.cornerRadius = 12.0f;
    self.secondCardView.layer.masksToBounds = YES;
    self.secondCardView.layer.borderWidth = 2.0f;
    self.secondCardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    self.secondCardView.transform = CGAffineTransformMakeRotation(-11 * M_PI/180);
    
    [self.view insertSubview:self.secondCardView belowSubview:self.nextCardView];
    
    
    self.thirdCardView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@card-back.png", self.deckChoice]]];
    
    if(self.fiveBool == YES)
        self.thirdCardView.frame = CGRectMake(3.0, 70.0, CARDWIDTH, CARDHEIGHT);
    else
        self.thirdCardView.frame = CGRectMake(3.0, 24.0, CARDWIDTH, CARDHEIGHT);
    
    self.thirdCardView.layer.cornerRadius = 12.0f;
    self.thirdCardView.layer.masksToBounds = YES;
    self.thirdCardView.layer.borderWidth = 2.0f;
    self.thirdCardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    self.thirdCardView.transform = CGAffineTransformMakeRotation(-15 * M_PI/180);
    
    [self.view insertSubview:self.thirdCardView belowSubview:self.secondCardView];
    
    self.cardMax = deckNumber * 52;
    //NSLog(@"Deck Number: %d", deckNumber);
    
    int cardsRemaining = self.cardMax - self.cardCounter;
    [self.cardCounterLabel setTitle:[NSString stringWithFormat:@"Cards Left: %d", cardsRemaining]];
    
    self.shuffleTimer = [NSTimer scheduledTimerWithTimeInterval: 0.02 target:self selector:@selector(shuffleCard) userInfo:nil repeats: YES];
    
    for(int k = 0; k < deckNumber; k++)
    {
        for(int i = 0, j = 0; i < 52; i++)
        {
            
            Card *card = [[Card alloc] init];
            
            // value
            
            switch (j)
            {
                case 0:
                    card.value = @"a";
                    j++;
                    break;
                case 1:
                    card.value = @"2";
                    j++;
                    break;
                case 2:
                    card.value = @"3";
                    j++;
                    break;
                case 3:
                    card.value = @"4";
                    j++;
                    break;
                case 4:
                    card.value = @"5";
                    j++;
                    break;
                case 5:
                    card.value = @"6";
                    j++;
                    break;
                case 6:
                    card.value = @"7";
                    j++;
                    break;
                case 7:
                    card.value = @"8";
                    j++;
                    break;
                case 8:
                    card.value= @"9";
                    j++;
                    break;
                case 9:
                    card.value = @"10";
                    j++;
                    break;
                case 10:
                    card.value = @"j";
                    j++;
                    break;
                case 11:
                    card.value = @"q";
                    j++;
                    break;
                case 12:
                    card.value = @"k";
                    j = 0;
                    break;
                default:
                    card.value = @"value error";
                    break;
            }
            
            
            // suit
            if(i < 13)
                card.suit = @"h";
            else if(i < 26)
                card.suit = @"d";
            else if(i < 39)
                card.suit = @"c";
            else if(i < 52)
                card.suit = @"s";
            else
                card.suit = @"suit error";
            
            // image
            
            card.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-%@.png", card.value, card.suit]];
            
            [self.cardsArray insertObject:card atIndex:i];
            
        }
        

    }
    
    self.topBar.layer.zPosition = 50;
    self.bottomBar.layer.zPosition = 50;
    

}

- (IBAction)drawCard
{
    if(self.cardCounter == self.cardMax)
    {
        //NSLog(@"End Bool: %c", self.endBool);
        if(self.endBool == NO)
        {
            self.previousCardImage = self.cardView.image;
            [self animateCard: 0];
            
            self.cardView.image = [UIImage imageNamed:[NSString stringWithFormat:@"red-joker.png"]];
                        
            [self.cardCounterLabel setTitle:[NSString stringWithFormat:@"Cards Left: 0"]];
            
            [self.drawButton setTitle:@"Shuffle Deck"];
            
            if(self.toggleBool == NO)
            {
                self.topBar.hidden = NO;
                self.bottomBar.hidden = NO;
                self.toggleBool = YES;
            }
            
            self.endBool = YES;
        }
        else
        {
            [self.drawButton setTitle:@"Draw Card"];
            self.endBool = NO;
            
            
            [self newGame];
        }
    }
    else
    {
        if(self.cardCounter != 0)
        {
            self.previousCardImage = self.cardView.image;
            [self animateCard: 0];
        }
        
        NSString *card = [[NSString alloc] init];
        Card *chosenCard = [[Card alloc] init];
        Card *blankCard = [[Card alloc] init];
    
        blankCard.value = @"blank";
        blankCard.suit = @"blank";
    
        int random;
        
        if(self.shuffleBool == YES)
        {
            do
            {
                random = arc4random() % 52;
                chosenCard = [self.cardsArray objectAtIndex:random];
            }while(chosenCard.value == @"blank");
        }
        else if(self.shuffleBool == NO )
        {
            random = self.cardCounter;
            chosenCard = [self.cardsArray objectAtIndex:random];
            
        }
        else
            //NSLog(@"shuffleBool card pick error");
    
        
        
    
        card = [NSString stringWithFormat:@"%@ %@",chosenCard.suit, chosenCard.value];
    
        [self.cardsArray replaceObjectAtIndex:random withObject:blankCard];
    
        
        self.cardView.image = chosenCard.image;
        
        int cardsRemaining = self.cardMax - self.cardCounter;
            
        self.cardCounter++;
                
        [self.cardCounterLabel setTitle:[NSString stringWithFormat:@"Cards Left: %d", cardsRemaining]];
        
        if(cardsRemaining == 3)
            [self.thirdCardView removeFromSuperview];
        else if(cardsRemaining == 2)
            [self.secondCardView removeFromSuperview];
        else if(cardsRemaining == 1)
            [self.nextCardView removeFromSuperview];
    
        for(Card *st in self.cardsArray) {
            //NSLog(@"%@, %@",st.value, st.suit);
        }
        
        //NSLog(@"Card Counter: %d", self.cardCounter);
    }
    
}

- (void)animateCard:(int)direction
{
       
    // forward
    if(direction == 0)
    {
        UIImageView *oldCardView= [[UIImageView alloc] initWithImage:self.previousCardImage];
        oldCardView.frame = CGRectMake(0.0, 0.0, CARDWIDTH, CARDHEIGHT);
        oldCardView.backgroundColor = [UIColor clearColor];
        oldCardView.contentMode = UIViewContentModeScaleToFill;
        
        oldCardView.layer.cornerRadius = 12.0f;
        oldCardView.layer.masksToBounds = YES;
        oldCardView.layer.borderWidth = 2.0f;
        oldCardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        
        [self.cardContainer addSubview:oldCardView];
        
        [UIView animateWithDuration:0.5f
                            delay:0.1f
                            options:UIViewAnimationCurveEaseInOut
                        animations:^{
                            [oldCardView setCenter:CGPointMake(150, -300)];
                            [oldCardView setAlpha:0.8f];
                        }
                        completion:^(BOOL finished){
                            [oldCardView removeFromSuperview];
                        }
        ];
    }
    else if(direction == 1)
    {
        UIImageView *oldCardView= [[UIImageView alloc] initWithImage:self.previousCardImage];
        oldCardView.frame = CGRectMake(0.0, 500.0, CARDWIDTH, CARDHEIGHT);
        oldCardView.backgroundColor = [UIColor clearColor];
        oldCardView.contentMode = UIViewContentModeScaleToFill;
        
        oldCardView.layer.cornerRadius = 12.0f;
        oldCardView.layer.masksToBounds = YES;
        oldCardView.layer.borderWidth = 2.0f;
        oldCardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
        
        [self.cardContainer addSubview:oldCardView];
        
        [UIView animateWithDuration:0.5f
                            delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                        animations:^{
                            [oldCardView setCenter:CGPointMake(0 + CARDWIDTH/2, 0 + CARDHEIGHT/2)];
                        }
                        completion:^(BOOL finished){
                            [oldCardView removeFromSuperview];
                            
                        }
  
        ];
            
            
            
    }
        
}

- (void)shuffleCard
{
    UIImageView *oldCardView= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@card-back", self.deckChoice]]];
    oldCardView.frame = CGRectMake(0.0, 600.0, CARDWIDTH, CARDHEIGHT);
    oldCardView.backgroundColor = [UIColor clearColor];
    oldCardView.contentMode = UIViewContentModeScaleToFill;
    
    oldCardView.layer.cornerRadius = 12.0f;
    oldCardView.layer.masksToBounds = YES;
    oldCardView.layer.borderWidth = 2.0f;
    oldCardView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    
    [self.cardContainer addSubview:oldCardView];
    
    [UIView animateWithDuration:0.5f
                          delay:0.1f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         [oldCardView setCenter:CGPointMake(0 + CARDWIDTH/2, 0 + CARDHEIGHT/2)];
                     }
                     completion:^(BOOL finished){
                         [oldCardView removeFromSuperview];
                         
                     }
   
     ];
    
    self.shuffleCounter++;
    
    if(self.shuffleCounter == SHUFFLEMAX)
    {
        [self.shuffleTimer invalidate];
        
    }
}

- (void)toggleBars
{
    if(self.toggleBool == YES)
    {
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             [self.topBar setAlpha:0.0f];
                             [self.bottomBar setAlpha:0.0f];
                         }
                         completion:^(BOOL finished){
                         }
         ];

        self.toggleBool = NO;
        if(self.fiveBool == YES)
            self.tapCenterView.frame = CGRectMake(0.0, 0.0, 320.0, 568.0);
        else
            self.tapCenterView.frame = CGRectMake(0.0, 0.0, 320.0, 480.0);
    }
    else if(self.toggleBool == NO)
    {
        [UIView animateWithDuration:0.5f
                              delay:0.0f
                            options:UIViewAnimationCurveEaseInOut
                         animations:^{
                             [self.topBar setAlpha:1.0f];
                             [self.bottomBar setAlpha:1.0f];
                         }
                         completion:^(BOOL finished){
                         }
         ];
        self.toggleBool = YES;
        if(self.fiveBool == YES)
            self.tapCenterView.frame = CGRectMake(0.0, 44.0, 320.0, 460.0);
        else
            self.tapCenterView.frame = CGRectMake(0.0, 44.0, 320.0, 372.0);
    }
    //else
        //NSLog(@"toggleBool error");
}

@end
