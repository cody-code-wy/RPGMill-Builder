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
    
    unowned var parent: GameData
    
    @objc var id: String {
        didSet {
            guard id != oldValue else { return }
            parent.undoManager?.setActionName("Change Map Name")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: MapData.id), object: oldValue)
        }
    }
    @objc var imageName: String {
        didSet {
            guard imageName != oldValue else { return }
            parent.undoManager?.setActionName("Change Map ImageName")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: imageName), object: oldValue)
        }
    }
    @objc var image: NSImage? {
        didSet {
            guard image != oldValue else { return }
            parent.undoManager?.setActionName("Change Map Image")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: image), object: oldValue)
        }
    }
    
    @objc var tileSize: Int {
        didSet {
            guard tileSize != oldValue else { return }
            parent.undoManager?.setActionName("Change Map Tile Size")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setTileSize(input:)), object: oldValue)
        }
    }
    
    // Needed as using selector (setter: tileSize) with undoManager results in incorrect values
    @objc func setTileSize(input: Any){
        if let tileSize = input as? Int {
            self.tileSize = tileSize
        }
    }
    
    init(id: String, imageName: String, tileSize: Int, gameData: GameData){
        self.id = id
        self.imageName = imageName
        self.tileSize = tileSize
        self.parent = gameData
    }
    
    convenience init(id: String, tileSize: Int, gameData: GameData){
        self.init(id: id, imageName: "map_\(UUID().uuidString).tiff", tileSize: tileSize, gameData: gameData)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let imageName = aDecoder.decodeObject(forKey: "image") as? String,
            let gameData = aDecoder.decodeObject(forKey: "gameData") as? GameData
            else { return nil }
        let tileSize = aDecoder.decodeInteger(forKey: "tileSize")
        self.init(id: id, imageName: imageName, tileSize: tileSize, gameData: gameData)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(imageName, forKey: "image")
        aCoder.encode(tileSize, forKey: "tileSize")
        aCoder.encode(parent, forKey: "gameData")
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
