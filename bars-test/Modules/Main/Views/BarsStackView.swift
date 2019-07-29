//
//  BarsStackView.swift
//  bars-test
//
//  Created by Ekaterina Kolesnikova on 28/07/2019.
//  Copyright © 2019 kolesnikovakate. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class BarsStackView: UIStackView {
    
    func update(items: [BarInfo]) {
        for (index, item) in items.enumerated() {
            if subviews.count > index {
                updateBarView(byIndex: index, item: item)
            } else {
                createBarView(item: item)
            }
        }
        // не предусмотрен случай изменения кол-ва элементов
    }
    
    private func createBarView(item: BarInfo) {
        let barView = BarView()
        barView.configure(withBarInfo: item)
        addArrangedSubview(barView)
    }
    
    private func updateBarView(byIndex index: Int, item: BarInfo) {
        if let barView = subviews[index] as? BarView {
            barView.configure(withBarInfo: item)
        }
    }
}

extension Reactive where Base: BarsStackView {
    var items: Binder<[BarInfo]> {
        return Binder(self.base) { view, items in
            view.update(items: items)
        }
    }
}
