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
@property (strong, nonatomic) PlayingCardDeck *deck;
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
    
//    if ([self.deck cardsInDeck] == 0) {
//        [self shuffleDeck];
//    }    
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        
        PlayingCard *card = (PlayingCard *)[self.deck drawRandomCard];
        
        if (card) {
            
            [sender setTitle:card.contents forState:UIControlStateSelected];
            
            self.flipCount++;
            
        }
        
    } else {
        if ([self.deck cardsInDeck] == 0) {
            [self shuffleDeck];
        }
    }
}

- (void)shuffleDeck {
    self.flipCount = 0;
    self.deck = nil;
}

@end
