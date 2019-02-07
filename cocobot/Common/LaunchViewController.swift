//
//  LaunchViewController.swift
//  cocobot
//
//  Created by samyoung79 on 07/02/2019.
//  Copyright © 2019 samyoung79. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let path = Bundle.main.path(forResource: "coco_opening", ofType:"mp4") else {
            debugPrint("video.m4v not found")
            return
        }
        
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerLayer(player: player)
        
        playerController.frame = self.view.bounds
        
        self.view.layer.addSublayer(playerController)
        player.play()
    }
}
