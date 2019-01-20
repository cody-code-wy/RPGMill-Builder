//
//  dataHolders.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Foundation

protocol dataHolder {
    func count() -> Int
    func get(at: Int) -> Any
}

class MapDataHolder: dataHolder {
    var maps: [MapData]
    init(maps: [MapData]){ self.maps = maps }
    func count() -> Int { return maps.count }
    func get(at: Int) -> Any { return maps[at] }
}
class CharacterDataHolder: dataHolder {
    var characters: [CharacterPlayableData]
    init(characters: [CharacterPlayableData]){ self.characters = characters }
    func count() -> Int { return characters.count }
    func get(at: Int) -> Any { return characters[at] }
}
class NpcDataHolder: dataHolder {
    var npcs: [CharacterUnplayableData]
    init(npcs: [CharacterUnplayableData]){ self.npcs = npcs }
    func count() -> Int { return npcs.count }
    func get(at: Int) -> Any { return npcs[at] }
}
