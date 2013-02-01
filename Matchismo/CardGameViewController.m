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
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"%d", self.flipCount];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}


@end
