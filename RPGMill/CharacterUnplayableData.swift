//
//  CharacterUnplayableData.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class CharacterUnplayableData: NSObject, NSCoding {

    static let keyName = "characterUnplayables"
    
    unowned var parent: GameData
    
    @objc var id: String {
        didSet {
            guard id != oldValue else { return }
            parent.undoManager?.setActionName("Change NPC Name")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: MapData.id), object: oldValue)
        }
    }
    @objc var imageName: String {
        didSet {
            guard imageName != oldValue else { return }
            parent.undoManager?.setActionName("Change NPC ImageName")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: imageName), object: oldValue)
        }
    }
    @objc var image: NSImage? {
        didSet {
            guard image != oldValue else { return }
            parent.undoManager?.setActionName("Change NPC Image")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: image), object: oldValue)
        }
    }
    @objc var location: LocationData {
        didSet {
            guard location != oldValue else { return }
            parent.undoManager?.setActionName("Change NPC Location")
            parent.undoManager?.registerUndo(withTarget: self, selector: #selector(setter: location), object: oldValue)
        }
    }
    
    init(id: String, imageName: String, location: LocationData, gameData: GameData){
        self.id = id
        self.imageName = imageName
        self.location = location
        self.parent = gameData
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let imageName = aDecoder.decodeObject(forKey: "image") as? String,
            let location = aDecoder.decodeObject(forKey: "location") as? LocationData,
            let gameData = aDecoder.decodeObject(forKey: "gameData") as? GameData
            else { return nil }
        self.init(id: id, imageName: imageName, location: location, gameData: gameData)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(imageName, forKey: "image")
        aCoder.encode(location, forKey: "location")
        aCoder.encode(parent, forKey: "gameData")
    }
    
}

extension CharacterUnplayableData: OverviewItem {
    func viewFor(outlineView: NSOutlineView, tableColumn: NSTableColumn?) -> NSView? {
        if let itemCell = outlineView.makeView(withIdentifier: .itemCell, owner: self) as? NSTableCellView {
            itemCell.textField?.stringValue = self.id
            return itemCell
        }
        return nil
        
    }
}
