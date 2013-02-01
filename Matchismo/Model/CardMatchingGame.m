//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Mark Beaty on 1/30/13.
//  Copyright (c) 2013 Mark Beaty. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (readwrite, nonatomic) int score;
@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (card) {
                self.cards[i] = card;
            } else {
                self = nil;
                break;  // ** Paul's code didn't break
            }
        }
    }
    
    return self;
}

#define FLIP_COST 1
#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            // see if flipping this card up creates a match
            for (Card *otherCard in self.cards) {
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) { 
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore + MATCH_BONUS;
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                    }
                }
            }
            self.score -= FLIP_COST;
        }
        card.faceUp = !card.isFaceUp;
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    if (self.cards) { // ** Paul's code didn't validate cards
        return index < [self.cards count] ? self.cards[index] : nil;
    }
    return nil;
}

@end
