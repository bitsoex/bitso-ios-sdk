//
//  MasterViewController.m
//  BitsoExampleApp
//
//  Created by Mario Romero Zavala on 5/16/16.
//  Copyright © 2016 Bitso SAPI de CV. All rights reserved.
//

#import "BTSMasterViewController.h"
#import "BitsoAPI.h"



@interface BTSMasterViewController ()



@property NSMutableArray *transactions;
@property NSMutableArray *objects;
@property NSMutableArray *tickerKeys;
@property NSMutableArray *balanceKeys;
@property NSMutableArray *userTransactions;
@property NSMutableArray *localOpenOrders;
@property NSMutableArray *btcAddresses;
@property BTSTickerModel *mainticker;
@property BTSOrderBookModel *localOrderBook;
@property BTSBalanceModel *localBalance;

@end


@implementation BTSMasterViewController
@synthesize incomingSegue;
@synthesize firstMenu;
@synthesize bitsoAPI;



- (void)viewDidLoad {
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *kClientID = [info objectForKey:@"CLIENT_ID"];
    NSString *kApiKey = [info objectForKey:@"API_KEY"];
    NSString *kApiSecret = [info objectForKey:@"API_SECRET"];
    bitsoAPI = [BitsoAPI APIWithClientID:kClientID APIKey:kApiKey APISecret:kApiSecret];
    
    if ([incomingSegue isEqualToString:@"Open Orders"]) {
        UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(placeOrderAction)];
        self.navigationItem.rightBarButtonItem = addBtn;
    }
  
    
    self.tickerKeys = [NSMutableArray arrayWithObjects:@"volume",
                                                       @"high",
                                                       @"low",
                                                       @"last",
                                                       @"ask",
                                                       @"bid",
                                                       @"vwap",
                                                       @"date",
                                                        nil];
    
    self.balanceKeys = [NSMutableArray arrayWithObjects:@"fee",
                                                        @"btc_available",
                                                        @"btc_reserved",
                                                        @"btc_balance",
                                                        @"mxn_available",
                                                        @"mxn_reserved",
                                                        @"mxn_balance",
                                                        nil];

    if (!incomingSegue) {
        [self setTitle:@"Bitso Example App"];
    } else {
        [self setTitle:incomingSegue];
    }
    
    
    [super viewDidLoad];

    if ([incomingSegue isEqualToString:@"Transactions"]) {

    
        
        [bitsoAPI getTransactionsFromBook:@"btc_mxn" forTimeRange:@"hour" successBlock:^(NSArray *responseModel) {
         
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
             @autoreleasepool {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     self.transactions = (NSMutableArray *)responseModel;
                     [self.tableView reloadData];
                 });
             }
         });
         
     } failureBlock:^(NSError *error) {
         [self.tableView reloadData];
     }];
    } else if ([incomingSegue isEqualToString:@"User Transactions"]) {
        NSLog(@"Loading API User Transactions");
        [bitsoAPI getUserTransactionsFromBook:@"btc_mxn" offset:nil limit:nil sort:nil successBlock:^(NSArray *responseModel) {

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.userTransactions = (NSMutableArray *)responseModel;
                        [self.tableView reloadData];
                    });
                }
            });
            
        } failureBlock:^(NSError *error) {
            [self.tableView reloadData];
        }];
    } else if ([incomingSegue isEqualToString:@"Open Orders"]) {
        [bitsoAPI getOpenOrdersFromBook:@"btc_mxn" successBlock:^(NSArray *responseModel) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.localOpenOrders = (NSMutableArray *)responseModel;
                        [self.tableView reloadData];
                    });
                }
            });
            
        } failureBlock:^(NSError *error) {
            [self.tableView reloadData];
        }];
    } else if ([incomingSegue isEqualToString:@"Ticker"]) {
            
        NSLog(@"Loading API Ticker");
        [bitsoAPI getTickerForBook:@"btc_mxn" successBlock:^(BTSTickerModel *responseModel) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @autoreleasepool {
                        self.mainticker = responseModel;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                });
                
            } failureBlock:^(NSError *error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [self.tableView reloadData];
            }];
    } else if ([incomingSegue isEqualToString:@"Balance"]) {


        NSLog(@"Loading API Balance");
        
        [bitsoAPI getBalanceWithSuccessBlock:^(BTSBalanceModel *responseModel) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    self.localBalance = responseModel;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            });
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self.tableView reloadData];
        }];
    } else if ([incomingSegue isEqualToString:@"Bitcoin Deposit"]) {

        NSLog(@"Loading API BTC Deposit");
        [bitsoAPI getBitcoinDepositAddressWithSuccessBlock:^(NSString *responseModel) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    NSLog(@"response model: %@", responseModel);
                    
                    self.btcAddresses = [[NSMutableArray alloc] init];
                    [self.btcAddresses addObject:responseModel];

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                        NSLog(@"no error, tableview reloaded");
                    });
                }
            });
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Error btc deposit: %@ %@", error, [error userInfo]);
            [self.tableView reloadData];
        }];
    } else if ([incomingSegue isEqualToString:@"Orderbook"]) {
        
        NSLog(@"Loading API OrderBook");

        [bitsoAPI getOrderBook:@"btc_mxn" withGrouping:YES successBlock:^(BTSOrderBookModel *responseModel) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                @autoreleasepool {
                    self.localOrderBook = responseModel;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            });
            
        } failureBlock:^(NSError *error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [self.tableView reloadData];
        }];
        } else {
        firstMenu = [NSArray arrayWithObjects: @"Ticker", @"Transactions", @"Orderbook", @"Balance", @"User Transactions", @"Open Orders", @"Bitcoin Deposit", @"Bitcoin Withdrawal", @"Bank Withdrawal",nil];
        [self.tableView reloadData];
    } 
    
}




- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if ([incomingSegue isEqualToString:@"Bitcoin Deposit"]) {
        return NO;
    }
    if (indexPath.section == 1 && ([firstMenu[[indexPath item]+3] isEqualToString:@"Bitcoin Withdrawal"] || [firstMenu[[indexPath item]+3] isEqualToString:@"Bank Withdrawal"])) {
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath.section == 0) {
        [segue.destinationViewController setIncomingSegue:firstMenu[[indexPath item]]];
    } else {
        [segue.destinationViewController setIncomingSegue:firstMenu[[indexPath item]+3]];
    }
}

#pragma mark - Table View


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && [firstMenu[[indexPath item]+3] isEqualToString:@"Bitcoin Withdrawal"]) {
        [self doBitcoinWithdrawal];
    } else if (indexPath.section == 1 && [firstMenu[[indexPath item]+3] isEqualToString:@"Bank Withdrawal"]) {
        [self doBankWithdrawal];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([incomingSegue isEqualToString:@"Orderbook"] || !incomingSegue) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([incomingSegue isEqualToString:@"Orderbook"] || !incomingSegue) {
        return 28;
        
    } else {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    if ([incomingSegue isEqualToString:@"Orderbook"] || !incomingSegue) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
        /* Create custom view to display section header... */
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.frame.size.width, 28)];
        [label setFont:[UIFont boldSystemFontOfSize:12]];
        
        NSArray *sectionTitles = @[@"Asks", @"Bids"];
        
        if (!incomingSegue) {
           sectionTitles = @[@"Public", @"Private"];
        }
        
        NSString *string =[sectionTitles objectAtIndex:section];
        /* Section header is in 0th index... */
        [label setText:string];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:(247.0f/255.0f) green:(247.0f/255.0f) blue:(247.0f/255.0f) alpha:1]]; //your background
        return view;
    }

    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([incomingSegue isEqualToString:@"Transactions"]) {
        //NSLog(@"transaction counts: %lu", (unsigned long)[self.transactions count]);
        return [self.transactions count];
    } else if ([incomingSegue isEqualToString:@"User Transactions"]) {
        //NSLog(@"transaction counts: %lu", (unsigned long)[self.userTransactions count]);
        return [self.userTransactions count];
    } else if ([incomingSegue isEqualToString:@"Open Orders"]) {
        return [self.localOpenOrders count];
    } else if ([incomingSegue isEqualToString:@"Bitcoin Deposit"]) {
        //NSLog(@"btcAddresses counts: %lu", (unsigned long)[self.btcAddresses count]);
        return [self.btcAddresses count];
    } else if ([incomingSegue isEqualToString:@"Ticker"]) {

        return [self.tickerKeys count];

    } else if ([incomingSegue isEqualToString:@"Orderbook"]) {
        return 12;
        
    } else if ([incomingSegue isEqualToString:@"Balance"]) {
        return [self.balanceKeys count];
        
    } else {
        if (section == 0)
            return 3;
        return 6;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
     if ([incomingSegue isEqualToString:@"Transactions"]) {
         BTSTransactionModel *transaction = self.transactions[[indexPath item]];

         cell.textLabel.text = [NSString stringWithFormat:@"%@ @ %@", [transaction.amount stringValue], transaction.price];
         cell.userInteractionEnabled = NO;
         
     } else if ([incomingSegue isEqualToString:@"User Transactions"]) {
         BTSUserTransactionModel *transactionu = self.userTransactions[[indexPath item]];
         if (transactionu.method == NULL) {
             // It's a trade
             cell.textLabel.text = [NSString stringWithFormat:@"%@, %@ [rate:%@, btc:%@]", transactionu.type, transactionu.datetime, transactionu._rate, transactionu._btc];
         } else {
             // It's a Transfer
             if (transactionu._btc==nil) {
                   cell.textLabel.text = [NSString stringWithFormat:@"%@:%@, %@ [mxn:%@]", transactionu.type, transactionu.method, transactionu.datetime, [transactionu.mxn stringValue]];
             } else {
                 cell.textLabel.text = [NSString stringWithFormat:@"%@:%@, %@ [btc:%@]", transactionu.type, transactionu.method, transactionu.datetime, transactionu._btc];
             }
         }
         cell.textLabel.adjustsFontSizeToFitWidth = YES;
         cell.userInteractionEnabled = NO;

         
     } else if ([incomingSegue isEqualToString:@"Open Orders"]) {

         BTSOrderModel *orderc = self.localOpenOrders[[indexPath item]];
         cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ @ %@", orderc.type, [orderc.amount stringValue], [orderc.price stringValue]];
         cell.userInteractionEnabled = YES;
         cell.textLabel.adjustsFontSizeToFitWidth = YES;
         
     } else if ([incomingSegue isEqualToString:@"Bitcoin Deposit"]) {

         NSString *btcAddress = self.btcAddresses[[indexPath item]];

         cell.textLabel.text = btcAddress;
         cell.textLabel.adjustsFontSizeToFitWidth = YES;
         cell.userInteractionEnabled = YES;
         
     } else if ([incomingSegue isEqualToString:@"Ticker"]) {

         NSString *tickerItem = [self.tickerKeys objectAtIndex:[indexPath item]];
         id tickerValue = [self.mainticker valueForKey:tickerItem];
         if ([tickerItem isEqualToString:@"date"]) {
             NSString *dateString = [NSDateFormatter localizedStringFromDate:tickerValue
                                                                   dateStyle:NSDateFormatterShortStyle
                                                                   timeStyle:NSDateFormatterFullStyle];
             cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", tickerItem, dateString];
         } else {
             cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", tickerItem, [tickerValue stringValue]];
         }
         cell.userInteractionEnabled = NO;
         
     } else if ([incomingSegue isEqualToString:@"Orderbook"]) {
         if (indexPath.section==0) {
             cell.textLabel.text = [NSString stringWithFormat:@"%@ @ %@", self.localOrderBook.asks[[indexPath item]][1], self.localOrderBook.asks[[indexPath item]][0]];
             cell.userInteractionEnabled = NO;
         } else {
             cell.textLabel.text = [NSString stringWithFormat:@"%@ @ %@", self.localOrderBook.bids[[indexPath item]][1], self.localOrderBook.asks[[indexPath item]][0]];
             cell.userInteractionEnabled = NO;
         }
         
     }  else if ([incomingSegue isEqualToString:@"Balance"]) {
             
             NSString *balanceItem = [self.balanceKeys objectAtIndex:[indexPath item]];
             id balanceValue = [self.localBalance valueForKey:balanceItem];
             cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", balanceItem, [balanceValue stringValue]];
             cell.userInteractionEnabled = NO;
     } else {
         if (indexPath.section == 0) {
             cell.textLabel.text = firstMenu[[indexPath item]];
             cell.userInteractionEnabled = YES;
         } else {
             cell.textLabel.text = firstMenu[[indexPath item]+3];
             cell.userInteractionEnabled = YES;
             
         }
         
     }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([incomingSegue isEqualToString:@"Open Orders"]) {
            BTSOrderModel *order = self.localOpenOrders[[indexPath item]];
            [bitsoAPI cancelOrderWithOrderID:order.oid successBlock:^(NSString *responseModel) {

                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    @autoreleasepool {
                        NSLog(@"response model: %@", responseModel);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.localOpenOrders removeObjectAtIndex:indexPath.row];
                            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                            [self.tableView reloadData];
                        });
                    }
                });
                
            } failureBlock:^(NSError *error) {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
                [self.tableView reloadData];
            }];

        }
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:)) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.btcAddresses[[indexPath item]];
    }
}

