//  Copyright © 2015 Matthew Kotila. All rights reserved.
//  Original C++ source: Michael Nguyen.
#import "OnePlayerBackend.h"

// Main class for the backend to OnePlayer mode. Checks legality of user input and manages game
// score.
@interface OnePlayerBackend ()

@end

@implementation OnePlayerBackend

// Error checks the score input, sets statistics accordingly, and updates the score display.
- (NSUInteger)OnePlayerBackendMain:(UITextField*)scoreInput :(UITextField*)scoreDisplay :(NSUInteger)numDarts {
    int turnScore = (int)[scoreInput.text integerValue];
    int legScore = (int)[scoreDisplay.text integerValue];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:([defaults integerForKey:@"dartsThisGame"] + numDarts) forKey:@"dartsThisGame"];
    [defaults setInteger:([defaults integerForKey:@"netScore"] + turnScore) forKey:@"netScore"];
    [defaults setInteger:([defaults integerForKey:@"netDarts"] + numDarts) forKey:@"netDarts"];
    if (turnScore > 180) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Illegal score" message:@"Must be less than or equal to 180" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return 0;
    }
    if (turnScore == legScore) {
        [defaults setInteger:([defaults integerForKey:@"numGamesWon"] + 1) forKey:@"numGamesWon"];
        [defaults setInteger:([defaults integerForKey:@"netOut"] + turnScore) forKey:@"netOut"];
        [defaults setInteger:0 forKey:@"numOneEightysThisGame"];
        if (turnScore > [defaults integerForKey:@"highestOut"])
            [defaults setInteger:turnScore forKey:@"highestOut"];
        if ([defaults integerForKey:@"dartsThisGame"] < [defaults integerForKey:@"leastDartsPerGame"] || [defaults integerForKey:@"leastDartsPerGame"] == 0)
            [defaults setInteger:[defaults integerForKey:@"dartsThisGame"] forKey:@"leastDartsPerGame"];
        [defaults setInteger:0 forKey:@"dartsThisGame"];
        return 2;
    }
    if (turnScore == 180) {
      [defaults setInteger:([defaults integerForKey:@"numOneEightysThisGame"] + 1) forKey:@"numOneEightysThisGame"];
      [defaults setInteger:([defaults integerForKey:@"numOneEightys"] + 1) forKey:@"numOneEightys"];
    }
    if (legScore - turnScore < 2) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Bust" message:@"" delegate:nil cancelButtonTitle:@"Darn" otherButtonTitles:nil];
        [alert show];
        return 1;
    }
    scoreDisplay.text = [NSString stringWithFormat:@"%d", legScore - turnScore];
    return 1;
}

@end
