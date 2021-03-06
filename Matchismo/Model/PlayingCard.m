//
//  PlayingCard.m
//  Matchismo
//
//  Created by Mark Beaty on 1/27/13.
//  Copyright (c) 2013 Mark Beaty. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

@synthesize suit = _suit;

static NSArray *rankStringsArray;
static NSArray *validSuitsArray;

- (NSString *)contents {
    
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
    
}

+ (NSArray *)validSuits {
    if (!validSuitsArray) {
        validSuitsArray = @[@"♥", @"♦", @"♠", @"♣"];
    }
    return validSuitsArray;
}

+ (NSArray *)rankStrings {
    if (!rankStringsArray) {
        rankStringsArray = @[ @"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    }
    return rankStringsArray;
}

+ (NSUInteger)maxRank {
    // ** Slides used [self rankStrings]. While that works,
    // it's technically not semantically correct.
    return [PlayingCard rankStrings].count - 1;
}

- (void)setSuit:(NSString *)suit {
    
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
    
}

- (NSString *)suit {
    
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank {
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
