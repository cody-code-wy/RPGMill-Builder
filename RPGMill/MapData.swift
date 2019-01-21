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
    
    static var uuid: String {
        return "map_\(UUID().uuidString)"
    }
    
    unowned var parent: GameData
    
    @objc var id: String {
        didSet {
            guard id != oldValue else { return }
            parent.undoManager?.setActionName("Change Map Name")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: MapData.id), object: oldValue)
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
    
    var imageName: String {
        return "\(uuid).tiff"
    }
    
    var rtfName: String {
        return "\(uuid).rtf"
    }
    
    let uuid: String
    
    var rtf: Data?
    
    // Needed as using selector (setter: tileSize) with undoManager results in incorrect values
    @objc func setTileSize(input: Any){
        if let tileSize = input as? Int {
            self.tileSize = tileSize
        }
    }
    
    init(id: String, uuid: String, tileSize: Int, rtfd: Data?, gameData: GameData){
        self.id = id
        self.uuid = uuid
        self.tileSize = tileSize
        self.rtf = rtfd
        self.parent = gameData
    }
    
    convenience init(id: String, tileSize: Int, rtfd: Data?, gameData: GameData){
        self.init(id: id, uuid: MapData.uuid, tileSize: tileSize, rtfd: rtfd, gameData: gameData)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let uuid = aDecoder.decodeObject(forKey: "uuid") as? String,
            let gameData = aDecoder.decodeObject(forKey: "gameData") as? GameData
            else { return nil }
        let tileSize = aDecoder.decodeInteger(forKey: "tileSize")
        self.init(id: id, uuid: uuid, tileSize: tileSize, rtfd: nil, gameData: gameData)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(tileSize, forKey: "tileSize")
        aCoder.encode(parent, forKey: "gameData")
    }
    
    func readFileWrapper(fileWrapper: FileWrapper) {
        if let imageData = fileWrapper.fileWrappers?[imageName]?.regularFileContents {
            self.image = NSImage(data: imageData)
        }
        if let rtf = fileWrapper.fileWrappers?[rtfName]?.regularFileContents {
            self.rtf = rtf
        }
    }
    
    func fileWrapper() -> FileWrapper? {
        var items = [String:FileWrapper]()
        if let image = image?.tiffRepresentation {
            items[imageName] = FileWrapper(regularFileWithContents: image)
        }
        if let rtf = rtf {
            items[rtfName] = FileWrapper(regularFileWithContents: rtf)
        }
        return FileWrapper(directoryWithFileWrappers: items)
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
