//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface OnePlayerViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) AVAudioPlayer *winSoundPlayer;
@property (strong, nonatomic) NSDictionary *suggestionsDictionary;
@property (weak, nonatomic) IBOutlet UITextField *scoreDisplay;
@property (weak, nonatomic) IBOutlet UITextField *scoreInput;
@property (weak, nonatomic) IBOutlet UIButton *scoreSubmitButton;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
@property (weak, nonatomic) IBOutlet UIImageView *dart2;
@property (weak, nonatomic) IBOutlet UIImageView *dart3;
@property (weak, nonatomic) IBOutlet UIStepper *dartsStepper;
@property (weak, nonatomic) IBOutlet UILabel *suggestion;

@end
