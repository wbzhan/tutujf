//
//  TransferSellDetailController.h
//  TTJF
//
//  Created by wbzhan on 2018/5/30.
//  Copyright © 2018年 TTJF. All rights reserved.
//

#import "BaseViewController.h"
/**
 可转让的标的进行债权转让
 */
typedef void (^CompleteBlock)(void);
@interface TransferSellDetailController : BaseViewController
Copy NSString *tender_id;
Copy CompleteBlock completeBlock;//详情页面操作完成之后回调
Copy NSString *state;//债权转让状态-1 不可转让，1 可以转让 2 转让中 3 已转让
@end