- (void)handleSellWithAlert:(UIAlertController *)alert {
    UITextField *price = alert.textFields.firstObject;
    UITextField *amount = [alert.textFields objectAtIndex:1];
    [bitsoAPI placeSellOrderInBook:@"btc_mxn" amount:amount.text price:price.text successBlock:^(BTSOrderModel *responseModel) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSLog(@"response model: %@", responseModel);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self viewDidLoad];
                });
            }
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        [self.tableView reloadData];
        //[self reloadInputViews]
        
    }];
    
}

- (void)handleBuyWithAlert:(UIAlertController *)alert {
    UITextField *price = alert.textFields.firstObject;
    UITextField *amount = [alert.textFields objectAtIndex:1];
    [bitsoAPI placeBuyOrderInBook:@"btc_mxn" amount:amount.text price:price.text successBlock:^(BTSOrderModel *responseModel) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSLog(@"response model: %@", responseModel);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self viewDidLoad];
                });
            }
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        [self.tableView reloadData];
        //[self reloadInputViews]
        
    }];

}

- (void)placeOrderAction {
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Place Order"
                                message:@""
                                preferredStyle:UIAlertControllerStyleAlert];

    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Price", @"Price");
     }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Amount", @"Amount");
     }];
    
    UIAlertAction* buyAction = [UIAlertAction actionWithTitle:@"Buy" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {[self handleBuyWithAlert:alert];}];
    
    UIAlertAction* sellAction = [UIAlertAction actionWithTitle:@"Sell" style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * action) {[self handleSellWithAlert:alert];}];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //cancel action
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:buyAction];
    [alert addAction:sellAction];
    [self presentViewController:alert animated:YES completion:nil];
    

    
}

