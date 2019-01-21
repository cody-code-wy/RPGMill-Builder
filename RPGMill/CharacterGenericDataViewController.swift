//
//  CharacterGenericDataViewController.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class CharacterGenericDataViewController: NSViewController {
        
    @IBOutlet weak var characterNameTextField: NSTextField!
    @IBOutlet weak var mapsSelectorPopUpButton: NSPopUpButton?
    @IBOutlet weak var characterFacingPopUpButton: NSPopUpButton!
    @IBOutlet weak var xPositionTextField: NSTextField!
    @IBOutlet weak var yPositionTextField: NSTextField!

    var maps = [MapData]() {
        didSet {
            self.buildMapSelector()
        }
    }
    
    var errorAlertMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        buildMapSelector()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let errorvc = segue.destinationController as? ErrorViewController {
            errorvc.error = errorAlertMessage
            errorAlertMessage = nil
        }
    }
    
    func abortBadData(_ error: String) {
        self.errorAlertMessage = error
        performSegue(withIdentifier: "errorSheet", sender: self)
    }
    
    func getLocationData() -> LocationData? {
        if let map = getMap() {
            let rotation = getCharacterFacing()
            let x = getXPosition()
            let y = getYPosition()
            return LocationData(map: map, rotation: rotation, x: x, y: y)
        }
        return nil
    }
    
    func getCharacterName() -> String? {
        if characterNameTextField.stringValue == "" {
            abortBadData("Character name can not be empty")
            return nil
        }
        return characterNameTextField.stringValue
    }
    
    func getMap() -> MapData? {
        guard let selection = mapsSelectorPopUpButton!.selectedItem,
            let map = maps.findByID(id: selection.title)
            else { abortBadData("Must have valid map"); return nil }
        return map
    }
    
    func getCharacterFacing() -> Int {
        if let tag = characterFacingPopUpButton.selectedItem?.tag {
            return tag
        }
        return -1
    }
    
    func getXPosition() -> Int {
        return xPositionTextField.integerValue
    }
    
    func getYPosition() -> Int {
        return yPositionTextField.integerValue
    }
    
    func buildMapSelector() {
        let menu = NSMenu(title: "Map Selection")
        var items = [NSMenuItem]()
        for map in maps {
            let item = NSMenuItem(title: map.id, action: nil, keyEquivalent: "")
            items.append(item)
        }
        if items.count > 0 {
            for item in items {
                item.isEnabled = true
                menu.addItem(item)
            }
            mapsSelectorPopUpButton?.menu = menu
            return
        }
        let item = NSMenuItem(title: "No Maps Found", action: nil, keyEquivalent: "")
        item.isEnabled = false
        menu.addItem(item)
        mapsSelectorPopUpButton?.menu = menu
    }
    
}
