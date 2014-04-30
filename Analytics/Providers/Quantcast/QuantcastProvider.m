//
//  QuantcastProvider.m
//  Analytics
//
//  Created by Travis Jeffery on 4/26/14.
//  Copyright (c) 2014 Segment.io. All rights reserved.
//

#import "QuantcastProvider.h"
#import "Analytics.h"
#import <Quantcast-Measure/QuantcastMeasurement.h>

@implementation QuantcastProvider

+ (void)load {
    [Analytics registerProvider:self withIdentifier:self.name];
}

- (id)init {
    if (self = [super init]) {
        self.name = self.class.name;
    }
    return self;
}

- (void)validate {
    self.valid = self.settings[@"apiKey"] != nil;
}

- (void)start {
    [[QuantcastMeasurement sharedInstance] setupMeasurementSessionWithAPIKey:self.settings[@"apiKey"] userIdentifier:self.settings[@"userIdentifier"] labels:self.settings[@"labels"]];
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties options:(NSDictionary *)options {
    [[QuantcastMeasurement sharedInstance] logEvent:event withLabels:self.settings[@"labels"]];
}

- (void)screen:(NSString *)screenTitle properties:(NSDictionary *)properties options:(NSDictionary *)options {
    [[QuantcastMeasurement sharedInstance] logEvent:screenTitle withLabels:self.settings[@"labels"]];
}

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits options:(NSDictionary *)options {
    [[QuantcastMeasurement sharedInstance] recordUserIdentifier:userId withLabels:self.settings[@"labels"]];
}

- (void)applicationDidFinishLaunching {
    [[QuantcastMeasurement sharedInstance] beginMeasurementSessionWithAPIKey:self.settings[@"apiKey"] userIdentifier:self.settings[@"userIdentifier"] labels:nil];
}

- (void)applicationDidEnterBackground {
    [[QuantcastMeasurement sharedInstance] pauseSessionWithLabels:nil];
}

- (void)applicationWillEnterForeground {
    [[QuantcastMeasurement sharedInstance] resumeSessionWithLabels:nil];
}

- (void)applicationWillTerminate {
    [[QuantcastMeasurement sharedInstance] endMeasurementSessionWithLabels:self.settings[@"labels"]];
}

#pragma mark - Private

+ (NSString *)name {
    return @"Quantcast";
}

@end
