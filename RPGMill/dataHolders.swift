//
//  dataHolders.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Foundation

protocol DataHolder {
    func count() -> Int
    func get(at: Int) -> Any
}

class MapDataHolder: DataHolder {
    var gameData: GameData
    init(_ gameData: GameData){ self.gameData = gameData }
    func count() -> Int { return gameData.maps.count }
    func get(at: Int) -> Any { return gameData.maps[at] }
}
class CharacterDataHolder: DataHolder {
    var gameData: GameData
    init(_ gameData: GameData){ self.gameData = gameData }
    func count() -> Int { return gameData.characters.count }
    func get(at: Int) -> Any { return gameData.characters[at] }
}
class NpcDataHolder: DataHolder {
    var gameData: GameData
    init(_ gameData: GameData){ self.gameData = gameData }
    func count() -> Int { return gameData.npcs.count }
    func get(at: Int) -> Any { return gameData.npcs[at] }
}
