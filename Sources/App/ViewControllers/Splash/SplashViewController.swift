//
//  SplashViewController.swift
//  App
//
//  Created by Stefano Mondino on 07/02/2019.
//  Copyright © 2019 Synesthesia. All rights reserved.
//

import UIKit
import ViewModel
import Boomerang
import SnapKit

class SplashViewController: UIViewController, ViewModelCompatible, InteractionCompatible {
    
    func configure(with viewModel: SplashViewModel) {
        print ("Everything went fine! Starting.")
        viewModel.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let launchScreen = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()?.view {
            self.view.insertSubview(launchScreen, at: 0)
            launchScreen.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
}
