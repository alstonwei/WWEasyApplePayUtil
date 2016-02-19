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
    [self.applePayUtil pay];
}



- (WWEasyApplePayUtil *)applePayUtil
{
    if (!_applePayUtil) {
        _applePayUtil = [[WWEasyApplePayUtil alloc] init];
    }
    return _applePayUtil;
}

@end