- (void)handleBitcoinWithAlert:(UIAlertController *)alert {
    
    UITextField *amount = alert.textFields.firstObject;
    UITextField *address = [alert.textFields objectAtIndex:1];
    
    [bitsoAPI bitcoinWithdrawalToAddress:address.text amount:amount.text successBlock:^(NSString *responseModel) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSLog(@"response model: %@", responseModel);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self viewDidLoad];
                });
            }
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        [self.tableView reloadData];
        //[self reloadInputViews]
        
    }];
}


- (void)doBitcoinWithdrawal {
    
    
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Bitcoin Withdrawal"
                                message:@""
                                preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Amount", @"Amount");
     }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Address", @"Address");
     }];
    

    UIAlertAction* withdrawalAction = [UIAlertAction actionWithTitle:@"Bitcoin Withdrawal" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self handleBitcoinWithAlert:alert];}];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //cancel action
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:withdrawalAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (void)handleBankWithdrawalWithAlert:(UIAlertController *)alert {
    UITextField *amount = alert.textFields.firstObject;
    UITextField *givenName = [alert.textFields objectAtIndex:1];
    UITextField *familyName = [alert.textFields objectAtIndex:2];
    UITextField *clabe = [alert.textFields objectAtIndex:3];
    UITextField *notesRef = [alert.textFields objectAtIndex:4];
    UITextField *numericRef = [alert.textFields objectAtIndex:5];
    
    [bitsoAPI bankWithdrawalForAmount:amount.text recipientGivenNames:givenName.text familyNames:familyName.text clabe:clabe.text notesRef:notesRef.text numericRef:numericRef.text successBlock:^(NSString *responseModel) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSLog(@"response model: %@", responseModel);
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self viewDidLoad];
                });
            }
        });
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        [self.tableView reloadData];
        //[self reloadInputViews]
    }];
}


- (void)doBankWithdrawal {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:@"Bank Withdrawal"
                                message:@""
                                preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"Amount", @"Amount");
     }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"givenName", @"givenName");
     }];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"familyName", @"familyName");
     }];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"clabe", @"clabe");
     }];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"notesRef", @"notesRef");
     }];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = NSLocalizedString(@"numericRef", @"numericRef");
     }];

    UIAlertAction* withdrawalAction = [UIAlertAction actionWithTitle:@"Bank Withdrawal" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {[self handleBankWithdrawalWithAlert:alert];}];
                                                                 
    
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //cancel action
                                                         }];
    [alert addAction:cancelAction];
    [alert addAction:withdrawalAction];
    [self presentViewController:alert animated:YES completion:nil];


    
}

@end
