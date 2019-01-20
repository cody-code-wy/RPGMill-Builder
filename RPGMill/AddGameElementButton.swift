//
//  AddGameElementButton.swift
//  RPGMill
//
//  Created by William Young on 1/19/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class AddGameElementButton: NSButton {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(with event: NSEvent) {
        let menu = NSMenu(title: "Add Element")
        menu.addItem(NSMenuItem(title: "New Map", action: #selector(ViewController.addMap), keyEquivalent: ""))
        menu.addItem(NSMenuItem(title: "New Character", action: #selector(ViewController.addCharacter), keyEquivalent: ""))
        NSMenu.popUpContextMenu(menu, with: event, for: self)
    }
}
