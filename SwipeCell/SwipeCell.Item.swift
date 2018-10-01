
//
//  SwipeCell.Item.swift
//  SwipeCell
//
//  Created by Dennis Müller on 11.04.18.
//  Copyright © 2018 Dennis Müller. All rights reserved.
//

import UIKit
import SwifterSwift

public protocol SwipeCellItemDelegate: class {
    func didTapOnItem(_ item: SwipeCell.Item)
}

extension SwipeCell {
    
    /// An Item represents a button that appears when swiping the cell.
    /// You can access the label property to modify the appearance of the item as well as the item's property itself.
    public class Item: UIView {
        
        /// Item preset which sets the style of the item
        ///
        /// - normal: Standard theme
        /// - info: Information theme
        /// - destructive: Desctructive theme
        public enum Preset {
            case normal
            case info
            case destructive
            
            public var backgroundColor: UIColor {
                switch self {
                case .normal: return UIColor(hexString: "#222222")!
                case .info: return UIColor(hexString: "#3498db")!
                case .destructive: return UIColor(hexString: "#e74c3c")!
                    
                }
            }
        }
        
        // MARK: - Properties
        // ========== PROPERTIES ==========
        
        /// Custom id to identify the item.
        public var id: String = ""
        
        /// Label that is used to display the text inside the item. Can be modified
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
            
            setPreset(.normal)
        }
        
        convenience init(id: String, withPreset preset: Preset) {
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
        /// Sets the theme to a given preset. This method is optional. The default theme is .normal
        ///
        /// - Parameter preset: The preset you want to apply
        public func setPreset(_ preset: Preset) {
            backgroundColor = preset.backgroundColor
            label.textColor = preset.backgroundColor.readableTextColor
        }
        
        // ====================
        
        
        // MARK: - Functions
        // ========== FUNCTIONS ==========
        
        // ====================
        
    }

}
