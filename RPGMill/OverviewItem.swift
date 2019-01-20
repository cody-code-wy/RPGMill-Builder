//
//  OverviewItem.swift
//  RPGMill
//
//  Created by William Young on 1/17/19.
//  Copyright © 2019 William Young. All rights reserved.
//

import Cocoa

protocol OverviewItem {
    func viewFor(outlineView: NSOutlineView, tableColumn: NSTableColumn?) -> NSView?
}
