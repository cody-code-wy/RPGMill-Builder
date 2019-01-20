//
//  CharacterEditorViewController.swift
//  RPGMill
//
//  Created by William Young on 1/20/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class CharacterEditorViewController: NSViewController {

    var editorViewController: EditorViewController?
    var characterGenericViewController: CharacterGenericDataViewController?
    
    var character: CharacterPlayableData?
    var gameData: GameData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        reloadView()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? CharacterGenericDataViewController {
            characterGenericViewController = controller
        }
    }
    
    func reloadView() {
        if let controller = characterGenericViewController,
            let character = character,
            let gameData = gameData {
            controller.maps = gameData.maps
            controller.characterNameTextField.stringValue = character.id
            controller.mapsSelectorPopUpButton?.selectItem(withTitle: character.location.mapID)
            controller.characterFacingPopUpButton.selectItem(withTag: character.location.rotation)
            controller.xPositionTextField.stringValue = String(character.location.x)
            controller.yPositionTextField.stringValue = String(character.location.y)
        }
    }
    
}

extension CharacterEditorViewController: EditorTab {
    func setEditorViewController(editorViewController: EditorViewController?) {
        self.editorViewController = editorViewController
    }
    
    func loadNewEditingItem(item: Any?, on: Any?) {
        guard let character = item as? CharacterPlayableData,
            let gameData = on as? GameData
            else { return }
        self.character = character
        self.gameData = gameData
        reloadView()
    }
    
    
}
