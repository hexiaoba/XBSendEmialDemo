//
//  LocationTool.h
//  YiCaiCommunity
//
//  Created by 何凯楠 on 2016/12/16.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@protocol XTLocationUtilsDelegate <NSObject>

@optional
/**
 定位获取省市

 @param province 省
 @param city 市
 */
- (void)getCurrentLocationWithProvince:(NSString *)province city:(NSString *)city;

@end


@interface XTLocationUtils : NSObject

@property (nonatomic, weak) id <XTLocationUtilsDelegate> delegate;

/**
 开始定位
 */
- (void)xt_startUpdatingLocation;


/**
 地理编码(把地址转换为经纬度)

 @param address 地址
 @param result 结果回调
 */
- (void)xt_getCoordinateByAddress:(NSString *)address result:(void(^)(CLLocationCoordinate2D coordinate, NSError *error))result;

/**
 逆地理编码

 @param latitude 经度
 @param longitude 纬度
 @param result 结果回调
 */
-(void)xt_getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude result:(void(^)(NSString *address, NSError *error))result;

@end
