//
//  AppDelegate.swift
//  Upload
//
//  Created by worldunionYellow on 2021/2/1.
//

import Cocoa
import Alamofire
import SwiftyJSON

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var popover: NSPopover!
    var statusBarItem: NSStatusItem!
    @IBOutlet weak var uploadView: UploadView!
    @IBOutlet weak var btnForUpload: NSButton!
    @IBOutlet weak var imageV: NSImageView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 400)
        popover.behavior = .transient    //代表用户点击其他区域时popover自动消失
        popover.contentViewController = TopViewController()
        self.popover = popover

        self.statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = self.statusBarItem.button {
            statusBarItem.button?.title = "⏳"
            button.action = #selector(togglePopover(_:))
        }


        self.btnForUpload.action = #selector(uploadImage(_:))
        self.uploadView.delegate = self

    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if let button = self.statusBarItem.button {
            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }


    @objc func uploadImage(_ sender: AnyObject?) {
        if let image = self.imageV.image {
            AF.upload(multipartFormData: { (multipartFormData) in
                let imageData = image.png
                multipartFormData.append(imageData!, withName: "file", fileName: "ok.png", mimeType: "image/jpg/png/jpeg")
            }, to: "http://muzhoulz.xyz:8889/file/upload", method: .post).responseJSON { (response) in
                NSPasteboard.general.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
                if let data = response.data {
                    let json = JSON.init(data)
                    if json["code"].stringValue == "200" {
                        self.imageV.image = nil
                        let str = "http://muzhoulz.xyz:8989/file" + json["data"].stringValue
                        NSPasteboard.general.setString(str, forType: NSPasteboard.PasteboardType.string)
                    }else{
                        NSPasteboard.general.setString("上传失败--\( json["message"].stringValue)", forType: NSPasteboard.PasteboardType.string)
                    }
                }else{
                    NSPasteboard.general.setString("上传失败", forType: NSPasteboard.PasteboardType.string)
                }
            }
        }
    }



    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

extension AppDelegate: DestinationViewDelegate {
    func processImage(_ image: NSImage) {
        self.imageV.image = image
    }
}

extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSImage {
    var png: Data? { tiffRepresentation?.bitmap?.png }
}
