//
//  MainViewController.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 27/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

import UIKit
import RxSwift

final class MainViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MainViewModelImpl()
    
    @IBOutlet private var button: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindButton()
        bindInput()
    }
}

// MARK: - Private
private extension MainViewController {
    
    func bindButton() {
        button.rx.tap
            .bind {[unowned self] in
                self.viewModel.toggleConnectState()
            }
            .disposed(by: disposeBag)
    }
    
    func bindInput() {
        viewModel.isLoading.drive(activityIndicator.rx.isAnimating).disposed(by: disposeBag)
        viewModel.isConnected.drive(onNext: {[unowned self] isConnected in
            self.button.setTitle(isConnected ? "Disconnect" : "Connect", for: .normal)
        }).disposed(by: disposeBag)
    }
}
