//  SFSConfettiScreen.m source: https://gist.github.com/3731696
//  Confetti.png source: https://s3.amazonaws.com/silly_face_society/web_files/particles/Confetti.png
//  partyblower.wav source: https://freesound.org/people/dmjames/sounds/140095/
//  dart.png source: http://www.wpclipart.com/recreation/games/darts/dart.svg
//  dartboard.png source: http://www.wpclipart.com/recreation/games/darts/dartboard.svg
//  AppIcon source: https://thenounproject.com/term/dartboard/142142/ by Creative Stall from the Noun Project, changed
#import "SFSConfettiScreen.h"

// Main UIView for win screen. Displays confetti animation.
@interface SFSConfettiScreen ()

@end

@implementation SFSConfettiScreen

- (id)initWithFrame:(CGRect)frame {
  if ((self = [super initWithFrame:frame])) {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor clearColor];
    _confettiEmitter = (CAEmitterLayer*)self.layer;
    _confettiEmitter.emitterPosition = CGPointMake(self.bounds.size.width /2, 0);
    _confettiEmitter.emitterSize = self.bounds.size;
    _confettiEmitter.emitterShape = kCAEmitterLayerLine;

    CAEmitterCell *confetti = [CAEmitterCell emitterCell];
    confetti.contents = (__bridge id)[[UIImage imageNamed:@"Confetti.png"] CGImage];
    confetti.name = @"confetti";
    confetti.birthRate = 150;
    confetti.lifetime = 5.0;
    confetti.color = [[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0] CGColor];
    confetti.redRange = 0.8;
    confetti.blueRange = 0.8;
    confetti.greenRange = 0.8;

    confetti.velocity = 250;
    confetti.velocityRange = 50;
    confetti.emissionRange = (CGFloat) M_PI_2;
    confetti.emissionLongitude = (CGFloat) M_PI;
    confetti.yAcceleration = 150;
    confetti.scale = 1.0;
    confetti.scaleRange = 0.2;
    confetti.spinRange = 10.0;
    _confettiEmitter.emitterCells = [NSArray arrayWithObject:confetti];
  }

  return self;
}

+ (Class)layerClass {
  return [CAEmitterLayer class];
}

static NSTimeInterval const kDecayStepInterval = 0.1;
- (void)decayStep {
  _confettiEmitter.birthRate -=_decayAmount;
  if (_confettiEmitter.birthRate < 0)
    _confettiEmitter.birthRate = 0;
  else
    [self performSelector:@selector(decayStep) withObject:nil afterDelay:kDecayStepInterval];
}

- (void)decayOverTime:(NSTimeInterval)interval {
  _decayAmount = (CGFloat)(_confettiEmitter.birthRate / (interval / kDecayStepInterval));
  [self decayStep];
}

- (void)stopEmitting {
  _confettiEmitter.birthRate = 0.0;
}

@end
