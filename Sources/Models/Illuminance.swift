import Foundation

/**
# Illuminance
Illuminance is a measure of how much luminous flux is spread over a given area. One can think of luminous flux (with the unit lumen) as a measure of the total "amount" of visible light present, and the illuminance as a measure of the intensity of illumination on a surface. A given amount of light will illuminate a surface more dimly if it is spread over a larger area, so illuminance is inversely proportional to area when the luminous flux is held constant.

One lux is equal to one lumen per square metre:
 `1 lx = 1 lm/m2 = 1 cd·sr/m2`

```
| Lumen per Square Meter (lux) | Description                          |
|------------------------------|--------------------------------------|
| 0.0001 lux                   | Moonless, overcast night sky         |
| 0.002 lux                    | Moonless clear night sky             |
| 0.05 lux                     | Full moon on a clear night           |
| 3.4 lux                      | Dark limit of civil twilight         |
| 50 lux                       | Family living room                   |
| 80 lux                       | Hallway in a building                |
| 100 lux                      | Very dark overcast day               |
| 320-500 lux                  | Office lighting                      |
| 400 lux                      | Sunrise or sunset on a clear day     |
| 1000 lux                     | Overcast day                         |
| 10,000-25,000 lux            | Full daylight (not direct sun)       |
| 32,000-130,000 lux           | Direct sunlight                      |
```

 source: [wikipedia](https://en.wikipedia.org/wiki/Lux)
 */

public enum Illuminance: CaseIterable {
  case imperceptible
  case moonlessOvercastNightSky
  case moonlessClearNightSky
  case fullMoonClearNight
  case darkLimitOfCivilTwilight
  case familyLivingRoom
  case hallwayInABuilding
  case veryDarkOvercastDay
  case officeLighting
  case sunriseOrSunsetOnAClearDay
  case overcastDay
  case fullDaylightNotDirectSun
  case directSunlight
  case supernova
}

extension Illuminance {
  public var lux: Double {
    switch self {
      case .imperceptible: -Double.infinity
      case .moonlessOvercastNightSky: 0.0001
      case .moonlessClearNightSky: 0.002
      case .fullMoonClearNight: 0.05
      case .darkLimitOfCivilTwilight: 3.4
      case .familyLivingRoom: 50
      case .hallwayInABuilding: 80
      case .veryDarkOvercastDay: 100
      case .officeLighting: 320  // 320-500
      case .sunriseOrSunsetOnAClearDay: 400
      case .overcastDay: 1000
      case .fullDaylightNotDirectSun: 10_000  // 10,000-25,000
      case .directSunlight: 32_000  // 32,000-130,000
      case .supernova: Double.infinity
    }
  }
}

extension Illuminance {
  public init(lux: Float) {
    switch lux {
      case ..<0.001: self = .imperceptible
      case 0.0001..<0.002: self = .moonlessOvercastNightSky
      case 0.002..<0.05: self = .moonlessClearNightSky
      case 0.05..<3.4: self = .fullMoonClearNight
      case 3.4..<50: self = .darkLimitOfCivilTwilight
      case 50..<80: self = .familyLivingRoom
      case 80..<100: self = .hallwayInABuilding
      case 100..<320: self = .veryDarkOvercastDay
      case 320..<400: self = .officeLighting
      case 400..<1000: self = .sunriseOrSunsetOnAClearDay
      case 1000..<10_000: self = .overcastDay
      case 10_000..<32_000: self = .fullDaylightNotDirectSun
      case 32_000...130_000: self = .directSunlight
      case 130_000...: self = .supernova
      default: fatalError("Invalid lux value.")
    }
  }
}

extension Illuminance: CustomStringConvertible {
  public var description: String {
    switch self {
      case .imperceptible:
        "Imperceptible"

      case .moonlessOvercastNightSky:
        "Moonless, overcast night sky"

      case .moonlessClearNightSky:
        "Moonless clear night sky"

      case .fullMoonClearNight:
        "Full moon on a clear night"

      case .darkLimitOfCivilTwilight:
        "Dark limit of civil twilight"

      case .familyLivingRoom:
        "Family living room"

      case .hallwayInABuilding:
        "Hallway in a building"

      case .veryDarkOvercastDay:
        "Very dark overcast day"

      case .officeLighting:
        "Office lighting"

      case .sunriseOrSunsetOnAClearDay:
        "Sunrise or sunset on a clear day"

      case .overcastDay:
        "Overcast day"

      case .fullDaylightNotDirectSun:
        "Full daylight (not direct sun)"

      case .directSunlight:
        "Direct sunlight"

      case .supernova:
        "Supernova"
    }
  }
}
