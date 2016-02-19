//
//  WWEasyApplePayUtil.h
//  WWEasyApplePayUtil
//
//  Created by epailive on 16/2/19.
//  Copyright © 2016年 我就是大强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PassKit/PassKit.h>

typedef void (^WWEasyApplePayCompletionBlock)(PKPaymentAuthorizationStatus status);

typedef void(^WWEasyApplePayAuthorizationBlock)(PKPaymentAuthorizationViewController *paymentcontroller,PKPayment *payment,WWEasyApplePayCompletionBlock completionBlock);


typedef void (^WWEasyApplePayFailureBlock)(PKPaymentAuthorizationViewController *paymentcontroller);

@interface WWEasyApplePayUtil : NSObject


- (instancetype)initWithCountryCode:(NSString*)countryCode currencyCode:(NSString*)currencyCode authrizationBlock:(WWEasyApplePayAuthorizationBlock)authrizationBlock  failureBlock:(WWEasyApplePayFailureBlock)failureBlock;

+(BOOL)IsSupportApplePay;

-(void)payWithAuthorizationBlock:(WWEasyApplePayAuthorizationBlock) authorizationBlock summaryItems:(PKPaymentSummaryItem *)summaryItems,... NS_REQUIRES_NIL_TERMINATION;
-(void)pay;

@end
