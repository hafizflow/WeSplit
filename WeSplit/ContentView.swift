
import SwiftUI

struct ContentView: View {
    @State private var amount: Double = 0.0
    @State private var isExpanded: Bool = true
    @State private var numberOfPeople: Int = 2
    @State private var tipPercetage: Int = 20
    @FocusState private var isAmountFocused: Bool
    @Environment(\.colorScheme) private var scheme
    
    @State private var selectedDate = Date()
    
    var expenseForeach: Double {
        let selectedPeople = Double(numberOfPeople + 2)
        let selectedTip = Double(tipPercetage) / 100.0
        
        let totalTip = amount * selectedTip
        let totalAmount = amount + totalTip
        
        return totalAmount / selectedPeople
    }
    
    
    var totalAmount: Double {
        let selectedTip = Double(tipPercetage) / 100.0
        let totalTip = amount * selectedTip
        let totalAmount = amount + totalTip
        
        return totalAmount
    }
    
    
    let tipPercetages = [10, 15, 20, 25, 0]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(isExpanded: $isExpanded) {
                    TextField("Amount", value: $amount, format: .currency(code: Locale.current.currency?.identifier ?? "BDT"))
                        .keyboardType(.decimalPad)
                        .transition(.opacity.combined(with: .slide))
                        .animation(.easeInOut(duration: 0.3), value: isExpanded)
                        .focused($isAmountFocused)
                    
                    
                    
                    Picker("Number of people", selection: $numberOfPeople) {
                        ForEach(2..<101) {
                            Text("\($0) people")
                        }
                    }
                } header: {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isExpanded.toggle()
                        }
                    } label: {
                        HStack {
                            Text("Hello")
                                .font(.title)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "chevron.up")
                                .rotationEffect(.degrees(isExpanded ? 0 : 180))
                                .animation(.easeInOut(duration: 0.25), value: isExpanded)
                                .foregroundStyle(.primary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                
                Section("How much do you want to tip?") {
                    Picker("Tip percent", selection: $tipPercetage) {
                        ForEach(tipPercetages, id: \.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section ("Total amount for the check") {
                    Text(totalAmount, format: .currency(code: Locale.current.currency?.identifier ?? "BDT"))
                        .zeroTip(tipPercetage)
                }
                
                Section("Amount per person") {
                    Text(expenseForeach, format: .currency(code: Locale.current.currency?.identifier ?? "BDT"))
                }
                
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .tint(scheme == .light ? .black : .white)
                
            }
            .navigationTitle("WeSplit")
            .toolbar {
                if isAmountFocused {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        
                        Button("", systemImage: "return", action: { isAmountFocused = false})
                            .labelStyle(.iconOnly)
                            .contentShape(Rectangle())
                    }
                }
                
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("", systemImage: "square.and.pencil", action: { UIImpactFeedbackGenerator(style: .medium).impactOccurred()})
                        .labelStyle(.iconOnly)
                        .contentShape(Rectangle())
                    
                    Button("", systemImage: "wifi", action: { UIImpactFeedbackGenerator(style: .medium).impactOccurred() })
                        .labelStyle(.iconOnly)
                        .contentShape(Rectangle())
                    
                    Button("", systemImage: "return", action: { UIImpactFeedbackGenerator(style: .medium).impactOccurred() })
                        .labelStyle(.iconOnly)
                        .contentShape(Rectangle())
                }
            }
        }
    }
}

#Preview {
    ContentView()
}


struct ZeroTip: ViewModifier {
    var tipPercetage: Int
    
    func body(content: Content) -> some View {
        if tipPercetage == 0 {
            content.foregroundStyle(.red)
        } else {
            content
        }
    }
}


extension View {
    func zeroTip(_ tipPercetage: Int) -> some View {
        modifier(ZeroTip(tipPercetage: tipPercetage))
    }
}
