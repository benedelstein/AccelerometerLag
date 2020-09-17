//
//  MotionManager.swift
//  ImageSkew
//
//  Created by Ben Edelstein on 7/19/20.
//
import Foundation
import Combine
import CoreMotion

class MotionManager: ObservableObject {

    private var motionManager: CMMotionManager
    @Published var x: Double = 0.0
    @Published var y: Double = 0.0
    @Published var z: Double = 0.0
    @Published var magnitude: Double = 0.0


    init() {
        self.motionManager = CMMotionManager()
        self.motionManager.deviceMotionUpdateInterval = 1/100
        guard self.motionManager.isDeviceMotionAvailable else {return}
        self.motionManager.startDeviceMotionUpdates(to: .main) { (deviceData, error) in
            guard error == nil else {
                print(error!)
                return
            }
            if let deviceData = deviceData {
                let userAccel = deviceData.userAcceleration
                self.x = userAccel.x
                self.y = userAccel.y
                self.z = userAccel.z
                self.magnitude = self.magnitude(from: userAccel)
                print(userAccel)
            }
        }
    }
    
    func magnitude(from acceleration: CMAcceleration) -> Double {
        return sqrt(pow(acceleration.x,2) + pow(acceleration.y,2) + pow(acceleration.z,2))
    }
    
    func stopUpdates() {
        x = 0
        y = 0
        z = 0
        magnitude = 0
        self.motionManager.stopDeviceMotionUpdates()
    }
}
