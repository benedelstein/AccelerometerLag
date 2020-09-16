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
                // set the reference attitude the first time
//                if self.referenceAttitude == nil {
//                    self.referenceAttitude = deviceData.attitude
//                    // on the first pass, don't set any values since
//                    // 1. they'll all be zero (by definition of reference)
//                    // 2. referenceAttitude is a reference to the current deviceData object, and if we change it by multiplying it by itself we get reference = zero (flat on table), which is not desired
//                    // then on the next update the attitude delta will not be accurate
//                } else {
//                    // get the relative attitude from the reference
//                    deviceData.attitude.multiply(byInverseOf: self.referenceAttitude!)
//                    self.magnitude = self.magnitude(from: deviceData.attitude)
//                    self.x = deviceData.attitude.pitch / self.magnitude
//                    self.y = deviceData.attitude.roll / self.magnitude
//                    self.z = deviceData.attitude.yaw / self.magnitude
//                    print("Roll: \(self.degrees(deviceData.attitude.roll)), Pitch: \(self.degrees(deviceData.attitude.pitch)), Yaw: \(self.degrees(deviceData.attitude.yaw))")
//                }
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
