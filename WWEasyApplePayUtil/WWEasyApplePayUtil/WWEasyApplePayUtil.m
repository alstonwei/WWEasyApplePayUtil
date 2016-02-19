//
//  WWEasyApplePayUtil.m
//  WWEasyApplePayUtil
//
//  Created by epailive on 16/2/19.
//  Copyright © 2016年 我就是大强. All rights reserved.
//

#import "WWEasyApplePayUtil.h"
#import <objc/runtime.h>

const char* PKPaymentAuthorizationViewControllerComplationBlock = "PKPaymentAuthorizationViewControllerComplationBlock";
const char* PKPaymentAuthorizationViewControllerFailureBlock = "PKPaymentAuthorizationViewControllerFailureBlock";
const char* PKPaymentAuthorizationViewControllerFinishBlock = "PKPaymentAuthorizationViewControllerFinishBlock";

@interface PKPaymentAuthorizationViewController(block)

-(id)getPKPaymentAuthorizationViewControllerFailureBlock;


-(void)setPKPaymentAuthorizationViewControllerFailureBlock:(id)block;


-(id)getPKPaymentAuthorizationViewControllerComplationBlock;


-(void)setPKPaymentAuthorizationViewControllerComplationBlock:(id)block;

-(id)getPKPaymentAuthorizationViewControllerFinishBlock;


-(void)setPKPaymentAuthorizationViewControllerFinishBlock:(id)block;


@end

@implementation PKPaymentAuthorizationViewController(block)

-(id)getPKPaymentAuthorizationViewControllerComplationBlock
{
    id block  = objc_getAssociatedObject(self, PKPaymentAuthorizationViewControllerComplationBlock);
    return block;
}

-(void)setPKPaymentAuthorizationViewControllerComplationBlock:(id)block
{
    objc_setAssociatedObject(self, PKPaymentAuthorizationViewControllerComplationBlock, block, OBJC_ASSOCIATION_COPY);
}


-(id)getPKPaymentAuthorizationViewControllerFailureBlock
{
    id block  = objc_getAssociatedObject(self, PKPaymentAuthorizationViewControllerFailureBlock);
    return block;
}

-(void)setPKPaymentAuthorizationViewControllerFailureBlock:(id)block
{
    objc_setAssociatedObject(self, PKPaymentAuthorizationViewControllerFailureBlock, block, OBJC_ASSOCIATION_COPY);
}

-(id)getPKPaymentAuthorizationViewControllerFinishBlock
{
    id block  = objc_getAssociatedObject(self, PKPaymentAuthorizationViewControllerFailureBlock);
    return block;
}

-(void)setPKPaymentAuthorizationViewControllerFinishBlock:(id)block
{
    objc_setAssociatedObject(self, PKPaymentAuthorizationViewControllerFinishBlock, block, OBJC_ASSOCIATION_COPY);
}



@end

@interface WWEasyApplePayUtil () <PKPaymentAuthorizationViewControllerDelegate>
{

}

//@property(nonatomic,copy)WWEasyApplePayAuthorizationBlock authorizationBlock;
//@property(nonatomic,copy)WWEasyApplePayCompletionBlock completionBlock;
//@property(nonatomic,copy)WWEasyApplePayFailureBlock failureBlock;

@end

@implementation WWEasyApplePayUtil


+(BOOL)IsSupportApplePay
{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        return YES;
    }
    return NO;
}



- (instancetype)initWithCountryCode:(NSString*)countryCode
                       currencyCode:(NSString*)currencyCode
                 merchantIdentifier:(NSString*)merchantIdentifier
{
    if (self = [super init]) {
        _countryCode = countryCode;
        _currencyCode = currencyCode;
        _merchantIdentifier = merchantIdentifier;
        
        
    }
    return self;
}

-(void)payWithAuthorizationBlock:(WWEasyApplePayAuthorizationBlock) authorizationBlock
                    failureBlock:(WWEasyApplePayFailureBlock)failureBlock
                     finishBlock:(WWEasyApplePayFinishBlock)finishBlock
             paymentSummaryItems:(PKPaymentSummaryItem *)summaryItems,... NS_REQUIRES_NIL_TERMINATION
{
    //_authorizationBlock = authorizationBlock;
    NSAssert(summaryItems != nil, @"the paymentSummaryItems must not be nil!");
    NSMutableArray* payments = [NSMutableArray arrayWithCapacity:1];
    PKPaymentSummaryItem  *item;
    va_list argumentList;
    if (summaryItems)
    {
        va_start(argumentList,summaryItems);
        while ((item = va_arg(argumentList, id)))
        {
            [payments addObject:item];
        }
        va_end(argumentList);
    }
    
    //判断是否支持
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        request.countryCode = self.countryCode;
        request.currencyCode = self.currencyCode;
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        
        request.merchantIdentifier = self.merchantIdentifier;
        request.paymentSummaryItems = payments;
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        [paymentPane setPKPaymentAuthorizationViewControllerComplationBlock:authorizationBlock];
        [paymentPane setPKPaymentAuthorizationViewControllerFailureBlock:failureBlock];
        [paymentPane setPKPaymentAuthorizationViewControllerFinishBlock:finishBlock];
        UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:paymentPane animated:TRUE completion:nil];
    }
    else
    {
        NSLog(@"this device does not support apple apple pay");
    }
}


-(void)pay
{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        PKPaymentRequest *request = [[PKPaymentRequest alloc] init];
        request.countryCode = @"CN";
        request.currencyCode = @"CNY";
        request.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
        request.merchantCapabilities = PKMerchantCapabilityEMV;
        
        request.merchantIdentifier = @"merchant.easyapplepay.com";
        
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 1" amount:[NSDecimalNumber decimalNumberWithString:@"0.99"]];
        
        PKPaymentSummaryItem *widget2 = [PKPaymentSummaryItem summaryItemWithLabel:@"Widget 2" amount:[NSDecimalNumber decimalNumberWithString:@"1.00"]];
        
        PKPaymentSummaryItem *total = [PKPaymentSummaryItem summaryItemWithLabel:@"Grand Total" amount:[NSDecimalNumber decimalNumberWithString:@"1.99"]];
        
        request.paymentSummaryItems = @[widget1, widget2, total];
        
        PKPaymentAuthorizationViewController *paymentPane = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
        paymentPane.delegate = self;
        UIViewController* root = [UIApplication sharedApplication].keyWindow.rootViewController;
        [root presentViewController:paymentPane animated:TRUE completion:nil];
    }
}

#pragma mark ===== PKPaymentAuthorizationViewControllerDelegate ========


// Sent to the delegate after the user has acted on the payment request.  The application
// should inspect the payment to determine whether the payment request was authorized.
//
// If the application requested a shipping address then the full addresses is now part of the payment.
//
// The delegate must call completion with an appropriate authorization status, as may be determined
// by submitting the payment credential to a processing gateway for payment authorization.
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    
    NSLog(@"Payment was authorized: %@", payment);
    
    WWEasyApplePayAuthorizationBlock authorizationBlock = [controller getPKPaymentAuthorizationViewControllerComplationBlock];
    
    if (authorizationBlock) {
        authorizationBlock(controller,payment,completion);
    
    }
    return;
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    WWEasyApplePayFinishBlock finishBlock = [controller getPKPaymentAuthorizationViewControllerFinishBlock];
    if (finishBlock) {
        finishBlock(controller);
    }
     NSLog(@"Payment was authorized: %@", controller);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
