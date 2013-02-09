//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Mark Beaty on 1/27/13.
//  Copyright (c) 2013 Mark Beaty. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeSelector;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[[PlayingCardDeck alloc] init]];
    }
    
    return _game;
}



// This cardButtons setter gets called by iOS when
// it assigns the buttons to the buttons collection
//
- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
    //    NSMutableString *board = [NSMutableString stringWithCapacity:24];
    //    int loopCount = 1;
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        // There's got to be a better way to do this!
        if (card.isFaceUp) {
            [cardButton setBackgroundImage:nil forState:UIControlStateNormal];
        } else {
            [cardButton setBackgroundImage:[UIImage imageNamed:@"card-back.png"] forState:UIControlStateNormal];
            
        }
        
        //        [board appendString:card.contents];
        //        [board appendString:@" "];
        //        if (loopCount % 4 == 0) {
        //            [board appendString:@"\n"];
        //        }
        //        loopCount++;
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    
    //    NSLog(@"%@", board);
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", self.game.score];
    if (self.game.flipMessage) {
        self.messageLabel.text = [NSString stringWithFormat:@"%@", self.game.flipMessage];
    } else {
        self.messageLabel.text = @"";
    }
    self.flipsLabel.text = [NSString stringWithFormat:@"%d", self.flipCount];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (!self.flipCount) {
        self.gameModeSelector.enabled = NO;
    }
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)newGame:(UIButton *)sender {
    int gameMode = self.game.gameMode;
    self.game = nil;
    self.game.gameMode = gameMode;
    self.flipCount = 0;
    self.gameModeSelector.enabled = YES;
    [self updateUI];
}

- (IBAction)changeGameMode:(UISegmentedControl *)sender {
	if(sender.selectedSegmentIndex == 0){
        self.game.gameMode = 2;
	}
	if(sender.selectedSegmentIndex == 1){
        self.game.gameMode = 3;
	}
}

@end
