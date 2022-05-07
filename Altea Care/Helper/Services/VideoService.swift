//
//  VideoService.swift
//  Altea Care
//
//  Created by Hedy on 07/04/21.
//

import Foundation
import TwilioVideo

struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

class VideoSettings: NSObject {

    // ISDK-2644: Resolving a conflict with AudioToolbox in iOS 13
    let supportedAudioCodecs: [TwilioVideo.AudioCodec] = [IsacCodec(),
                                                          OpusCodec(),
                                                          PcmaCodec(),
                                                          PcmuCodec(),
                                                          G722Codec()]
    
    let supportedVideoCodecs: [VideoCodec] = [Vp8Codec(),
                                              Vp8Codec(simulcast: true),
                                              H264Codec(),
                                              Vp9Codec()]

    // Valid signaling Regions are listed here:
    // https://www.twilio.com/docs/video/ip-address-whitelisting#signaling-communication
    let supportedSignalingRegions: [String] = ["gll",
                                               "au1",
                                               "br1",
                                               "de1",
                                               "ie1",
                                               "in1",
                                               "jp1",
                                               "sg1",
                                               "us1",
                                               "us2"]


    let supportedSignalingRegionDisplayString: [String : String] = ["gll": "Global Low Latency",
                                                                    "au1": "Australia",
                                                                    "br1": "Brazil",
                                                                    "de1": "Germany",
                                                                    "ie1": "Ireland",
                                                                    "in1": "India",
                                                                    "jp1": "Japan",
                                                                    "sg1": "Singapore",
                                                                    "us1": "US East Coast (Virginia)",
                                                                    "us2": "US West Coast (Oregon)"]
    
    var audioCodec: TwilioVideo.AudioCodec?
    var videoCodec: VideoCodec?

    var maxAudioBitrate = UInt()
    var maxVideoBitrate = UInt()

    var signalingRegion: String?

    func getEncodingParameters() -> EncodingParameters?  {
        if maxAudioBitrate == 0 && maxVideoBitrate == 0 {
            return nil;
        } else {
            return EncodingParameters(audioBitrate: maxAudioBitrate,
                                      videoBitrate: maxVideoBitrate)
        }
    }
    
    private override init() {
        // Can't initialize a singleton
    }
    
    // MARK:- Shared Instance
    static let shared = VideoSettings()
}

