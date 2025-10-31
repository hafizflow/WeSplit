import SwiftUI

struct StackView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color("bg").ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(0..<6) { _ in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Name: \(["Hafiz", "Anjum", "Nishat"].randomElement()!)")
                                Text("Age: \(Int.random(in: 22...26))")
                                Text("University: \(["City", "DIU", "KU"].randomElement()!)")
                                Text("CGPA: \(["3.83", "3.85", "3.88"].randomElement()!)")
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                    }
                    .padding()
                }
               
            }
            .navigationTitle("Stack View")
            .navigationBarTitleDisplayMode(.large)
            .navigationSubtitle("Playing with ZStack")
        }
    }
}

#Preview {
    StackView()
}
