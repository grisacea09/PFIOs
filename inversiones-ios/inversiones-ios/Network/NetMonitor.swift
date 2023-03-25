//
//  NetMonitor.swift
//  inversiones-ios
//
//  Created by Grisel Angelica Perez Quezada on 21/03/23.
//

import Foundation
import Network
 
class NetMonitor {
    static public let shared = NetMonitor()
    private var monitor: NWPathMonitor?
    private var queue = DispatchQueue.global()
    private var isMonitoring = false
    
    
    var isConnected: Bool {
           guard let monitor = monitor else { return false }
           return monitor.currentPath.status == .satisfied
       }
    
    // use it to notified that monitoring did start.
       var didStartMonitoringHandler: (() -> Void)?
       
       // use it to notified that monitoring did stopped.
       var didStopMonitoringHandler: (() -> Void)?
    // use it to monitor the network status changes.
        var netStatusChangeHandler: (() -> Void)?
    
    // current network type like cellular, wi-fi or any other...
    var interfaceType: NWInterface.InterfaceType? {
        guard let _ = monitor else { return nil }
        return self.availableInterfacesTypes?.first
    }
    
    private var availableInterfacesTypes: [NWInterface.InterfaceType]? {
        guard let monitor = monitor else { return nil }
        return monitor.currentPath.availableInterfaces.map { $0.type }
    }
 
    private init() {
        
    }
 
    func startMonitoring() {
        print("start")
        // if already monitoring, return it.
               if isMonitoring { return }
               
               monitor = NWPathMonitor()
               
               // running it on background thread, because we are continually monitoring the network.
               let queue = DispatchQueue(label: "Monitor")
               monitor?.start(queue: queue)
               monitor?.pathUpdateHandler = { [weak self] _ in
                   self!.netStatusChangeHandler?()
               }
               isMonitoring = true
               didStartMonitoringHandler?()
    }
 
    func stopMonitoring() {
        if isMonitoring, let monitor = monitor {
                    monitor.cancel()
                    self.monitor = nil
                    isMonitoring = false
                    didStopMonitoringHandler?()
                }
    }
 
    deinit {
            stopMonitoring()
        }
    
}


