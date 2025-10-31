import SwiftUI

struct ConvertView: View {
    @State private var fromTime: String = "seconds"
    @State private var toTime: String = "minutes"
    @State private var inputTime: Double = 0.0
    
    let fromTimes = ["seconds", "minutes", "hours", "days"]
    
    var calculatedValue: Double {
        let inputSeconds: Double
        switch fromTime {
            case "seconds": inputSeconds = inputTime
            case "minutes": inputSeconds = inputTime * 60
            case "hours":   inputSeconds = inputTime * 3600
            case "days":    inputSeconds = inputTime * 86400
            default:        inputSeconds = 0
        }
        
        switch toTime {
            case "seconds": return inputSeconds
            case "minutes": return inputSeconds / 60
            case "hours":   return inputSeconds / 3600
            case "days":    return inputSeconds / 86400
            default:        return 0
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Convert Time") {
                    HStack {
                        Picker("From", selection: $fromTime) {
                            ForEach(fromTimes, id: \.self) { Text($0) }
                        }
                        
                        Spacer()
                        Divider().padding(.horizontal)
                        Spacer()
                        
                        Picker("To", selection: $toTime) {
                            ForEach(fromTimes, id: \.self) { Text($0) }
                        }
                    }
                }
                
                Section("Enter Input") {
                    TextField("Enter time to convert", value: $inputTime, format: .number)
                        .keyboardType(.decimalPad)
                }
                
                Section("Calculated Value") {
                    Text("\(calculatedValue, specifier: "%.4f") \(toTime)")
                }
            }
            .navigationTitle("Time Converter")
        }
    }
}

#Preview {
    ConvertView()
}
