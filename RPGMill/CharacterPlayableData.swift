//
//  CharacterPlayableData.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class CharacterPlayableData: NSObject, NSCoding {

    static let keyName = "characterPlayables"
    
    unowned var parent: GameData
    
    @objc var id: String {
        didSet {
            guard id != oldValue else { return }
            parent.undoManager?.setActionName("Change Character Name")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: MapData.id), object: oldValue)
        }
    }
    @objc var image: NSImage? {
        didSet {
            guard image != oldValue else { return }
            parent.undoManager?.setActionName("Change Character Image")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: image), object: oldValue)
        }
    }
    @objc var location: LocationData {
        didSet {
            guard location != oldValue else { return }
            parent.undoManager?.setActionName("Change Character Location")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: location), object: oldValue)
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
    
    init(id: String, uuid: String, location: LocationData, rtf: Data?, gameData: GameData){
        self.id = id
        self.uuid = uuid
        self.location = location
        self.rtf = rtf
        self.parent = gameData
    }
    
    convenience init(id: String, location: LocationData, rtf: Data?, gameData: GameData){
        self.init(id: id, uuid: "character_\(UUID().uuidString)", location: location, rtf: rtf, gameData: gameData)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let uuid = aDecoder.decodeObject(forKey: "uuid") as? String,
            let location = aDecoder.decodeObject(forKey: "location") as? LocationData,
            let gameData = aDecoder.decodeObject(forKey: "gameData") as? GameData
            else { return nil }
        self.init(id: id, uuid: uuid, location: location, rtf: nil, gameData: gameData)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(location, forKey: "location")
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

extension CharacterPlayableData: OverviewItem {
    func viewFor(outlineView: NSOutlineView, tableColumn: NSTableColumn?) -> NSView? {
        if let itemCell = outlineView.makeView(withIdentifier: .itemCell, owner: self) as? NSTableCellView {
            itemCell.textField?.stringValue = self.id
            return itemCell
        }
        return nil
        
    }
}
