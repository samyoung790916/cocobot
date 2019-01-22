//
//  BridgeMgr.swift
//  cocobot
//
//  Created by samyoung79 on 22/01/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//
import WebKit
class BridgeMgr : NSObject,  WKScriptMessageHandler {
    
    typealias bridgeHandler = (([String : AnyObject]) -> ())?
    
    private weak var webView : WKWebView?
    private var bridgeHandlerTable = [String : bridgeHandler]()
    
    init(webView : WKWebView) {
        self.webView = webView
    }
    
    private func parse(message : WKScriptMessage) -> [String : AnyObject]? {
        guard let messageBody = message.body as? String,
            let data = messageBody.data(using: .utf8),
            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] else {
                return nil
        }
        return json
    }
    
    func addBridge(_ name : String, _ handler : bridgeHandler) {
        guard bridgeHandlerTable[name] == nil else {return}
        webView?.configuration.userContentController.add(self, name: name)
        bridgeHandlerTable[name] = handler
    }
    
    func removeBridge(_ name : String) {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: name)
        bridgeHandlerTable.removeValue(forKey: name)
    }
    
    func removeAllBridge() {
        bridgeHandlerTable.keys.forEach {
            removeBridge($0)
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let json = self.parse(message: message) else {return}
        let name = message.name
        if let bridgeHandler = bridgeHandlerTable[name], let handler = bridgeHandler {
            handler(json)
        }
    }
    
}


