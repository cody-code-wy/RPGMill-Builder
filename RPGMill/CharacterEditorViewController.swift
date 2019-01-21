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
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet var loreTextView: NSTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.NSUndoManagerDidUndoChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.NSUndoManagerDidRedoChange, object: nil)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        reloadView()
        characterGenericViewController?.characterNameTextField.target = self
        characterGenericViewController?.characterNameTextField.action = #selector(characterNameDidChange)
        characterGenericViewController?.mapsSelectorPopUpButton?.target = self
        characterGenericViewController?.mapsSelectorPopUpButton?.action = #selector(characterLocationDidChange)
        characterGenericViewController?.characterFacingPopUpButton?.target = self
        characterGenericViewController?.characterFacingPopUpButton.action = #selector(characterLocationDidChange)
        characterGenericViewController?.xPositionTextField.target = self
        characterGenericViewController?.xPositionTextField.action = #selector(characterLocationDidChange)
        characterGenericViewController?.yPositionTextField.target = self
        characterGenericViewController?.yPositionTextField.action = #selector(characterLocationDidChange)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let controller = segue.destinationController as? CharacterGenericDataViewController {
            characterGenericViewController = controller
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(nil)
    }
    
    @IBAction func imageDidChange(_ sender: Any) {
        character?.image = imageView.image
    }
    
    @objc func characterNameDidChange(){
        if let controller = characterGenericViewController,
            let name = controller.getCharacterName() {
            character?.id = name
            editorViewController?.viewController?.reloadOutline()
        }
    }
    
    @objc func characterLocationDidChange(){
        if let controller = characterGenericViewController,
            let locationData = controller.getLocationData(){
            character?.location = locationData
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
    
    @objc func reloadView() {
        if let controller = characterGenericViewController,
            let character = character,
            let gameData = gameData {
            if let rtf = character.rtf,
                let attrString = NSAttributedString(rtf: rtf, documentAttributes: nil) {
                loreTextView.textStorage?.setAttributedString(attrString)
            } else {
                loreTextView.string = ""
            }
            imageView.image = character.image
            controller.maps = gameData.maps
            controller.characterNameTextField.stringValue = character.id
            controller.mapsSelectorPopUpButton?.selectItem(withTitle: character.location.map.id)
            controller.characterFacingPopUpButton.selectItem(withTag: character.location.rotation)
            controller.xPositionTextField.stringValue = String(character.location.x)
            controller.yPositionTextField.stringValue = String(character.location.y)
        }
    }
    
}

extension CharacterEditorViewController: NSTextViewDelegate {
    func textDidEndEditing(_ notification: Notification) {
        let range = NSRange(location: 0, length: loreTextView.string.count)
        character?.rtf = loreTextView.rtf(from: range)
    }
}
