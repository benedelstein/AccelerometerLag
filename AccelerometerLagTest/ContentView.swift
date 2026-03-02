//
//  ContentView.swift
//  AccelerometerLagTest
//
//  Created by Ben Edelstein on 9/15/20.
//

import SwiftUI

struct ContentView: View {
    @StateObject var motionManager = MotionManager()
    private let xyMultiplier: Double = 400
    private let maxXY: Double = 100 // max pts to move over in xy plane
    private let zMultiplier: Double = 2
    private let minAcceleration: Double = 0.0 // minimum acceleration to trigger a shift
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 200, height: 200)
            .foregroundColor(.pink)
            .shadow(radius: 10)
            .scaleEffect(abs(motionManager.z) > minAcceleration ? CGFloat(max(0.5, min(1 + zMultiplier * motionManager.z, 2.0))) : 1.0)
            .offset(
                x: abs(motionManager.x) > minAcceleration ? CGFloat(clipped(value: motionManager.x * xyMultiplier, maxValue: maxXY)) : 0,
                y: abs(motionManager.y) > minAcceleration ? CGFloat(clipped(value: -motionManager.y * xyMultiplier, maxValue: maxXY)) : 0
            )
            .animation(.spring())
            .onDisappear {
                motionManager.stopUpdates()
            }
    }
    
    private func clipped(value: Double, maxValue: Double) -> Double {
        return max(min(value, maxValue), -maxValue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
