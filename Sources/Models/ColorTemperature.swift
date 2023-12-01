import Foundation

/// List of color presets ordered by kelvin degrees
///
/// In digital photography, the term color temperature sometimes refers to remapping of color values to simulate variations in ambient color temperature.
///
/// | **Temperature**                  | **Source**  |
/// | ---------------------------------- | --------------------------------------------------------------------------------------------------- |
/// | 1700 K                                     | Match flame, low pressure sodium lamps (LPS/SOX) |
/// | 1850 K                                     | Candle flame, sunset/sunrise |
/// | 2400 K                                     | Standard incandescent lamps |
/// | 2550 K                                     | Soft white incandescent lamps |
/// | 2700 K                                     | "Soft white" compact fluorescent and LED lamps |
/// | 3000 K                                     | Warm white compact fluorescent and LED lamps |
/// | 3200 K                                     | Studio lamps, photofloods, etc. |
/// | 3350 K                                     | Studio "CP" light |
/// | 5000 K                                     | Horizon daylight |
/// | 5000 K                                     | Tubular fluorescent lamps or cool white / daylight compact fluorescent lamps (CFL) |
/// | 5500 – 6000 K                         | Vertical daylight, electronic flash |
/// | 6200 K                                     | Xenon short-arc lamp |
/// | 6500 K                                     | Daylight, overcast |
/// | 6500 – 9500 K                         | LCD or CRT screen |
/// | 15,000 – 27,000 K                   | Clear blue poleward sky |
/// | *These temperatures are merely characteristic; there may be considerable variation* |
///
/// source: [ wikipedia](https://en.wikipedia.org/wiki/Color_temperature)

public enum ColorTemperature: CaseIterable {
  case flameMatch
  case flameCandle
  case incandescentStandard
  case incandescentSoftWhite
  case fluorescentSoftWhite
  case fluorescentWarmWhite
  case studioLamp
  case studioCPLight
  case daylight
  case daylightLamp
  case daylightVertical
  case xenon
  case daylightOvercast
  case lcd
  case clearBlueSky
}

extension ColorTemperature {
  public var kelvin: Measurement<UnitTemperature> {
    switch self {
      case .flameMatch:
        return .init(value: 1700, unit: .kelvin)

      case .flameCandle:
        return .init(value: 1850, unit: .kelvin)

      case .incandescentStandard:
        return .init(value: 2400, unit: .kelvin)

      case .incandescentSoftWhite:
        return .init(value: 2550, unit: .kelvin)

      case .fluorescentSoftWhite:
        return .init(value: 2700, unit: .kelvin)

      case .fluorescentWarmWhite:
        return .init(value: 3000, unit: .kelvin)

      case .studioLamp:
        return .init(value: 3200, unit: .kelvin)

      case .studioCPLight:
        return .init(value: 3350, unit: .kelvin)

      case .daylight:
        return .init(value: 5000, unit: .kelvin)

      case .daylightLamp:
        return .init(value: 5000, unit: .kelvin)

      case .daylightVertical:
        return .init(value: 5500, unit: .kelvin)

      case .xenon:
        return .init(value: 6200, unit: .kelvin)

      case .daylightOvercast:
        return .init(value: 6500, unit: .kelvin)

      case .lcd:
        return .init(value: 9500, unit: .kelvin)

      case .clearBlueSky:
        return .init(value: 27000, unit: .kelvin)
    }
  }
}

extension ColorTemperature: CustomStringConvertible {
  public var description: String {
    switch self {
      case .flameMatch:
        return "Match Flame"

      case .flameCandle:
        return "Candle Flame"

      case .incandescentStandard:
        return "Incandescent"

      case .incandescentSoftWhite:
        return "Incandescent Soft White"

      case .fluorescentSoftWhite:
        return "Fluorescent"

      case .fluorescentWarmWhite:
        return "Fluorescent Warm White"

      case .studioLamp:
        return "Studio Lamp"

      case .studioCPLight:
        return "Studio CP Light"

      case .daylight:
        return "Daylight"

      case .daylightLamp:
        return "Daylight Lamp"

      case .daylightVertical:
        return "Daylight Vertical"

      case .xenon:
        return "Xenon"

      case .daylightOvercast:
        return "Daylight Overcast"

      case .lcd:
        return "LCD"

      case .clearBlueSky:
        return "Clear Blue Sky"
    }
  }
}
