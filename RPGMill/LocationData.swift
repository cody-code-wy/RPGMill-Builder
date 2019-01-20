//
//  LocationData.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class LocationData: NSObject, NSCoding {
    
    var mapID: String
    var rotation: Int {
        didSet {
            if rotation < 1 { rotation = 1 }
            if rotation > 4 { rotation = 4 }
        }
    }
    var x: Int
    var y: Int

    init(mapID: String, rotation: Int, x: Int, y: Int){
        var rotationSafe = rotation
        if rotation < 1 { rotationSafe = 1 }
        if rotation > 4 { rotationSafe = 4 }
        self.mapID = mapID
        self.rotation = rotationSafe
        self.x = x
        self.y = y
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let mapID = aDecoder.decodeObject(forKey: "mapID") as? String
            else { return nil }
        let rotation = aDecoder.decodeInteger(forKey: "rotation")
        let x = aDecoder.decodeInteger(forKey: "x")
        let y = aDecoder.decodeInteger(forKey: "y")
        self.init(mapID: mapID, rotation: rotation, x: x, y: y)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(mapID, forKey: "mapID")
        aCoder.encode(rotation, forKey: "rotation")
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
    }
}
