//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Mark Beaty on 1/30/13.
//  Copyright (c) 2013 Mark Beaty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated initializer
- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck;

- (void)flipCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;

@property (readonly, nonatomic) int score;
@property (readonly, nonatomic) NSString *flipMessage;
@property (nonatomic) int gameMode;

@end
