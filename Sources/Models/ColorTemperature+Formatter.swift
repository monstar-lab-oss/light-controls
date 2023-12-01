import Foundation

extension ColorTemperature {
    public var measurementDescription: String {
        colorTemperatureFormatter.string(from: self.kelvin)
    }
}

var colorTemperatureFormatter: MeasurementFormatter {
    let formatter = MeasurementFormatter()
    formatter.unitStyle = .short
    formatter.unitOptions = .providedUnit
    formatter.numberFormatter.maximumFractionDigits = 0
    return formatter
}
