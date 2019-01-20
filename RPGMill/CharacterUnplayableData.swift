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
    
    var id: String
    var imageName: String
    var image: NSImage?
    var location: LocationData
    
    init(id: String, imageName: String, location: LocationData){
        self.id = id
        self.imageName = imageName
        self.location = location
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let id = aDecoder.decodeObject(forKey: "id") as? String,
            let imageName = aDecoder.decodeObject(forKey: "image") as? String,
            let location = aDecoder.decodeObject(forKey: "location") as? LocationData
            else { return nil }
        self.init(id: id, imageName: imageName, location: location)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(imageName, forKey: "image")
        aCoder.encode(location, forKey: "location")
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
