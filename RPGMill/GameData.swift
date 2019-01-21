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
    
    var undoManager: UndoManager?
        
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
        if let characterImages = fileWrapper.fileWrappers?["characterPlayableImages"] {
            for character in characters {
                if let image = characterImages.fileWrappers?[character.imageName]?.regularFileContents {
                    character.image = NSImage(data: image)
                }
            }
        }
        if let npcImages = fileWrapper.fileWrappers?["characterUnplayableImages"] {
            for npc in npcs {
                if let image = npcImages.fileWrappers?[npc.imageName]?.regularFileContents {
                    npc.image = NSImage(data: image)
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
        var characterImages = [String: FileWrapper]()
        for character in characters {
            if let image = character.image?.tiffRepresentation {
                characterImages[character.imageName] = FileWrapper(regularFileWithContents: image)
            }
        }
        var npcImages = [String: FileWrapper]()
        for npc in npcs {
            if let image = npc.image?.tiffRepresentation {
                npcImages[npc.imageName] = FileWrapper(regularFileWithContents: image)
            }
        }
        gameData["mapImages"] = FileWrapper(directoryWithFileWrappers: mapImages)
        gameData["characterPlayableImages"] = FileWrapper(directoryWithFileWrappers: characterImages)
        gameData["characterUnplayableImages"] = FileWrapper(directoryWithFileWrappers: npcImages)
        return FileWrapper(directoryWithFileWrappers: gameData)
    }
    
    @objc func addMap(map: MapData) {
        maps.append(map)
        undoManager?.setActionName("Create Map")
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeMap(map:)), object: map)
    }
    
    @objc func removeMap(map: MapData) {
        if let index = maps.lastIndex(of: map) {
            maps.remove(at: index)
            undoManager?.setActionName("Remove Map")
            undoManager?.registerUndo(withTarget: self, selector: #selector(addMap(map:)), object: map)
        }
    }
    
    @objc func addCharacter(character: CharacterPlayableData) {
        characters.append(character)
        undoManager?.setActionName("Create Character")
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeCharacter(character:)), object: character)
    }
    
    @objc func removeCharacter(character: CharacterPlayableData) {
        if let index = characters.lastIndex(of: character) {
            characters.remove(at: index)
            undoManager?.setActionName("Remove Character")
            undoManager?.registerUndo(withTarget: self, selector: #selector(addCharacter(character:)), object: character)
        }
    }
    
    @objc func addNPC(npc: CharacterUnplayableData) {
        npcs.append(npc)
        undoManager?.setActionName("Create NPC")
        undoManager?.registerUndo(withTarget: self, selector: #selector(removeNPC(npc:)), object: npc)
    }
    
    @objc func removeNPC(npc: CharacterUnplayableData) {
        if let index = npcs.lastIndex(of: npc) {
            characters.remove(at: index)
            undoManager?.setActionName("Remove NPC")
            undoManager?.registerUndo(withTarget: self, selector: #selector(addNPC(npc:)), object: npc)
        }
    }

}
