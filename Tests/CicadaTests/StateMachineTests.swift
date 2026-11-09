import Foundation
import Testing
@testable import Cicada

/// The small state machines pulled out of the engines and views: each transition as the code relied on it.
@Suite struct SystemAudioAccessTests {
    @Test func followsWhatTCCSays() {
        #expect(SystemAudioAccess.unknown.next(status: .granted, tapRan: false) == .granted)
        #expect(SystemAudioAccess.granted.next(status: .denied, tapRan: false) == .refused)
        #expect(SystemAudioAccess.refused.next(status: .granted, tapRan: false) == .granted)
        #expect(SystemAudioAccess.refused.next(status: .unknown, tapRan: false) == .unknown)
    }

    @Test func aTapThatRanMeansAllowed() {
        #expect(SystemAudioAccess.unknown.next(status: nil, tapRan: true) == .granted)
        #expect(SystemAudioAccess.unknown.next(status: .unknown, tapRan: true) == .granted)
        // TCC unreadable or undecided: what was known stays, pausing doesn't take it away.
        #expect(SystemAudioAccess.granted.next(status: .unknown, tapRan: false) == .granted)
        #expect(SystemAudioAccess.refused.next(status: nil, tapRan: false) == .refused)
        // TCC's no wins over a tap that ran before it was turned off.
        #expect(SystemAudioAccess.granted.next(status: .denied, tapRan: true) == .refused)
    }
}
