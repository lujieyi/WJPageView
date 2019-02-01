//
//  WJSegmentView.swift
//  news
//
//  Created by zhouweijie on 2018/12/21.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit


@objcMembers class WJSegmentView: UIView {
    
    //MARK: - public
    var didSelectItem: ((Int) -> Void)?
    
    var didDeselectedItem: ((Int) -> Void)?
    
    var itemForIndex:((UInt) -> SegmentItem?)?
    
    var itemsAlignLeft: Bool = true
    
    var selectedIndex: Int! {
        didSet(newValue) {
            if newValue>=0 && newValue<self.items.count {
                self.items[newValue].isSelected = true
                self.selectedItem = self.items[newValue]
            }
        }
    }
    
    private(set) var selectedItem: SegmentItem!
    
    private(set) var items: [SegmentItem]!
    
    private(set) lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: self.flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: WJSegmentItemReUsedID)
        collectionView.contentInsetAdjustmentBehavior = .never
        return collectionView
    }()
    
    private(set) lazy var flowLayout: UICollectionViewFlowLayout = {
        var flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    init(items: [SegmentItem]) {
        super.init(frame: .zero)
        self.items = items
        self.selectedIndex = 0
        self.addSubview(self.collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var selfWidth: CGFloat = 0.0
        var selfHeight: CGFloat = 0.0
        var maxHeight: CGFloat = 0.0
        var buttonWidth: CGFloat = 0.0
        for item in self.items {
            let intrinsicSize = item.intrinsicContentSize
            buttonWidth = intrinsicSize.width
            selfWidth += buttonWidth
            maxHeight = maxHeight > intrinsicSize.height ? maxHeight : intrinsicSize.height
        }
        selfHeight = maxHeight
        return CGSize(width: selfWidth, height: selfHeight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
    
    private let WJSegmentItemReUsedID = "WJSegmentItemReUsedID"
    
}

extension WJSegmentView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WJSegmentItemReUsedID, for: indexPath)
        let item = self.items[indexPath.row]
        cell.addSubview(item)
        let size = self.items[indexPath.row].intrinsicContentSize
        item.frame = CGRect(origin: CGPoint.zero, size: size)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.items[indexPath.row].intrinsicContentSize
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setSelctedState(indexPath: indexPath)
        if self.didSelectItem != nil {
            self.didSelectItem!(indexPath.row)
        }
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.didDeselectedItem != nil {
            self.didDeselectedItem!(indexPath.row)
        }
    }
    
    func setSelctedState(indexPath: IndexPath) {
        let previousItem = self.items[self.selectedIndex]
        let currentItem = self.items[indexPath.row]
        previousItem.isSelected = false
        currentItem.isSelected = true
        self.selectedIndex = indexPath.row
        self.selectedItem = currentItem
        self.updateIndicator()
    }
    
    private func updateIndicator() {
//        let newX = self.selectedItem.convert(self.selectedItem.frame, to: self).minX + (self.selectedItem.frame.width - setting.indicatorSize.width)/2.0
//        var newFrame = self.indicatorView.frame
//        newFrame.origin.x = newX
//        UIView.animate(withDuration: 0.3) {
//            self.indicatorView.frame = newFrame
//        }
    }
}
