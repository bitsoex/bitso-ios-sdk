# Bitso

[![CI Status](http://img.shields.io/travis/Mario Romero/Bitso.svg?style=flat)](https://travis-ci.org/Mario Romero/Bitso)
[![Version](https://img.shields.io/cocoapods/v/Bitso.svg?style=flat)](http://cocoapods.org/pods/Bitso)
[![License](https://img.shields.io/cocoapods/l/Bitso.svg?style=flat)](http://cocoapods.org/pods/Bitso)
[![Platform](https://img.shields.io/cocoapods/p/Bitso.svg?style=flat)](http://cocoapods.org/pods/Bitso)

## Bitso Credentials
From a terminal:
  - cd directory
  - Pod install
  - export CLIENT_ID=YOUR_CLIENT_ID
  - export API_KEY=YOUR_API_KEY
  - export API_SECRET=YOUR_API_SECRET
  - open -a xcode
  - From Xcode, open Bitso.xcworkspace
  


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Bitso is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Bitso"
```

## API Usage
```objective-c
BitsoAPI *bitsoAPI = [BitsoAPI APIWithClientID:CLIENT_ID APIKey:API_KEY APISecret:API_SECRET];
```

### Public Endpoints

#### Ticker
```objective-c
[bitsoAPI getTickerForBook:@"btc_mxn" successBlock:^(BTSTickerModel *ticker) {
    NSLog(@"Last Price:%@", [ticker.last stringValue])
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```
#### Transactions
```objective-c
[bitsoAPI getTransactionsFromBook:@"btc_mxn" forTimeRange:@"hour" successBlock:^(NSArray *trades) {
    for (BitsoTrade* trade in trades) {
      NSLog(@"amount:%@, side:%@, price:%@", [trade.amount stringValue], trade.side, [trade.price stringValue]);
    }
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Order Book

```objective-c
[bitsoAPI getOrderBook:@"btc_mxn" withGrouping:YES successBlock:^(BTSOrderBookModel *orderbook) {
    for (NSArray *ask in orderbook.asks) {
      NSLog(@"%@ @ %@", [ask[1] stringValue], [ask[0] stringValue]);
    }
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

### Private Endpoints

#### Balance
```objective-c
[bitsoAPI getBalanceWithSuccessBlock:^(BTSBalanceModel *balance) {
    NSLog(@"BTC balance:%@", [balance.btc_balance stringValue]);
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### User Transactions
```objective-c
[bitsoAPI getUserTransactionsFromBook:@"btc_mxn" offset:nil limit:nil sort:nil successBlock:^(NSArray *utxs) {
    for (BitsoUserTransaction* transaction in utxs) {
      NSLog(@"datetime:%@", [transaction.datetime stringValue]);
    }
  } failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Open Orders
```objective-c
[bitsoAPI getOpenOrdersFromBook:@"btc_mxn" successBlock:^(NSArray *orders) {
    for (BTSOrderModel *order in orders) {
      NSLog(@"oid:%@", transaction.oid);
    }
  } failureBlock:^(NSError *error) {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Lookup Order
```objective-c
[bitsoAPI lookupOrderWithOrderID:ORDER_ID successBlock:^(BTSOrderModel *order) {
    NSLog(@"price:%@, amount:%@", [order.price stringValue], [order.amount stringValue]);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Cancel Order
```objective-c
[bitsoAPI  cancelOrderWithOrderID:ORDER_ID successBlock:^(NSString *response) {
    NSLog(@"%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Place Buy Order
```objective-c
[bitsoAPI  placeBuyOrderInBook:BOOK
                        amount:AMOUNT
                         price:PRICE
                  successBlock:^(BTSOrderModel *order) {
      NSLog(@"price:%@, amount:%@", [order.price stringValue], [order.amount stringValue]);
} failureBlock:^(NSError *error) {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Place Sell Order
```objective-c
[bitsoAPI  placeSellOrderInBook:BOOK
                         amount:AMOUNT
                          price:PRICE
                   successBlock:^(BTSOrderModel *order) {
      NSLog(@"price:%@, amount:%@", [order.price stringValue], [order.amount stringValue]);
} failureBlock:^(NSError *error) {
      NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Get Bitcoin deposit address
```objective-c
[bitsoAPI getBitcoinDepositAddressWithSuccessBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Bitcoin withdrawal
```objective-c
[bitsoAPI bitcoinWithdrawalToAddress:ADDRESS amount:AMOUNT successBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Ripple withdrawal
```objective-c
[bitsoAPI rippleWithdrawalOfCurrency:CURRENCY toAddress:ADDRESS amount:AMOUNT successBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

#### Bank withdrawal
```objective-c
[bitsoAPI bankWithdrawalForAmount:AMOUNT recipientGivenNames:GIVEN_NAMES familyNames:FAMILY_NAMES clabe:CLABE_SPEI notesRef:@"" numericRef:@"" successBlock:^(NSString *response) {
    NSLog("%@", response);
} failureBlock:^(NSError *error) {
    NSLog(@"Error: %@ %@", error, [error userInfo]);
}];
```

## Author

Mario Romero, mario@bitso.com

Copyright © 2016 Bitso SAPI de CV. All rights reserved.

## License

Bitso is available under the MIT license. See the LICENSE file for more info.
