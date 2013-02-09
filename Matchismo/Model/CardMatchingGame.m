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
@property (readwrite, nonatomic) NSString *flipMessage;
@property (readwrite, nonatomic) NSMutableString *flipMessageBuffer;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *matchCards;
@property (nonatomic) int totalMatchScore;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (NSMutableArray *)matchCards
{
    if (!_matchCards) {
        _matchCards = [[NSMutableArray alloc] init];
    }
    return _matchCards;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        
        // Initialize to a 2-card match
        _gameMode = 2;
        
        // Initialize message strings
        _flipMessage = [[NSString alloc] init];
        _flipMessageBuffer = [[NSMutableString alloc] init];
        
        // Initialize game cards
        //
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
            
            //            if (self.gameMode == 3) {
            //
            //                // see if flipping this card up creates a match
            //                for (Card *otherCard in self.cards) {
            //                    if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            //                        int matchScore = [card match:@[otherCard]];
            //                        if (matchScore) {
            //
            //                            otherCard.unplayable = YES;
            //                            card.unplayable = YES;
            //                            self.score += matchScore + MATCH_BONUS;
            //                            self.flipMessage = [NSString stringWithFormat:@"Matched %@ & %@! (points: %d + bonus: %d)", card.contents, otherCard.contents, matchScore, MATCH_BONUS];
            //
            //                        } else {
            //
            //                            otherCard.faceUp = NO;
            //                            self.score -= MISMATCH_PENALTY;
            //                            self.flipMessage = [NSString stringWithFormat:@" %@ & %@ don't match! (penalty: %d)", card.contents, otherCard.contents, MISMATCH_PENALTY];
            //
            //                        }
            //
            //                    } else if ([otherCard isUnplayable]) {
            //                        remainingCards--;
            //                    }
            //                }
            //            }
            //
            //            if (self.gameMode == 2) {
        
            if (![self.matchCards count]) {
                
                [self.matchCards addObject:card];

            } else {
                int matchScore = [card match:self.matchCards];
                
                if (matchScore) {
                    
                    NSLog(@"Match score: %d", matchScore);
                    
                    self.totalMatchScore += matchScore;
                    self.score += MATCH_BONUS;
                    NSLog(@"Match bonus: +%d", MATCH_BONUS);
                    NSLog(@"Total match score: (match) %d", self.totalMatchScore);

                    
                    if ([self.matchCards count] == self.gameMode - 1) {
                        
                        [self.flipMessageBuffer appendString:card.contents];
                        
                        for (Card *matchedCard in self.matchCards) {
                            matchedCard.unplayable = YES;
                            [self.flipMessageBuffer appendString:matchedCard.contents];
                        }
                        
                        card.unplayable = YES;
                        [self.matchCards removeAllObjects];
                        
                        self.flipMessage = [NSString stringWithFormat:@"Matches: %@, Points: %d", self.flipMessageBuffer, self.totalMatchScore];
                        self.flipMessageBuffer = [NSMutableString stringWithString:@""];
                        
                        // Apply a match bonus if all cards match another card
                        // in any way. Scale the bonus using the game mode.
                        //
                        self.score += self.totalMatchScore;
                        self.totalMatchScore = 0;

                        NSLog(@"=====================");

                    } else {
                        
                        [self.matchCards addObject:card];
                        
                    }
                    
                } else {
                    
//                    self.totalMatchScore -= MISMATCH_PENALTY;
                    self.score -= MISMATCH_PENALTY;
                    NSLog(@"Mismatch penalty: -%d", MISMATCH_PENALTY);
                    NSLog(@"Total match score: (mismatch) %d", self.totalMatchScore);
                    
                    if ([self.matchCards count] == 1) {
                        
                        [self.matchCards[0] setFaceUp:NO];
                        [self.matchCards replaceObjectAtIndex:0 withObject:card];

                        
                    } else if ([self.matchCards count] == self.gameMode - 1) {
                        
                        // Don't set the current card unplayable since it doesn't
                        // match any other card; it's still playable!
                        //
                        for (Card *matchedCard in self.matchCards) {
                            matchedCard.unplayable = YES;
                            [self.flipMessageBuffer appendString:matchedCard.contents];
                        }
                        
                        [self.matchCards removeAllObjects];
                        [self.matchCards addObject:card];
                        
                        self.flipMessage = [NSString stringWithFormat:@"Matches: %@, Points: %d", self.flipMessageBuffer, self.totalMatchScore];
                        self.flipMessageBuffer = [NSMutableString stringWithString:@""];
                        
                        self.score += self.totalMatchScore;
                        self.totalMatchScore = 0;

                        NSLog(@"=====================");
                        
                    } else {
                        
                        [self.matchCards addObject:card];

                    }
                }
            }
            //            }
            
            NSLog(@"Flip cost: -%d", FLIP_COST);
            self.score -= FLIP_COST;
            
        } else {
            
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
