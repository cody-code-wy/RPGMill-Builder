//
//  GameData.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class GameData: NSObject, NSCoding {

    var maps = [MapData]()
    var characters = [CharacterPlayableData]()
    var npcs = [CharacterUnplayableData]()
    
    init(maps: [MapData], characters: [CharacterPlayableData], npcs: [CharacterUnplayableData]){
        self.maps = maps
        self.characters = characters
        self.npcs = npcs
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let maps = aDecoder.decodeObject(forKey: "maps") as? [MapData],
            let characters = aDecoder.decodeObject(forKey: "characterPlayables") as? [CharacterPlayableData],
            let npcs = aDecoder.decodeObject(forKey: "characterUnplayables") as? [CharacterUnplayableData]
            else { return nil }
        self.init(maps: maps, characters: characters, npcs: npcs)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(maps, forKey: "maps")
        aCoder.encode(characters, forKey: "characterPlayables")
        aCoder.encode(npcs, forKey: "characterUnplayables")
    }
    
    func loadFileWrapper(fileWrapper: FileWrapper) {
        if let mapImages = fileWrapper.fileWrappers?["mapImages"] {
            for map in maps {
                if let image = mapImages.fileWrappers?[map.imageName]?.regularFileContents {
                    map.image = NSImage(data: image)
                }
            }
        }
        
    }
    
    func fileWrapper() -> FileWrapper {
        var gameData = [String: FileWrapper]()
        var mapImages = [String: FileWrapper]()
        for map in maps {
            if let image = map.image?.tiffRepresentation {
                mapImages[map.imageName] = FileWrapper(regularFileWithContents: image)
            }
        }
        gameData["mapImages"] = FileWrapper(directoryWithFileWrappers: mapImages)
        return FileWrapper(directoryWithFileWrappers: gameData)
    }
    
}
