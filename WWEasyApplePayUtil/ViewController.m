//
//  ViewController.m
//  WWEasyApplePayUtil
//
//  Created by epailive on 16/2/19.
//  Copyright © 2016年 我就是大强. All rights reserved.
//

#import "ViewController.h"
#import "WWEasyApplePayUtil.h"

@interface ViewController ()

@property(strong,nonatomic)WWEasyApplePayUtil* applePayUtil;

@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPayClicked:(id)sender {
    
    PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1" amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
    
    PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
    
    PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];

    [self.applePayUtil payWithAuthorizationBlock:^(PKPaymentAuthorizationViewController *paymentcontroller, PKPayment *payment, WWEasyApplePayCompletionBlock completionBlock) {
        NSLog(@"准备支付");
        //完成支付。
        completionBlock(PKPaymentAuthorizationStatusSuccess);
    } failureBlock:^(PKPaymentAuthorizationViewController *paymentcontroller) {
        NSLog(@"支付失败");
    }finishBlock:^(PKPaymentAuthorizationViewController *paymentcontroller) {
          NSLog(@"支付完成");
    }  paymentSummaryItems:widget1,widget2,total, nil];
}



- (WWEasyApplePayUtil *)applePayUtil
{
    if (!_applePayUtil) {
        _applePayUtil = [[WWEasyApplePayUtil alloc] initWithCountryCode:@"CN" currencyCode:@"CNY" merchantIdentifier:@"merchant.easyapplepay.com"];
    }
    return _applePayUtil;
}

@end
