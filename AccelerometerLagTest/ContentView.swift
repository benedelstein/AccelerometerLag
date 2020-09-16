//
//  ContentView.swift
//  AccelerometerLagTest
//
//  Created by Ben Edelstein on 9/15/20.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var motionManager = MotionManager()
    private let xyMultiplier: Double = 300
    private let zMultiplier: Double = 2
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 200, height: 200)
            .foregroundColor(.pink)
            .shadow(radius: 10)
            .scaleEffect(CGFloat(1 + zMultiplier * motionManager.z))
            .offset(x: CGFloat(motionManager.x * xyMultiplier), y: CGFloat(-motionManager.y * xyMultiplier))
            .animation(.spring())
            .onDisappear {
                motionManager.stopUpdates()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
