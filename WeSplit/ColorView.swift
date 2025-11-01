//
//  ColorView.swift
//  WeSplit
//
//  Created by Hafizur Rahman on 31/10/25.
//

import SwiftUI

struct ColorView: View {
    var body: some View {
             
        LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
        
        LinearGradient(stops: [
            .init(color: .teal, location: 0.01),
            .init(color: .indigo, location: 1.2)
        ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        
        
        RadialGradient(colors: [.teal, .black], center: .bottom, startRadius: 0, endRadius: 200)
            .ignoresSafeArea()
        
        
        ZStack {
            AngularGradient(colors: [.teal, .red, .green, .purple, .orange, .blue], center: .center)
                .ignoresSafeArea()
            
            Text("Hafiz")
                .padding(40)
                .background(
                    ZStack {
                        CustomBlur(style: .systemMaterial, intensity: 0.5)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                )
                .cornerRadius(20)
            
            
            Text("Hafiz")
                .padding(40)
                .background(.blue.gradient)
                .cornerRadius(20)
        }
        
    }
}

#Preview {
    ColorView()
}
