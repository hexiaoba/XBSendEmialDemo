//
//  ViewController.m
//  PodTest
//
//  Created by 何凯楠 on 2017/4/18.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import "ViewController.h"
#import <XTLocationUtils/XTLocationUtils.h>
#import <XTHttpRequestUtils/XTSimpleHttpRequestUtils.h>
#import "LogConst.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    DDLogVerbose(@"ViewController");
    
    XTLocationUtils *locationUtils = [[XTLocationUtils alloc] init];
    [locationUtils xt_startUpdatingLocation];
    
    
    [XTSimpleHttpRequestUtils requestGetWithURL:@"" completionHandler:^(NSError *error, id result) {
        
    }];
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
