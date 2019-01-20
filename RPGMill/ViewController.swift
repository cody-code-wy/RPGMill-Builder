//
//  ViewController.swift
//  RPGMill
//
//  Created by William Young on 1/13/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    var document: Document?
    var editorViewController: EditorViewController?
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        document = self.view.window?.windowController?.document as? Document
        reloadOutline()
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.destinationController {
        case let controller as EditorViewController:
            editorViewController = controller
            controller.viewController = self
        case let controller as MapSheetViewController:
            controller.gameData = document?.gameData
            controller.viewController = self
        case let controller as CharacterSheetViewController:
            controller.gameData = document?.gameData
            controller.viewController = self
        default:
            break
        }
    }
    
    func reloadOutline() {
        outlineView.reloadData()
        outlineView.expandItem(nil, expandChildren: true)
    }
    
    func selectEditingItem(item: Any?) {
        let row = outlineView.row(forItem: item)
        outlineView.selectRowIndexes(IndexSet([row]), byExtendingSelection: false)
    }
    
    @objc func addMap() {
        performSegue(withIdentifier: "newMapSheetSegue", sender: self)        
    }
    
    @objc func addCharacter() {
        performSegue(withIdentifier: "newCharacterSheetSegue", sender: self)
    }
}

extension ViewController: NSOutlineViewDataSource{
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if let dataHolder = item as? dataHolder {
            return dataHolder.count()
        }
        if (document?.gameData) != nil {
            return 3
        }
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if let dataHolder = item as? dataHolder {
            return dataHolder.get(at: index)
        }
        if let gameData = document?.gameData {
            switch index {
            case 0:
                return MapDataHolder(maps: gameData.maps)
            case 1:
                return CharacterDataHolder(characters: gameData.characters)
            case 2:
                return NpcDataHolder(npcs: gameData.npcs)
            default:
                break
            }
        }
        return NSObject() // Useless Object
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if (item is dataHolder) {
            return true
        }
        return false
    }
}

extension ViewController: NSOutlineViewDelegate {
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        if item is MapDataHolder {
            return outlineView.makeView(withIdentifier: .mapsArrayCell, owner: self)
        }
        if item is CharacterDataHolder {
            return outlineView.makeView(withIdentifier: .charactersArrayCell, owner: self)
        }
        if item is NpcDataHolder {
            return outlineView.makeView(withIdentifier: .npcsArrayCell, owner: self)
        }
        if let overviewItem = item as? OverviewItem {
            return overviewItem.viewFor(outlineView: outlineView, tableColumn: tableColumn)
        }
        return nil
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView,
            let editorView = editorViewController
            else { return }
        let selectedIndex = outlineView.selectedRow
        if let editItem = outlineView.item(atRow: selectedIndex) {
            editorView.editorFor(item: editItem, on: document?.gameData)
        }
    }
}

extension NSUserInterfaceItemIdentifier {
    static let mapsArrayCell = NSUserInterfaceItemIdentifier("mapsArrayCell")
    static let charactersArrayCell = NSUserInterfaceItemIdentifier("charactersArrayCell")
    static let npcsArrayCell = NSUserInterfaceItemIdentifier("npcsArrayCell")
    static let itemCell = NSUserInterfaceItemIdentifier("itemCell")
}
