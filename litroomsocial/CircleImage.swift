//
//  CircleImage.swift
//  litroomsocial
//
//  Created by Kuala on 2017-04-21.
//  Copyright © 2017 Litroom. All rights reserved.
//

import UIKit

class CircleImage: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
