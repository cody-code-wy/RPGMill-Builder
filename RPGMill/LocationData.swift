//
//  LocationData.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class LocationData: NSObject, NSCoding {
    
    var map: MapData
    var rotation: Int {
        didSet {
            if rotation < 1 { rotation = 1 }
            if rotation > 4 { rotation = 4 }
        }
    }
    var x: Int
    var y: Int

    override var hash : Int {
        return map.hashValue + x.hashValue + y.hashValue + rotation.hashValue
    }
    
    init(map: MapData, rotation: Int, x: Int, y: Int){
        var rotationSafe = rotation
        if rotation < 1 { rotationSafe = 1 }
        if rotation > 4 { rotationSafe = 4 }
        self.map = map
        self.rotation = rotationSafe
        self.x = x
        self.y = y
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let map = aDecoder.decodeObject(forKey: "map") as? MapData
            else { return nil }
        let rotation = aDecoder.decodeInteger(forKey: "rotation")
        let x = aDecoder.decodeInteger(forKey: "x")
        let y = aDecoder.decodeInteger(forKey: "y")
        self.init(map: map, rotation: rotation, x: x, y: y)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(map, forKey: "map")
        aCoder.encode(rotation, forKey: "rotation")
        aCoder.encode(x, forKey: "x")
        aCoder.encode(y, forKey: "y")
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let location = object as? LocationData
            else { return false }
        if self.map == location.map,
            self.rotation == location.rotation,
            self.x == location.x,
            self.y == location.y {
            return true
        }
        return false
    }
}
