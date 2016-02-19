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

typedef void (^WWEasyApplePayFinishBlock)(PKPaymentAuthorizationViewController *paymentcontroller);

typedef void (^WWEasyApplePayFailureBlock)(PKPaymentAuthorizationViewController *paymentcontroller);

@interface WWEasyApplePayUtil : NSObject

@property(nonatomic,copy)NSString* merchantIdentifier;


@property(nonatomic,copy)NSString* countryCode;
@property(nonatomic,copy)NSString* currencyCode;

- (instancetype)initWithCountryCode:(NSString*)countryCode currencyCode:(NSString*)currencyCode merchantIdentifier:(NSString*)merchantIdentifier;

+(BOOL)IsSupportApplePay;

-(void)payWithAuthorizationBlock:(WWEasyApplePayAuthorizationBlock) authorizationBlock
                    failureBlock:(WWEasyApplePayFailureBlock)failureBlock
                    finishBlock:(WWEasyApplePayFinishBlock)finishBlock
             paymentSummaryItems:(PKPaymentSummaryItem *)summaryItems,... NS_REQUIRES_NIL_TERMINATION;
-(void)pay;

@end
