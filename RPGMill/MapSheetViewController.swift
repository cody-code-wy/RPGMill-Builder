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
    var mapImageName = "map_\(UUID().uuidString)"
    
    @IBOutlet weak var tileSizeTextField: NSTextField!
    @IBOutlet weak var mapNameTextField: NSTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        mapNameTextField.placeholderString = mapImageName
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
        let mapName = getMapName()
        let tileSize = getTileSize()
        let map = MapData.init(id: mapName, imageName: "\(mapImageName).tiff", tileSize: tileSize)
        gameData?.maps.append(map)
        viewController?.reloadOutline()
        viewController?.selectEditingItem(item: map)
        self.dismiss(self)
    }
    
}
