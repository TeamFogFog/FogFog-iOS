//
//  NetworkMonitor.swift
//  FogFog-iOS
//
//  Created by taekki on 2023/06/07.
//

import Foundation
import Network

final class NetworkMonitor {

    @Published private(set) var status: NWPath.Status
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private let pathMonitor = NWPathMonitor()
    
    init(status: NWPath.Status = .unsatisfied) {
        self.status = status
        startPathMonitor()
    }
    
    func startPathMonitor() {
        pathMonitor.pathUpdateHandler = { path in
          DispatchQueue.main.async {
            self.status = path.status
          }
        }
        pathMonitor.start(queue: queue)
    }
    
    func stopPathMonitor() {
        pathMonitor.cancel()
    }
}
