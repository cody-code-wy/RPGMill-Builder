//
//  CharacterEditorViewController.swift
//  RPGMill
//
//  Created by William Young on 1/20/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class NPCEditorViewController: NSViewController {

    var editorViewController: EditorViewController?
    var characterGenericViewController: CharacterGenericDataViewController?
    
    var npc: CharacterUnplayableData?
    var gameData: GameData?
    
    @IBOutlet weak var characterPhraseTextField: NSTextField!
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
        npc?.image = imageView.image
    }
    
    @IBAction func phraseDidChange(_ sender: Any) {
        npc?.phrase = characterPhraseTextField.stringValue
    }
    
    @objc func characterNameDidChange(){
        if let controller = characterGenericViewController,
            let name = controller.getCharacterName() {
            npc?.id = name
            editorViewController?.viewController?.reloadOutline()
        }
    }
    
    @objc func characterLocationDidChange(){
        if let controller = characterGenericViewController,
            let locationData = controller.getLocationData(){
            npc?.location = locationData
        }
    }
}

extension NPCEditorViewController: EditorTab {
    func setEditorViewController(editorViewController: EditorViewController?) {
        self.editorViewController = editorViewController
    }
    
    func loadNewEditingItem(item: Any?, on: Any?) {
        guard let npc = item as? CharacterUnplayableData,
            let gameData = on as? GameData
            else { return }
        self.npc = npc
        self.gameData = gameData
        reloadView()
    }
    
    @objc func reloadView() {
        if let controller = characterGenericViewController,
            let npc = npc,
            let gameData = gameData {
            if let rtf = npc.rtf,
                let attrString = NSAttributedString(rtf: rtf, documentAttributes: nil) {
                loreTextView.textStorage?.setAttributedString(attrString)
            } else {
                loreTextView.string = ""
            }
            characterPhraseTextField.stringValue = npc.phrase
            imageView.image = npc.image
            controller.maps = gameData.maps
            controller.characterNameTextField.stringValue = npc.id
            controller.mapsSelectorPopUpButton?.selectItem(withTitle: npc.location.map.id)
            controller.characterFacingPopUpButton.selectItem(withTag: npc.location.rotation)
            controller.xPositionTextField.stringValue = String(npc.location.x)
            controller.yPositionTextField.stringValue = String(npc.location.y)
        }
    }
    
}

extension NPCEditorViewController: NSTextViewDelegate {
    func textDidEndEditing(_ notification: Notification) {
        let range = NSRange(location: 0, length: loreTextView.string.count)
        npc?.rtf = loreTextView.rtf(from: range)
    }
}
