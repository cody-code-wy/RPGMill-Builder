//
//  CharacterSheetViewController.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class CharacterSheetViewController: NSViewController {

    var characterViewController: CharacterGenericDataViewController?
    var viewController: ViewController?
    var gameData: GameData?
    
    var imageName = "character_\(UUID().uuidString).tiff"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        if let controller = characterViewController {
            let submit = #selector(self.createCharacterPressed(_:))
            controller.characterNameTextField.cell?.sendsActionOnEndEditing = false
            controller.characterNameTextField.action = submit
            controller.xPositionTextField.cell?.sendsActionOnEndEditing = false
            controller.xPositionTextField.action = submit
            controller.yPositionTextField.cell?.sendsActionOnEndEditing = false
            controller.yPositionTextField.action = submit
        }
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let characterViewController = segue.destinationController as? CharacterGenericDataViewController {
            self.characterViewController = characterViewController
            if let maps = gameData?.maps {
                characterViewController.maps = maps
            }
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(nil)
    }
    
    @IBAction func createCharacterPressed(_ sender: Any) {
        guard let gameData = gameData
            else { self.dismiss(self); return }
        guard let location = characterViewController?.getLocationData(),
            let characterName = characterViewController?.getCharacterName()
            else { return }
        let character = CharacterPlayableData(id: characterName, imageName: imageName, location: location)
        gameData.characters.append(character)
        viewController?.reloadOutline()
        viewController?.selectEditingItem(item: character)
        self.dismiss(self)
    }
    
}
