//
//  MapEditorViewController.swift
//  RPGMill
//
//  Created by William Young on 1/18/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class MapEditorViewController: NSViewController {

    var editorViewController: EditorViewController?
    var gameData: GameData?
    var map: MapData?
    
    @IBOutlet weak var mapNameTextField: NSTextField!
    @IBOutlet weak var tileSizeTextField: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var imageFileNameLabel: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.NSUndoManagerDidUndoChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name.NSUndoManagerDidRedoChange, object: nil)
    }
    
    override func mouseDown(with event: NSEvent) {
        view.window?.makeFirstResponder(nil)
    }
    
    @IBAction func mapNameTextFieldDidUpdate(_ sender: NSTextField) {
        guard let map = map else { return }
        map.id = sender.stringValue
        editorViewController?.viewController?.reloadOutline()
    }
    
    @IBAction func tileSizeTextFieldDidChange(_ sender: NSTextField) {
        guard let map = map else { return }
        map.tileSize = sender.integerValue
    }
    
    @IBAction func mapImageDidChange(_ sender: NSImageView) {
        guard let map = map else { return }
        map.image = sender.image
        imageFileNameLabel.stringValue = map.imageName
    }
    
}

extension MapEditorViewController: EditorTab {
    func setEditorViewController(editorViewController: EditorViewController?) {
        self.editorViewController = editorViewController
    }
    
    func loadNewEditingItem(item: Any?, on: Any?) {
        guard let map = item as? MapData,
            let gameData = on as? GameData
            else { return }
        self.map = map
        self.gameData = gameData
        reloadView()
    }
    
    @objc func reloadView() {
        mapNameTextField.stringValue = map?.id ?? ""
        if let map = map {
            tileSizeTextField.integerValue = map.tileSize
        } else {
            tileSizeTextField.stringValue = ""
        }
        imageView.image = map?.image
        imageFileNameLabel.stringValue = map?.imageName ?? ""
    }
}
