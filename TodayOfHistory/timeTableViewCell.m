//
//  timeTableViewCell.m
//  TodayOfHistory
//
//  Created by #incloud on 17/1/17.
//  Copyright © 2017年 #incloud. All rights reserved.
//

#import "timeTableViewCell.h"

@interface timeTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *yearView;

@end

@implementation timeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.yearView.layer.cornerRadius = self.yearView.frame.size.width / 2;
   
}



@end
