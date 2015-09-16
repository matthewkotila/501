//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "TwoPlayerBackend.h"

// Main class for the backend to TwoPlayer mode. Checks legality of user input and manages game
// score.
@interface TwoPlayerBackend ()

@end

@implementation TwoPlayerBackend

// Error checks the score input, sets statistics accordingly, and updates the score display.
- (NSUInteger)TwoPlayerBackendMain:(UITextField*)scoreInput :(UITextField*)scoreDisplay :(NSUInteger)numDarts {
  int turnScore = (int)[scoreInput.text integerValue];
  int legScore = (int)[scoreDisplay.text integerValue];
  if (turnScore > 180) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Illegal score" message:@"Must be less than or equal to 180" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return 0; // illegal input
  }
  if (turnScore == legScore) {
    return 2; // victory
  }
  if (legScore - turnScore < 2) {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Bust" message:@"" delegate:nil cancelButtonTitle:@"Darn" otherButtonTitles:nil];
    [alert show];
    return 1; // legal input
  }
  scoreDisplay.text = [NSString stringWithFormat:@"%d", legScore - turnScore];
  return 1; // legal input
}

@end
