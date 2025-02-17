// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/
// This file was auto-autogenerated by scripts and templates at http://github.com/AudioKit/AudioKitDevTools/

import AVFoundation
import CAudioKit

/// Reads from the table sequentially and repeatedly at given frequency.
/// Linear interpolation is applied for table look up from internal phase values.
///
public class DynamicOscillator: Node, AudioUnitContainer, Toggleable {
    /// Unique four-letter identifier "csto"
    public static let ComponentDescription = AudioComponentDescription(generator: "csto")

    /// Internal type of audio unit for this node
    public typealias AudioUnitType = InternalAU

    /// Internal audio unit
    public private(set) var internalAU: AudioUnitType?

    // MARK: - Parameters

    fileprivate var waveform: Table?

    /// Callback whten the wavetable is updated
    public var wavetableUpdateHandler: ([Float]) -> Void = { _ in }

    /// Specification details for frequency
    public static let frequencyDef = NodeParameterDef(
        identifier: "frequency",
        name: "Frequency (Hz)",
        address: akGetParameterAddress("DynamicOscillatorParameterFrequency"),
        range: 0.0 ... 20_000.0,
        unit: .hertz,
        flags: .default)

    /// Frequency in cycles per second
    @Parameter public var frequency: AUValue

    /// Specification details for amplitude
    public static let amplitudeDef = NodeParameterDef(
        identifier: "amplitude",
        name: "Amplitude",
        address: akGetParameterAddress("DynamicOscillatorParameterAmplitude"),
        range: 0.0 ... 10.0,
        unit: .generic,
        flags: .default)

    /// Output Amplitude.
    @Parameter public var amplitude: AUValue

    /// Specification details for detuningOffset
    public static let detuningOffsetDef = NodeParameterDef(
        identifier: "detuningOffset",
        name: "Frequency offset (Hz)",
        address: akGetParameterAddress("DynamicOscillatorParameterDetuningOffset"),
        range: -1_000.0 ... 1_000.0,
        unit: .hertz,
        flags: .default)

    /// Frequency offset in Hz.
    @Parameter public var detuningOffset: AUValue

    /// Specification details for detuningMultiplier
    public static let detuningMultiplierDef = NodeParameterDef(
        identifier: "detuningMultiplier",
        name: "Frequency detuning multiplier",
        address: akGetParameterAddress("DynamicOscillatorParameterDetuningMultiplier"),
        range: 0.9 ... 1.11,
        unit: .generic,
        flags: .default)

    /// Frequency detuning multiplier
    @Parameter public var detuningMultiplier: AUValue

    // MARK: - Audio Unit

    /// Internal Audio Unit for DynamicOscillator
    public class InternalAU: AudioUnitBase {
        /// Get an array of the parameter definitions
        /// - Returns: Array of parameter definitions
        override public func getParameterDefs() -> [NodeParameterDef] {
            [DynamicOscillator.frequencyDef,
             DynamicOscillator.amplitudeDef,
             DynamicOscillator.detuningOffsetDef,
             DynamicOscillator.detuningMultiplierDef]
        }

        /// Create the DSP Refence for this node
        /// - Returns: DSP Reference (Pointer to an instance of an DSPBase subclass)
        override public func createDSP() -> DSPRef {
            akCreateDSP("DynamicOscillatorDSP")
        }
    }

    // MARK: - Initialization

    /// Initialize this DynamicOscillator node
    ///
    /// - Parameters:
    ///   - waveform: The waveform of oscillation
    ///   - frequency: Frequency in cycles per second
    ///   - tremoloFrequency: Tremolo frequency in cycles per second
    ///   - amplitude: Output Amplitude.
    ///   - detuningOffset: Frequency offset in Hz.
    ///   - detuningMultiplier: Frequency detuning multiplier
    ///
    public init(
        waveform: Table = Table(.sawtooth),
        frequency: AUValue = 440.0,
        tremoloFrequency: AUValue = 1.0,
        amplitude: AUValue = 1.0,
        detuningOffset: AUValue = 0.0,
        detuningMultiplier: AUValue = 1.0)
    {
        super.init(avAudioNode: AVAudioNode())

        instantiateAudioUnit { avAudioUnit in
            self.avAudioUnit = avAudioUnit
            self.avAudioNode = avAudioUnit

            guard let audioUnit = avAudioUnit.auAudioUnit as? AudioUnitType else {
                fatalError("Couldn't create audio unit")
            }
            self.internalAU = audioUnit
            self.stop()
            audioUnit.setWavetable(waveform.content)

            self.waveform = waveform
            self.frequency = frequency
            self.amplitude = amplitude
            self.detuningOffset = detuningOffset
            self.detuningMultiplier = detuningMultiplier
        }
    }

    // MARK: - Public Methods

    /// Sets the wavetable of the oscillator node
    ///
    /// - Parameters:
    ///   - waveform: The waveform of oscillation
    public func setWaveTable(waveform: Table) {
        self.internalAU!.setWavetable(waveform.content)
        self.waveform = waveform
        self.wavetableUpdateHandler(waveform.content)
    }

    /// Gets the floating point values stored in the oscillator's wavetable
    public func getWavetableValues() -> [Float] {
        return self.waveform?.content ?? []
    }
}
