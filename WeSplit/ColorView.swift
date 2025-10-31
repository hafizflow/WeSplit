//
//  ColorView.swift
//  WeSplit
//
//  Created by Hafizur Rahman on 31/10/25.
//

import SwiftUI

struct ColorView: View {
    var body: some View {
        
//        
//        LinearGradient(colors: [.red, .blue], startPoint: .top, endPoint: .bottom)
//            .ignoresSafeArea()
//        
//        LinearGradient(stops: [
//            .init(color: .teal, location: 0.01),
//            .init(color: .indigo, location: 1.2)
//        ], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
        
        
//        RadialGradient(colors: [.teal, .black], center: .bottom, startRadius: 0, endRadius: 200)
//            .ignoresSafeArea()
        
        
        ZStack {
            AngularGradient(colors: [.teal, .red, .green, .purple, .orange, .blue], center: .center)
                .ignoresSafeArea()
            
//            Text("Hafiz")
//                .padding(40)
//                .background(
//                    ZStack {
//                        CustomBlur(style: .systemThinMaterial, intensity: 0.6)
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                    }
//                )
//                .cornerRadius(20)
            
            
            Text("Hafiz")
                .padding(40)
                .background(.blue.gradient)
                .cornerRadius(20)
            
        }
    }
}


struct CustomBlur: UIViewRepresentable {
    let style: UIBlurEffect.Style
    let intensity: CGFloat
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        view.alpha = intensity
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
        uiView.alpha = intensity
    }
}

#Preview {
    ColorView()
}
