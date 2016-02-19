//
//  WWEasyApplePayUtil.m
//  WWEasyApplePayUtil
//
//  Created by epailive on 16/2/19.
//  Copyright © 2016年 我就是大强. All rights reserved.
//

#import "WWEasyApplePayUtil.h"



@interface WWEasyApplePayUtil () <PKPaymentAuthorizationViewControllerDelegate>
{
    NSString* _countryCode;
    NSString* _currencyCode;
}

@property(nonatomic,copy)WWEasyApplePayAuthorizationBlock authorizationBlock;
@property(nonatomic,copy)WWEasyApplePayCompletionBlock completionBlock;
@property(nonatomic,copy)WWEasyApplePayFailureBlock failureBlock;

@end

@implementation WWEasyApplePayUtil


+(BOOL)IsSupportApplePay
{
    if([PKPaymentAuthorizationViewController canMakePayments]) {
        
        return YES;
    }
    return NO;
}



- (instancetype)initWithCountryCode:(NSString*)countryCode currencyCode:(NSString*)currencyCode authrizationBlock:(WWEasyApplePayAuthorizationBlock)authrizationBlock failureBlock:(WWEasyApplePayFailureBlock)failureBlock
{
    if (self = [super init]) {
        _countryCode = countryCode;
        _currencyCode = currencyCode;
        _authorizationBlock = authrizationBlock;
        //_completionBlock = completionBlock;
        _failureBlock = failureBlock;
        
        
    }
    return self;
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
    
    
    if (self.authorizationBlock) {
        self.authorizationBlock(controller,payment,completion);
    
    }
    return;
    BOOL asyncSuccessful = FALSE;
    
    // When the async call is done, send the callback.
    // Available cases are:
    //    PKPaymentAuthorizationStatusSuccess, // Merchant auth'd (or expects to auth) the transaction successfully.
    //    PKPaymentAuthorizationStatusFailure, // Merchant failed to auth the transaction.
    //
    //    PKPaymentAuthorizationStatusInvalidBillingPostalAddress,  // Merchant refuses service to this billing address.
    //    PKPaymentAuthorizationStatusInvalidShippingPostalAddress, // Merchant refuses service to this shipping address.
    //    PKPaymentAuthorizationStatusInvalidShippingContact        // Supplied contact information is insufficient.
    
    completion(PKPaymentAuthorizationStatusSuccess);
}


// Sent to the delegate when payment authorization is finished.  This may occur when
// the user cancels the request, or after the PKPaymentAuthorizationStatus parameter of the
// paymentAuthorizationViewController:didAuthorizePayment:completion: has been shown to the user.
//
// The delegate is responsible for dismissing the view controller in this method.
- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
     NSLog(@"Payment was authorized: %@", controller);
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
