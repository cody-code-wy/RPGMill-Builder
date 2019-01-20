//
//  Document.swift
//  RPGMill
//
//  Created by William Young on 1/13/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class Document: NSDocument {

    var gameData: GameData? = GameData(maps: [], characters: [], npcs: [])
    
    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class var autosavesInPlace: Bool {
        return true
    }

    override func makeWindowControllers() {
        // Returns the Storyboard that contains your Document window.
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        self.addWindowController(windowController)
    }

    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        if let gameData = gameData {
            let data = try! NSKeyedArchiver.archivedData(withRootObject: gameData, requiringSecureCoding: false)
            let gameDataFW = FileWrapper(regularFileWithContents: data)
            var files = ["gameData.bplist": gameDataFW]
            files["gameData"] = gameData.fileWrapper()
            return FileWrapper.init(directoryWithFileWrappers: files)
        }
        throw NSError(domain: "no Game Data Found", code: unimpErr, userInfo: nil)
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        if let gameDataFW = fileWrapper.fileWrappers!["gameData.bplist"] {
            gameData = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(gameDataFW.regularFileContents!) as! GameData
        }
        if let gameDatafolder = fileWrapper.fileWrappers!["gameData"] {
            gameData?.loadFileWrapper(fileWrapper: gameDatafolder)
        }
    }

}

