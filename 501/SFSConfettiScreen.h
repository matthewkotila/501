//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SFSConfettiScreen : UIView

@property (weak, nonatomic) CAEmitterLayer *confettiEmitter;
@property (assign, nonatomic) CGFloat decayAmount;

- (id)initWithFrame:(CGRect)frame;

@end
