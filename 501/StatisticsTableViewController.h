//  Copyright © 2015 Matthew Kotila. All rights reserved.
#import <UIKit/UIKit.h>

@interface StatisticsTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *numGamesWon;
@property (weak, nonatomic) IBOutlet UILabel *threeDartAvg;
@property (weak, nonatomic) IBOutlet UILabel *numOneEightys;
@property (weak, nonatomic) IBOutlet UILabel *highestOut;
@property (weak, nonatomic) IBOutlet UILabel *outAvg;
@property (weak, nonatomic) IBOutlet UILabel *leastDartsPerGame;
@property (weak, nonatomic) IBOutlet UILabel *dartsPerGameAvg;

@end
