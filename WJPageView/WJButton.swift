//
//  WJButton.swift
//  customButton
//
//  Created by zhouweijie on 2019/1/14.
//  Copyright © 2019 zhouweijie. All rights reserved.
//

import UIKit

/// title相对于image上下左右四个方向排列，在UIButton的基础上废弃了titleEdgeInsets和imageEdgeInsets，使用contentSpacing增加title和image的间距，imageOffset和titleOffset调整垂直于内容排列方向的偏移量。使用contentEdgeInsets增加上下左右边距。重写了intrinsicContentSize，返回图片和文字的intrinsicContentSize加上contentEdgeInsets大小
@objcMembers class WJButton: UIButton {
    
    enum Position: Int {
        case top, bottom, left, right
    }
    
    var position: Position {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// 文字和图片间距
    var contentSpacing: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var titleOffset: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    var imageOffset: CGFloat = 0.0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    /// 忽略frame中的size，使用固有内容大小，默认false
    var useIntrinsicSize: Bool = false {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    init(titlePosition: Position, contentSpacing: CGFloat) {
        self.position = titlePosition
        self.contentSpacing = contentSpacing
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.useIntrinsicSize {
            var frame = self.frame
            frame.size = self.intrinsicContentSize
            self.frame = frame
        }
        self.contentVerticalAlignment = .center
        self.contentHorizontalAlignment = .center
        imageView?.contentMode = .center
        titleLabel?.contentMode = .center
        arrange(titleSize: titleLabel?.attributedText?.size() ?? .zero, imageSize: imageView?.image?.size ?? .zero, atPosition: self.position, withSpacing: self.contentSpacing)
    }
    
    private func arrange(titleSize: CGSize, imageSize: CGSize, atPosition position: Position, withSpacing spacing: CGFloat) {
        switch (position) {
        case .top:
            titleEdgeInsets = UIEdgeInsets(top: -(imageSize.height + spacing), left: -(imageSize.width)+titleOffset, bottom: 0, right: -titleOffset)
            imageEdgeInsets = UIEdgeInsets(top: titleSize.height+spacing, left: imageOffset, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleEdgeInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width)+titleOffset, bottom: titleSize.height, right: -titleOffset)
            imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height+spacing), left: imageOffset, bottom: 0, right: -titleSize.width)
        case .left:
            titleEdgeInsets = UIEdgeInsets(top: titleOffset, left: -(imageSize.width*2+spacing), bottom: 0, right: 0)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0, bottom: 0, right: -(titleSize.width*2+spacing))
        case .right:
            titleEdgeInsets = UIEdgeInsets(top: titleOffset, left: 0, bottom: 0, right: -spacing)
            imageEdgeInsets = UIEdgeInsets(top: imageOffset, left: 0, bottom: 0, right: spacing)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let imageSize = self.imageView?.image?.size
        let titleSize = self.titleLabel?.attributedText?.size()
        if self.position == .left || self.position == .right {
            let imageWidth = imageSize?.width ?? 0
            let titleWidth = titleSize?.width ?? 0
            let width: CGFloat = self.contentEdgeInsets.left + self.contentEdgeInsets.right + titleWidth + imageWidth + contentSpacing
            let height = (imageSize?.height ?? 0) > (titleSize?.height ?? 0) ? (imageSize?.height ?? 0) : (titleSize?.height ?? 0)
            return CGSize(width: width, height: height+self.contentEdgeInsets.top+self.contentEdgeInsets.bottom)
        } else {
            let width = (imageSize?.width ?? 0) > (titleSize?.width ?? 0) ? (imageSize?.width ?? 0) : (titleSize?.width ?? 0)
            let imageHeight = imageSize?.height ?? 0
            let titleHeight = titleSize?.height ?? 0
            let height = self.contentEdgeInsets.top + self.contentEdgeInsets.bottom + titleHeight + imageHeight + contentSpacing
            return CGSize(width: width+self.contentEdgeInsets.left+self.contentEdgeInsets.right, height: height)
        }
    }
    
    
}
