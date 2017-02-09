//
//  timeTableViewCell.h
//  TodayOfHistory
//
//  Created by #incloud on 17/1/17.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
