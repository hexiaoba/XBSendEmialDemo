//
//  LocationTool.m
//  YiCaiCommunity
//
//  Created by 何凯楠 on 2016/12/16.
//  Copyright © 2016年 HeXiaoBa. All rights reserved.
//

#import "XTLocationUtils.h"


@interface XTLocationUtils()<CLLocationManagerDelegate>
@property (nonatomic, nullable, strong) CLLocationManager *locationManager;
@property (nonatomic, nullable, strong) CLGeocoder *geocoder;

@end

@implementation XTLocationUtils

- (instancetype)init {
    if (self = [super init]) {
        [self setupLocationManager];
    }
    return self;
}

- (CLGeocoder *)geocoder
{
    if (!_geocoder) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

-(void)setupLocationManager {
    self.locationManager = [CLLocationManager new];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    self.locationManager.delegate = self;
}

#pragma mark 城市定位
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *ym_location =[locations firstObject];
    [self.locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [CLGeocoder new];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:ym_location.coordinate.latitude longitude:ym_location.coordinate.longitude];
    

    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *province = nil;
        NSString *city = nil;
        if (placemarks.count == 0 || error) {
            
        } else {
            CLPlacemark *placemark = placemarks.lastObject;
            if (placemark.administrativeArea) {
                //省
               province = placemark.administrativeArea;
            }
            if (placemark.locality) {
                //市
                city = placemark.locality;
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(getCurrentLocationWithProvince:city:)]) {
            [self.delegate getCurrentLocationWithProvince:province city:city];
        }
       
    }];
}

//开始定位
- (void)xt_startUpdatingLocation {
    
    [self.locationManager startUpdatingLocation];
}

//据地名确定地理坐标  地理编码
- (void)xt_getCoordinateByAddress:(NSString *)address result:(void(^)(CLLocationCoordinate2D coordinate, NSError *error))result {
    
    //地理编码
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark = [placemarks firstObject];
        
        CLLocation *location = placemark.location;//位置
//        CLRegion *region = placemark.region;//区域
//        NSDictionary *addressDic = placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
//        NSString *name = placemark.name;//地名
//        NSString *thoroughfare=placemark.thoroughfare;//街道
//        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
//        NSString *locality=placemark.locality; // 城市
//        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
//        NSString *administrativeArea=placemark.administrativeArea; // 州
//        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
//        NSString *postalCode=placemark.postalCode; //邮编
//        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
//        NSString *country=placemark.country; //国家
//        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
//        NSString *ocean=placemark.ocean; // 海洋
//        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
        
        result(location.coordinate, error);
    }];
    
}

#pragma mark 根据坐标取得地名
-(void)xt_getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude result:(void(^)(NSString *address, NSError *error))result {
    //反地理编码
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];

    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        
        NSString *administrativeArea = placemark.administrativeArea; // 州
        NSString *locality = placemark.locality; // 城市
        
        NSString *address = [NSString stringWithFormat:@"%@%@", administrativeArea, locality];
        
        result(address, error);
    }];
}


@end
