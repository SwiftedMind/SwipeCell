
//
//  SwipeCellAction.swift
//  Comic_Collector
//
//  Created by Dennis Müller on 11.04.18.
//  Copyright © 2018 Dennis Müller. All rights reserved.
//

import UIKit
import SwifterSwift

public enum SwipeCellButtonHolderPreset {
    case normal
    case info
    case destructive
}

public protocol SwipeCellActionDelegate: class {
    func didTapOnAction(_ action: SwipeCell.Action)
}

extension SwipeCell {
    public class Action: UIView {
        
        // MARK: - Properties
        // ========== PROPERTIES ==========
        public var id: String = ""
        
        public lazy var label: UILabel = {
            let label = UILabel()
            label.layer.zPosition = 1
            label.font = .systemFont(ofSize: 16)
            label.isUserInteractionEnabled = false
            label.textAlignment = .center
            
            addSubview(label)
            return label
        }()
        // ====================
        
        // MARK: - Initializers
        // ========== INITIALIZERS ==========
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor(hex: 0x111111)
            isUserInteractionEnabled = true
            
            label.snp.makeConstraints { (make) in
                make.centerX.equalToSuperview().priority(750)
                make.centerY.equalToSuperview()
                make.leading.equalToSuperview().offset(20)
                make.height.equalToSuperview()
            }
        }
        
        convenience init(id: String, withPreset preset: SwipeCellButtonHolderPreset) {
            self.init(frame: .zero)
            setPreset(preset)
            self.id = id
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError()
        }
        // ====================
        
        // MARK: - Overrides
        // ========== OVERRIDES ==========
        public func setPreset(_ preset: SwipeCellButtonHolderPreset) {
            switch preset {
            case .normal:
                backgroundColor = UIColor(hexString: "#222222")
                label.textColor = backgroundColor?.readableTextColor
            case .info:
                backgroundColor = UIColor(hexString: "#3498db")
                label.textColor = backgroundColor?.readableTextColor
            case .destructive:
                backgroundColor = UIColor(hexString: "#e74c3c")
                label.textColor = backgroundColor?.readableTextColor
            }
        }
        
        // ====================
        
        
        // MARK: - Functions
        // ========== FUNCTIONS ==========
        
        // ====================
        
    }

}
