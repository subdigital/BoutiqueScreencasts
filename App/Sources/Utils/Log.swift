//
//  File.swift
//  
//
//  Created by Ben Scheirman on 6/26/22.
//

import os.log

extension Logger {
    public static var `default`: Logger {
        .init(subsystem: "com.nsscreencast.boutique-episodes", category: "Default")
    }
}
