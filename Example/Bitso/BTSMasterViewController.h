//
//  MasterViewController.h
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BitsoAPI.h"




@interface BTSMasterViewController : UITableViewController


@property (nonatomic, strong) NSString *incomingSegue;
@property (nonatomic, strong) NSArray *firstMenu;
@property (nonatomic, strong) BitsoAPI *bitsoAPI;





@end

