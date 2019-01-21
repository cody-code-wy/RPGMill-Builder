//
//  CharacterSheetViewController.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class NPCSheetViewController: NSViewController {

    @IBOutlet weak var characterPhraseTextField: NSTextField!
    
    var characterViewController: CharacterGenericDataViewController?
    var viewController: ViewController?
    var gameData: GameData?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        if let controller = characterViewController {
            let submit = #selector(NPCSheetViewController.createNPCPressed(_:))
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
    
    @IBAction func createNPCPressed(_ sender: Any) {
        guard let gameData = gameData
            else { self.dismiss(self); return }
        guard let location = characterViewController?.getLocationData(),
            let characterName = characterViewController?.getCharacterName()
            else { return }
        var phrase = characterPhraseTextField.stringValue

        if phrase == "" { phrase = characterPhraseTextField.placeholderString ?? "ERROR" }
        
        let npc = CharacterUnplayableData(id: characterName, location: location, phrase: phrase, rtf: nil, gameData: gameData)
        gameData.addNPC(npc: npc)
        
        let index = gameData.npcs.count - 1
        viewController?.outlineView.insertItems(at: IndexSet(arrayLiteral: index), inParent: viewController?.npcsDataHolder, withAnimation: .effectFade)
        viewController?.selectEditingItem(item: npc)
        
        self.dismiss(self)
    }
    
}
