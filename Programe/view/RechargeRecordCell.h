//
//  RechargeRecordCell.h
//  TTJF
//
//  Created by wbzhan on 2018/4/25.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeModel.h"
/**
 投资记录
 */
@interface RechargeRecordCell : UITableViewCell
-(void)loadInfoWithModel:(RechargeModel *)model;
@end