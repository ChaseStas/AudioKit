// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

#import "STKInstrumentDSP.h"

#include "Rhodey.h"
#include "sinewave_raw.h"
#include "fwavblnk_raw.h"

class RhodesPianoKeyDSP : public STKInstrumentDSP {
private:
    stk::Rhodey *rhodesPiano = nullptr;

public:
    RhodesPianoKeyDSP() {}
    ~RhodesPianoKeyDSP() = default;

    void init(int channelCount, double sampleRate) override {
        DSPBase::init(channelCount, sampleRate);

        NSError *error = nil;
        NSURL *directoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory()
                                                      stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]]
                                         isDirectory:YES];
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&error] == YES) {
            NSURL *sineURL = [directoryURL URLByAppendingPathComponent:@"sinewave.raw"];
            if ([manager fileExistsAtPath:sineURL.path] == NO) { // Create files once
                [[NSData dataWithBytesNoCopy:sinewave length:sinewave_len freeWhenDone:NO] writeToURL:sineURL atomically:YES];
                [[NSData dataWithBytesNoCopy:fwavblnk length:fwavblnk_len freeWhenDone:NO] writeToURL:[directoryURL URLByAppendingPathComponent:@"fwavblnk.raw"] atomically:YES];
            }
        } else {
            NSLog(@"Failed to create temporary directory at path %@ with error %@", directoryURL, error);
        }

        stk::Stk::setRawwavePath(directoryURL.fileSystemRepresentation);

        stk::Stk::setSampleRate(sampleRate);
        rhodesPiano = new stk::Rhodey();
    }

    stk::Instrmnt* getInstrument() override {
        return rhodesPiano;
    }

    void deinit() override {
        DSPBase::deinit();
        delete rhodesPiano;
        rhodesPiano = nullptr;
    }

};

AK_REGISTER_DSP(RhodesPianoKeyDSP);
