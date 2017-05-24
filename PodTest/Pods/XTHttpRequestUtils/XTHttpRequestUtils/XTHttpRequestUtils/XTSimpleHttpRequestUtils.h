//
//  BaseAPIManager.h
//  ArchitecturalPattern（架构）
//
//  Created by 何凯楠 on 2017/3/15.
//  Copyright © 2017年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetworkCompletionHandler)(NSError *error, id result);

typedef NS_ENUM(NSUInteger, XTRequestType) {
    XTRequestTypeGET,
    XTRequestTypePOST,
};

typedef NS_ENUM(NSUInteger, XTFormatDataType) {
    FormatDataTypeRefresh,
    FormatDataTypeLoadMore,
};

typedef NS_ENUM(NSUInteger, XTNetworkError) {
    NetworkErrorNoData,
    NetworkErrorNoMoreData
};

@interface XTSimpleHttpRequestUtils : NSObject

+ (instancetype)shareInstance;

@property (nonatomic, copy) NSString *baseUrl;

+ (void)requestGetWithURL:(NSString *)url completionHandler:(NetworkCompletionHandler)completionHandler;

+ (void)requestPostWithURL:(NSString *)url parm:(id)parm completionHandler:(NetworkCompletionHandler)completionHandler;



@end
