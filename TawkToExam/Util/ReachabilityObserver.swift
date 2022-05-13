//
//  ReachabilityObserver.swift
//  TawkToExam
//
//  Created by Nico Adrianne Dioso on 4/21/21.
//

import Foundation
import SystemConfiguration

class ReachabilityObserver {
    static let shared = ReachabilityObserver()
    
    private var timer: Timer?
    
    var isConnected: Bool = true {
        didSet(oldValue) {
            if oldValue != isConnected {
                let object = ["state": isConnected]
                NotificationCenter.default.post(name: .networkConnectionChanged, object: object)
                if isConnected {
                    print("Log || Network connection restored")
                } else {
                    print("Log || Network connection lost")
                }
            }
        }
    }
    
//    static func 
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateNetworkConnection), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    
    func waitForConnection(then completion: @escaping ()->()) {
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                print("Log || waiting for \(self.isConnectedToNetwork())")
                if self.isConnectedToNetwork() {
                    completion()
                    timer.invalidate()
                }
            }
        }
    }
    
    @objc func updateNetworkConnection() {
        isConnected = isConnectedToNetwork()
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        /* Only Working for WIFI
        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
        */

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        return ret
    }
}
