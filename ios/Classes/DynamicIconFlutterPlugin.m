#import "DynamicIconFlutterPlugin.h"

@implementation DynamicIconFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"dynamic_icon_flutter"
                                     binaryMessenger:[registrar messenger]];
    [channel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        if ([@"mSupportsAlternateIcons" isEqualToString:call.method]) {
            if (@available(iOS 10.3, *)) {
                result(@(UIApplication.sharedApplication.supportsAlternateIcons));
            } else {
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                        message:@"Not supported on iOS ver < 10.3"
                                        details:nil]);
            }
        } else if ([@"mGetAlternateIconName" isEqualToString:call.method]) {
            if (@available(iOS 10.3, *)) {
                result(UIApplication.sharedApplication.alternateIconName);
            } else {
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                        message:@"Not supported on iOS ver < 10.3"
                                        details:nil]);
            }
        } else if ([@"mSetAlternateIconName" isEqualToString:call.method]) {
            if (@available(iOS 10.3, *)) {
                @try {
                    NSString *iconName = call.arguments[@"iconName"];
                    if (iconName == [NSNull null]) {
                        iconName = nil;
                    }
                    [UIApplication.sharedApplication setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
                        if(error) {
                            result([FlutterError errorWithCode:@"Failed to set icon"
                                                    message:[error description]
                                                    details:nil]);
                        } else {
                            result(nil);
                        }
                    }];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception.reason);
                    result([FlutterError errorWithCode:@"Failed to set icon"
                                            message:exception.reason
                                            details:nil]);
                }
            } else {
                result([FlutterError errorWithCode:@"UNAVAILABLE"
                                        message:@"Not supported on iOS ver < 10.3"
                                        details:nil]);
            }
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

@end
