//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "StatisticsTableViewController.h"

// Main UITableViewController for statistics. Displays global statistics and that are maintained
// via  NSUserDefaults.
@interface StatisticsTableViewController ()

@end

@implementation StatisticsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// Loads all and computes some of the statistics from storage into the view.
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    self.navigationItem.hidesBackButton = YES;
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    _numGamesWon.text = [NSString stringWithFormat:@"%d", (int)[defaults integerForKey:@"numGamesWon"]];
    _threeDartAvg.text = [NSString stringWithFormat:@"%.2f", ([defaults doubleForKey:@"netScore"] / [defaults doubleForKey:@"netDarts"]) * 3.0];
    _numOneEightys.text = [NSString stringWithFormat:@"%d", (int)[defaults integerForKey:@"numOneEightys"]];
    _highestOut.text = [NSString stringWithFormat:@"%d", (int)[defaults integerForKey:@"highestOut"]];
    _outAvg.text = [NSString stringWithFormat:@"%.2f", [defaults doubleForKey:@"netOut"] / [defaults doubleForKey:@"numGamesWon"]];
    _leastDartsPerGame.text = [NSString stringWithFormat:@"%d", (int)[defaults integerForKey:@"leastDartsPerGame"]];
    _dartsPerGameAvg.text = [NSString stringWithFormat:@"%.2f", [defaults doubleForKey:@"netDarts"] / [defaults doubleForKey:@"numGamesWon"]];
    if ([_threeDartAvg.text isEqual:@"nan"]) {
        _threeDartAvg.text = @"0.00";
        _outAvg.text = @"0.00";
        _dartsPerGameAvg.text = @"0.00";
    }
}

// Returns to game view.
- (IBAction)touchUpInsideBackButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
