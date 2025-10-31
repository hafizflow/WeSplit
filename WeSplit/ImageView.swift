//
//  ImageView.swift
//  WeSplit
//
//  Created by Hafizur Rahman on 1/11/25.
//

import SwiftUI

struct ImageView: View {
    @State private var isAlertShown: Bool = false
    
    var body: some View {
        ZStack {
            Image("mainBg")
                .resizable()
                .ignoresSafeArea()
            
            Button {
                isAlertShown = true
            } label: {
                Label("See Alert", systemImage: "house")
                    .padding(12)
            }
            .buttonStyle(.glass)
        }
        .alert("Alert", isPresented: $isAlertShown) {
            Button("Dismiss", role: .destructive) { isAlertShown.toggle() }
        }
    }
}

#Preview {
    ImageView()
}
