//
//  UIScrollView+ScrollToBotom.swift
//  HNReaderSwift
//
//  Created by Gorceag Olga on 17/11/16.
//  Copyright © 2016 Gorceag Olga. All rights reserved.
//

import UIKit

extension UIScrollView {

    func scrolledToBottom(withBuffer contentOffset: CGPoint, _ contentSize: CGSize, _ contentInset: UIEdgeInsets, _ bounds: CGRect) -> Bool {
        let buffer = bounds.height - contentInset.top - contentInset.bottom;
        let maxVisibleY = contentOffset.y + bounds.size.height
        let actualMaxY = (contentSize.height + contentInset.bottom)
        return (maxVisibleY + buffer) >= actualMaxY
    }
    
}
