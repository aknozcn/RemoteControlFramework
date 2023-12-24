//
//  RemoteControl.swift
//  RemoteControl
//
//  Created by Akın Özcan on 4.12.2023.
//

import Foundation
import AudioToolbox
import AppKit

public class RemoteControl {
    public static let shared = RemoteControl()
    private init() { }
    
    private var tempVolume: Float32 = 0.0
    
    public func setVolume(_ volume: Float32) {
        var defaultOutputDeviceID = AudioDeviceID(0)
        var size = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))

        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMain)
        )

        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
                &getDefaultOutputDevicePropertyAddress,
            0,
            nil,
                &size,
                &defaultOutputDeviceID
        )

        var volume = volume
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwareServiceDeviceProperty_VirtualMainVolume),
            mScope: AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
            mElement: AudioObjectPropertyElement(0)
        )

        AudioObjectSetPropertyData(
            defaultOutputDeviceID,
                &volumePropertyAddress,
            0,
            nil,
            UInt32(MemoryLayout.size(ofValue: volume)),
                &volume
        )
        
        if volume > 0 {
            tempVolume = volume
        }
    }
    
    public func getCurrentVolume() -> Float32 {
        var defaultOutputDeviceID = AudioDeviceID(0)
        var size = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))
        
        var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice),
            mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
            mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMain)
        )
        
        AudioObjectGetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &getDefaultOutputDevicePropertyAddress,
            0,
            nil,
            &size,
            &defaultOutputDeviceID
        )
        
        var volume: Float32 = 0.0
        var volumePropertyAddress = AudioObjectPropertyAddress(
            mSelector: AudioObjectPropertySelector(kAudioHardwareServiceDeviceProperty_VirtualMainVolume),
            mScope: AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
            mElement: AudioObjectPropertyElement(0)
        )
        
        AudioObjectGetPropertyData(
            defaultOutputDeviceID,
            &volumePropertyAddress,
            0,
            nil,
            &size,
            &volume
        )
        
        return volume
    }
    
    public func getTempVolume() -> Float32 {
        return tempVolume
    }
}
