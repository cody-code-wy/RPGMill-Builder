//
//  MapData.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class MapData: NSObject, NSCoding {
    
    static let defaultTileSize = 100
    static let keyName = "maps"
    
    var id: String
    var imageName: String
    var image: NSImage?
    var tileSize: Int
    
    init(id: String, imageName: String, tileSize: Int){
        self.id = id
        self.imageName = imageName
        self.tileSize = tileSize
    }
    
    convenience init(id: String, tileSize: Int){
        self.init(id: id, imageName: "map_\(UUID().uuidString).tiff", tileSize: tileSize)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let imageName = aDecoder.decodeObject(forKey: "image") as? String
            else { return nil }
        let tileSize = aDecoder.decodeInteger(forKey: "tileSize")
        self.init(id: id, imageName: imageName, tileSize: tileSize)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(imageName, forKey: "image")
        aCoder.encode(tileSize, forKey: "tileSize")
    }
    
}

extension MapData: OverviewItem {
    func viewFor(outlineView: NSOutlineView, tableColumn: NSTableColumn?) -> NSView? {
        if let itemCell = outlineView.makeView(withIdentifier: .itemCell, owner: self) as? NSTableCellView {
            itemCell.textField?.stringValue = self.id
            return itemCell
        }
        return nil
        
    }
}

extension Array where Element: MapData {
    func findByID(id: String) -> MapData? {
        for map in self as [MapData] {
            if map.id == id {
                return map
            }
        }
        return nil
    }
}
