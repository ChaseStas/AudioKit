//
//  OCSHeader.m
//  Objective-Csound
//
//  Created by Aurelius Prochazka on 7/3/12.
//  Copyright (c) 2012 Hear For Yourself. All rights reserved.
//

#import "OCSHeader.h"

@interface OCSHeader () {
    int sampleRate;
    int samplesPerControlPeriod;
    int numberOfChannels;
    float zeroDBFullScaleValue;
}
@end

@implementation OCSHeader

@synthesize zeroDBFullScaleValue;

- (id)init {
    self = [super init];
    if (self != nil) {
        sampleRate = 44100;
        samplesPerControlPeriod = 512;
        numberOfChannels = 2;
        zeroDBFullScaleValue = 1.0f;
    }
    return self;
}   

/// Gives the CSD string for the output parameter.  
- (NSString *)description {
    return [NSString stringWithFormat:
            @"nchnls = %d \n"
            @"sr     = %d \n"
            @"0dbfs  = %g \n"
            @"ksmps  = %d \n", 
            numberOfChannels, sampleRate, zeroDBFullScaleValue, samplesPerControlPeriod];
}


@end
