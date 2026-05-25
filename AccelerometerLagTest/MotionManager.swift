//
//  MotionManager.swift
//  ImageSkew
//
//  Created by Ben Edelstein on 7/19/20.
//

import Foundation
import CoreMotion
import Observation

@Observable
final class MotionManager {

    var x: Double = 0.0
    var y: Double = 0.0
    var z: Double = 0.0
    var magnitude: Double = 0.0

    @ObservationIgnored
    private let motionManager = CMMotionManager()

    init() {
        motionManager.deviceMotionUpdateInterval = 1 / 100
        guard motionManager.isDeviceMotionAvailable else { return }
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] deviceData, error in
            guard let self else { return }
            if let error {
                print(error)
                return
            }
            guard let deviceData else { return }
            let userAccel = deviceData.userAcceleration
            self.x = userAccel.x
            self.y = userAccel.y
            self.z = userAccel.z
            self.magnitude = Self.magnitude(from: userAccel)
        }
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }

    static func magnitude(from acceleration: CMAcceleration) -> Double {
        sqrt(acceleration.x * acceleration.x
             + acceleration.y * acceleration.y
             + acceleration.z * acceleration.z)
    }

    func stopUpdates() {
        x = 0
        y = 0
        z = 0
        magnitude = 0
        motionManager.stopDeviceMotionUpdates()
    }
}
