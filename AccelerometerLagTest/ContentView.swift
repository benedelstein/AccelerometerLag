//
//  ContentView.swift
//  AccelerometerLagTest
//
//  Created by Ben Edelstein on 9/15/20.
//

import SwiftUI

struct ContentView: View {
    @State private var motionManager = MotionManager()

    private let xyMultiplier: Double = 400
    private let maxXY: Double = 100 // max pts to move over in xy plane
    private let zMultiplier: Double = 2
    private let minAcceleration: Double = 0.0 // minimum acceleration to trigger a shift

    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .frame(width: 200, height: 200)
            .foregroundStyle(.pink)
            .shadow(radius: 10)
            .scaleEffect(scale)
            .offset(x: offsetX, y: offsetY)
            .animation(.spring, value: scale)
            .animation(.spring, value: offsetX)
            .animation(.spring, value: offsetY)
            .onDisappear {
                motionManager.stopUpdates()
            }
    }

    private var scale: Double {
        guard abs(motionManager.z) > minAcceleration else { return 1.0 }
        return max(0.5, min(1 + zMultiplier * motionManager.z, 2.0))
    }

    private var offsetX: Double {
        guard abs(motionManager.x) > minAcceleration else { return 0 }
        return clipped(value: motionManager.x * xyMultiplier, maxValue: maxXY)
    }

    private var offsetY: Double {
        guard abs(motionManager.y) > minAcceleration else { return 0 }
        return clipped(value: -motionManager.y * xyMultiplier, maxValue: maxXY)
    }

    private func clipped(value: Double, maxValue: Double) -> Double {
        max(min(value, maxValue), -maxValue)
    }
}

#Preview {
    ContentView()
}
