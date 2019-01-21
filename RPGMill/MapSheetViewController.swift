//
//  MapSheetViewController.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class MapSheetViewController: NSViewController {

    var gameData: GameData?
    var viewController: ViewController?
    
    @IBOutlet weak var tileSizeTextField: NSTextField!
    @IBOutlet weak var mapNameTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        mapNameTextField.placeholderString = MapData.uuid
        tileSizeTextField.placeholderString = String(MapData.defaultTileSize)
    }
    
    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(nil)
    }
    
    func getMapName() -> String {
        if mapNameTextField.stringValue != "" {
            return mapNameTextField.stringValue
        }
        return mapNameTextField.placeholderString ?? "map_ERROR"
    }
    
    func getTileSize() -> Int {
        if tileSizeTextField.stringValue != "" {
            if let value = Int(tileSizeTextField.stringValue) {
                return value
            }
        }
        return MapData.defaultTileSize
    }
    
    @IBAction func CreatePressed(_ sender: Any) {
        guard let gameData = gameData,
            let viewController = viewController
            else { self.dismiss(self); return }
        
        let mapName = getMapName()
        let tileSize = getTileSize()
        let map = MapData.init(id: mapName, tileSize: tileSize, rtfd: nil, gameData: gameData)
        gameData.addMap(map: map)
        
        let index = gameData.maps.count - 1
        viewController.outlineView.insertItems(at: IndexSet(arrayLiteral: index), inParent: viewController.mapsDataHolder, withAnimation: .effectFade)
        viewController.selectEditingItem(item: map)
                
        self.dismiss(self)
    }
    
}
