//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Mark Beaty on 1/27/13.
//  Copyright (c) 2013 Mark Beaty. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCard.h"

@interface CardGameViewController ()

@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UIButton *flippedTopCard;
@property (weak, nonatomic) IBOutlet UIButton *deckTopCard;
@property (weak, nonatomic) IBOutlet UILabel *tapToFlipLabel;
@property (weak, nonatomic) IBOutlet UILabel *tapToShuffleLabel;
    
@end

@implementation CardGameViewController

- (PlayingCardDeck *)deck {
    if (!_deck) {
        _deck = [[PlayingCardDeck alloc] init];
    }
    return _deck;
}

- (void)setFlipCount:(int)flipCount {
    
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"%d", self.flipCount];

}

- (IBAction)flipCard:(UIButton *)sender {
    
//    sender.selected = !sender.isSelected;
//    
//    if (sender.isSelected) {
    
        PlayingCard *card = (PlayingCard *)[self.deck drawRandomCard];
        
        if (card) {
            
            // Assume if one is hidden the other is too.
            if (self.flippedTopCard.hidden) {
                self.flippedTopCard.hidden = NO;
                self.tapToShuffleLabel.hidden = NO;
            }
            
            [self.flippedTopCard setTitle:card.contents forState:UIControlStateNormal];
            
            self.flipCount++;
            
            if (self.deck.cardsInDeck == 0) {
                sender.hidden = YES;
                self.tapToFlipLabel.hidden = YES;
            }
            
        }
//        else {
//            sender.hidden = YES;
//        }
    
//    }
}

- (IBAction)shuffleDeck:(UIButton *)sender {
    sender.hidden = YES;
    self.tapToShuffleLabel.hidden = YES;
    self.deckTopCard.hidden = NO;
    self.tapToFlipLabel.hidden = NO;
    self.flipCount = 0;
    self.deck = nil;
}

@end
