//
//  EditorViewController.swift
//  RPGMill
//
//  Created by William Young on 1/18/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class EditorViewController: NSTabViewController {

    var editing: Any?
    var editingOn: Any?
    
    var viewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard segue.sourceController as? EditorViewController == self,
            let destination = segue.destinationController as? EditorTab
            else { return }
        destination.setEditorViewController(editorViewController: self)
    }
    
    func editorFor(item: Any, on: Any?){
        editing = item
        editingOn = on
        switch item {
        case _ as MapData:
            self.tabView.selectTabViewItem(at: 1)
        case _ as CharacterPlayableData:
            self.tabView.selectTabViewItem(at: 2)
        case _ as CharacterUnplayableData:
            self.tabView.selectTabViewItem(at: 3)
        default:
            self.tabView.selectTabViewItem(at: 0)
        }
        if let editor = self.tabView.selectedTabViewItem?.viewController as? EditorTab {
            editor.loadNewEditingItem(item: editing, on: editingOn)
        }
    }
    
}
