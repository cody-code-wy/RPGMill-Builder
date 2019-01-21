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
        if let mapsFW = fileWrapper.fileWrappers?["maps"] {
            for map in maps {
                if let mapFW = mapsFW.fileWrappers?[map.uuid] {
                    map.readFileWrapper(fileWrapper: mapFW)
                }
            }
        }
        if let charactersFW = fileWrapper.fileWrappers?["characters"] {
            for character in characters {
                if let characterFW = charactersFW.fileWrappers?[character.uuid] {
                    character.readFileWrapper(fileWrapper: characterFW)
                }
            }
        }
        if let npcsFW = fileWrapper.fileWrappers?["npcs"] {
            for npc in npcs {
                if let npcFW = npcsFW.fileWrappers?[npc.uuid] {
                    npc.readFileWrapper(fileWrapper: npcFW)
                }
            }
        }
    }
    
    func fileWrapper() -> FileWrapper {
        var mapWrappers = [String:FileWrapper]()
        for map in maps {
            mapWrappers[map.uuid] = map.fileWrapper()
        }
        var characterWrappers = [String:FileWrapper]()
        for character in characters {
            characterWrappers[character.uuid] = character.fileWrapper()
        }
        var npcsWrappers = [String:FileWrapper]()
        for npc in npcs {
            npcsWrappers[npc.uuid] = npc.fileWrapper()
        }
        let mapsFW = FileWrapper(directoryWithFileWrappers: mapWrappers)
        let charactersFW = FileWrapper(directoryWithFileWrappers: characterWrappers)
        let npcsFW = FileWrapper(directoryWithFileWrappers: npcsWrappers)
        return FileWrapper(directoryWithFileWrappers: ["maps":mapsFW,"characters":charactersFW,"npcs":npcsFW])
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
            npcs.remove(at: index)
            undoManager?.setActionName("Remove NPC")
            undoManager?.registerUndo(withTarget: self, selector: #selector(addNPC(npc:)), object: npc)
        }
    }

}
