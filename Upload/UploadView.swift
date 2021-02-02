//
//  UploadView.swift
//  Upload
//
//  Created by worldunionYellow on 2021/2/2.
//

import Cocoa

protocol DestinationViewDelegate {
    func processImage(_ image: NSImage)
}

class UploadView: NSView {

    var delegate: DestinationViewDelegate?

    var isReceivingDrag = false {
        didSet {
        }
    }

    override func awakeFromNib() {
        registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
        self.layer?.borderColor = NSColor.darkGray.cgColor
        self.layer?.borderWidth = 1
        self.layer?.cornerRadius = 5

    }


    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        self.isReceivingDrag = false
    }

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        return true
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        self.isReceivingDrag = false
        let pasteBoard = sender.draggingPasteboard
        guard let image = NSImage(pasteboard: pasteBoard) else {
            return false
        }
        delegate?.processImage(image)
        return true
    }

}
