//
//  EditorTab.swift
//  RPGMill
//
//  Created by William Young on 1/18/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

protocol EditorTab {
    func setEditorViewController(editorViewController: EditorViewController?)
    func loadNewEditingItem(item: Any?, on: Any?)
}
