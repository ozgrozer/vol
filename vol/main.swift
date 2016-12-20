import Foundation
import AudioToolbox

var arguments = [String]()

for argument in CommandLine.arguments {
    arguments.append(argument)
}

arguments.remove(at: 0)

let volumeParameter = (arguments.count > 0) ? arguments[0] : "0"
let volumeInt:Int = (volumeParameter != "") ? Int(volumeParameter)! : 0
let volumeFloat:Float = Float(volumeInt) / Float(100)

print("int: \(volumeInt)")
print("float: \(volumeFloat)")

var volume = Float32(volumeFloat) // 0.0 ... 1.0
let volumeSize = UInt32(MemoryLayout.size(ofValue: volume))

var defaultOutputDeviceID = AudioDeviceID(0)
var defaultOutputDeviceIDSize = UInt32(MemoryLayout.size(ofValue: defaultOutputDeviceID))

var getDefaultOutputDevicePropertyAddress = AudioObjectPropertyAddress(
    mSelector: AudioObjectPropertySelector(kAudioHardwarePropertyDefaultOutputDevice),
    mScope: AudioObjectPropertyScope(kAudioObjectPropertyScopeGlobal),
    mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
)

_ = AudioObjectGetPropertyData(
    AudioObjectID(kAudioObjectSystemObject),
    &getDefaultOutputDevicePropertyAddress,
    0,
    nil,
    &defaultOutputDeviceIDSize,
    &defaultOutputDeviceID
)

var volumePropertyAddress = AudioObjectPropertyAddress(
    mSelector: AudioObjectPropertySelector(kAudioHardwareServiceDeviceProperty_VirtualMasterVolume),
    mScope: AudioObjectPropertyScope(kAudioDevicePropertyScopeOutput),
    mElement: AudioObjectPropertyElement(kAudioObjectPropertyElementMaster)
)

let result = AudioObjectSetPropertyData(defaultOutputDeviceID, &volumePropertyAddress, 0, nil, volumeSize, &volume)

if result != nil {
    print("adjusted :)")
} else {
    print("error :(")
}
