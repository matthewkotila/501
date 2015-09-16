//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "SettingsViewController.h"

// Main UIViewController for settings. Changes the player mode and can reset statistics.
@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

// Selects correct player mode.
- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults integerForKey:@"numPlayers"] != 0)
        _numPlayersSegmentedControl.selectedSegmentIndex = [defaults integerForKey:@"numPlayers"] - 1;
    else
        _numPlayersSegmentedControl.selectedSegmentIndex = 0;
}

// Changes player mode.
- (IBAction)valueChangedNumPlayersSegmentedControl:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:@"This action will discard the current game's progress." preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Change" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        if ([[_numPlayersSegmentedControl titleForSegmentAtIndex:_numPlayersSegmentedControl.selectedSegmentIndex] isEqual: @"1"]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:1 forKey:@"numPlayers"];
            [defaults setInteger:1 forKey:@"numPlayersChanged"];
        }
        else {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setInteger:2 forKey:@"numPlayers"];
            [defaults setInteger:1 forKey:@"numPlayersChanged"];
        }
    }];
    UIAlertAction* altAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        if (_numPlayersSegmentedControl.selectedSegmentIndex == 0)
            _numPlayersSegmentedControl.selectedSegmentIndex = 1;
        else
            _numPlayersSegmentedControl.selectedSegmentIndex = 0;
    }];
    [alert addAction:defaultAction];
    [alert addAction:altAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// Resets statistics by removing key-object pairs from NSUserDefaults.
- (IBAction)touchUpInsideResetStatisticsButton:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset statistics" message:@"Are you sure you want to reset the statistics?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:@"netScore"];
        [defaults removeObjectForKey:@"netDarts"];
        [defaults removeObjectForKey:@"netOut"];
        [defaults removeObjectForKey:@"numGamesWon"];
        [defaults removeObjectForKey:@"numOneEightys"];
        [defaults removeObjectForKey:@"highestOut"];
        [defaults removeObjectForKey:@"leastDartsPerGame"];
        [defaults removeObjectForKey:@"dartsThisGame"];
        [defaults removeObjectForKey:@"numOneEightysThisGame"];
    }];
    UIAlertAction* altAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:altAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// Returns to game view.
- (IBAction)touchUpInsideDoneButton:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
