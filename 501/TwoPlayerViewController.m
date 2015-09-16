//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import "TwoPlayerViewController.h"
#import "TwoPlayerBackend.h"
#import "SFSConfettiScreen.h"

// Main UIViewController for TwoPlayer. Manages user input and can present the settings screen and
// win screen. Calls backend function to do score computing.
@interface TwoPlayerViewController ()

@end

@implementation TwoPlayerViewController

// Assigns delegate for monitoring legal text input, loads dictionary, and assigns current player.
- (void)viewDidLoad {
  [super viewDidLoad];
  _scoreInput.delegate = self;
  _suggestionsDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"suggestions" ofType:@"plist"]];
  _currentPlayer = 1;
}

// Makes keyboard appear and hides navigation bar for when returning from statistics.
- (void)viewWillAppear:(BOOL)animated {
  [_scoreInput becomeFirstResponder];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// Makes keyboard appear when returning from settings and checks if player mode changed.
- (void)viewDidAppear:(BOOL)animated {
  [_scoreInput becomeFirstResponder];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  if ([defaults integerForKey:@"numPlayersChanged"]) {
    [[self presentedViewController] dismissViewControllerAnimated:NO completion:nil];
  }
}

// Blocks the copy/cut/select/select all/paste menu for score input.
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
  }];
  return [super canPerformAction:action withSender:sender];
}

// Limits number of characters typed to three for score input.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  if (string.length == 0)
    return YES;
  return _scoreInput.text.length < 3;
}

// Resets the current game.
- (IBAction)touchUpInsideResetButton:(id)sender {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset game" message:@"Are you sure you want to reset this game?" preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
    _scoreDisplayOne.text = @"501";
    _scoreDisplayTwo.text = @"501";
    _scoreInput.text = @"";
    _suggestion.text = @"";
    _currentPlayer = 1;
    _dart2.hidden = NO;
    _dart3.hidden = NO;
    _dartsStepper.value = 3;
    _scoreDisplayOne.backgroundColor = [UIColor colorWithRed:1 green:0.894 blue:0.412 alpha:1];
    _scoreDisplayTwo.backgroundColor = [UIColor clearColor];
  }];
  UIAlertAction* altAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
  [alert addAction:defaultAction];
  [alert addAction:altAction];
  [self presentViewController:alert animated:YES completion:nil];
}

// Changes button color.
- (IBAction)touchDownSubmitScoreButton:(id)sender {
  [sender setBackgroundColor:[UIColor colorWithRed:0.235 green:0.753 blue:0.278 alpha:1]];
}

// Reverts button color.
- (IBAction)touchUpOutsideSubmitScoreButton:(id)sender {
  [sender setBackgroundColor:[UIColor colorWithRed:0.263 green:0.835 blue:0.318 alpha:1]];
}

// Calls backend function and does actions based on backend return value.
- (IBAction)touchUpInsideSubmitScoreButton:(id)sender {
  [sender setBackgroundColor:[UIColor colorWithRed:0.263 green:0.835 blue:0.318 alpha:1]];
  UITextField *scoreDisplay = (_currentPlayer == 1) ? _scoreDisplayOne : _scoreDisplayTwo;
  TwoPlayerBackend* twoplayerbackend = [[TwoPlayerBackend alloc] init];
  NSUInteger result = [twoplayerbackend TwoPlayerBackendMain:_scoreInput :scoreDisplay :_dartsStepper.value];
  if (result == 1) { // 1 is normal turn.
    _dartsStepper.value = 3;
    _dart2.hidden = NO;
    _dart3.hidden = NO;
    _scoreInput.text = @"";
    if (_currentPlayer == 1) {
      _currentPlayer = 2;
      _scoreDisplayOne.backgroundColor = [UIColor clearColor];
      _scoreDisplayTwo.backgroundColor = [UIColor colorWithRed:1 green:0.894 blue:0.412 alpha:1];
      _suggestion.text = [_suggestionsDictionary objectForKey:_scoreDisplayTwo.text];
    }
    else {
      _currentPlayer = 1;
      _scoreDisplayTwo.backgroundColor = [UIColor clearColor];
      _scoreDisplayOne.backgroundColor = [UIColor colorWithRed:1 green:0.894 blue:0.412 alpha:1];
      _suggestion.text = [_suggestionsDictionary objectForKey:_scoreDisplayOne.text];
    }
  }
  else if (result == 2) { // 2 is victory.
    scoreDisplay.text = @"0";
    _scoreInput.text = @"";
    _suggestion.text = @"";
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Win"];
    SFSConfettiScreen *screen = [[SFSConfettiScreen alloc] initWithFrame:self.view.frame];
    [vc.view addSubview:screen];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tappedWin:)];
    tap.numberOfTapsRequired = 1;
    [vc.view addGestureRecognizer:tap];
    [self presentViewController:vc animated:YES completion:nil];
    _winSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"partyblower" withExtension:@"wav"] error:nil];
    [_winSoundPlayer play];
  }
  // 0 is illegal input.
}

// Dismisses win screen back to new game.
- (void)tappedWin:(UITapGestureRecognizer *)recognizer {
  _scoreDisplayOne.text = @"501";
  _scoreDisplayTwo.text = @"501";
  _currentPlayer = 1;
  _dart2.hidden = NO;
  _dart3.hidden = NO;
  _dartsStepper.value = 3;
  _scoreDisplayOne.backgroundColor = [UIColor colorWithRed:1 green:0.894 blue:0.412 alpha:1];
  _scoreDisplayTwo.backgroundColor = [UIColor clearColor];
  [self dismissViewControllerAnimated:YES completion:nil];
  recognizer.enabled = NO;
}

// Presents settings screen.
- (IBAction)touchUpInsideSettingsButton:(id)sender {
  UIViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"Settings"];
  [self presentViewController:vc animated:YES completion:nil];
}

// Fixes darts display for number of darts per turn counter.
- (IBAction)valueChangedStepper:(id)sender {
  switch ((int)_dartsStepper.value) {
    case 1:
      _dart2.hidden = YES;
      _dart3.hidden = YES;
      break;
    case 2:
      _dart2.hidden = NO;
      _dart3.hidden = YES;
      break;
    case 3:
      _dart2.hidden = NO;
      _dart3.hidden = NO;
      break;
    default:
      break;
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
