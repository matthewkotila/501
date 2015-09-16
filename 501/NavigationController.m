//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "NavigationController.h"

// Main UINavigationController for app. Chooses the initial UIViewController.
@interface NavigationController ()

@end

@implementation NavigationController

// Presents either OnePlayer or TwoPlayer based on the setting.
- (void)viewDidLoad {
  [super viewDidLoad];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults integerForKey:@"numPlayers"] == 2) {
    UIViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TwoPlayer"];
    [self pushViewController:vc animated:YES];
  }
  else {
    UIViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"OnePlayer"];
    [self pushViewController:vc animated:YES];
  }
}

// Assigns either OnePlayer or TwoPlayer for ViewController after the setting has been updated.
- (void)viewWillAppear:(BOOL)animated {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults integerForKey:@"numPlayersChanged"]) {
    [defaults setInteger:0 forKey:@"numPlayersChanged"];
    if ([defaults integerForKey:@"numPlayers"] == 2) {
      UIViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"TwoPlayer"];
      [self pushViewController:vc animated:YES];
    }
    else {
      UIViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"OnePlayer"];
      [self pushViewController:vc animated:YES];
    }
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
