//
//  WJSegmentView.swift
//  news
//
//  Created by zhouweijie on 2018/12/21.
//  Copyright © 2018 malei. All rights reserved.
//

import UIKit

@objc protocol WJSegmentViewDataSource {
    func WJSegmentView(numberOfSectionsInNumberOfSectionsIn segmentView: WJSegmentView) -> NSInteger
    func WJSegmentView(segmentView: WJSegmentView, numberOfRowsInSection section: NSInteger)
    func WJSegmentView(segmentView: WJSegmentView, sizeForItemAtIndexPath indexPath: NSIndexPath)
    @objc optional func indicatorViewInWJSegmentView(segmentView: WJSegmentView) -> UIView
    @objc optional func indicatorSizeInWJSegmentView(segmentView: WJSegmentView) -> CGSize
}

protocol JWSegmentViewDelegate {
    func WJSegmentViewShouldSelectedItem(atIndexPath indexPath: NSIndexPath, segmentView: WJSegmentView)
    func WJSegmentViewDidSelectedItem(atIndexPath indexPath: NSIndexPath, segmentView: WJSegmentView)
    func WJSegmentView()
}


@objcMembers class WJSegmentView: UIView {
    
    //MARK: - public
    var didSelectItem: ((Int) -> Void)?
    
    var didDeselectedItem: ((Int) -> Void)?
    
    var itemForIndex:((UInt) -> SegmentItem?)?
    
//    var itemsAlignLeft: Bool = true
    
    weak var dataSource: AnyObject?
    
    /// 当前选中的index，可修改
    var selectedIndex: Int = 0 {
        didSet {
            if selectedIndex>=0 && selectedIndex<self.items.count {
                if oldValue >= 0 && oldValue < self.items.count && (oldValue != selectedIndex) {
                    self.items[oldValue].isSelected = false
                }
                self.items[selectedIndex].isSelected = true
                self.selectedItem = self.items[selectedIndex]
            }
        }
    }
    
    private(set) var selectedItem: SegmentItem!
    
    /// 不使用DataSource初始化才会有东西
    private(set) var items = [SegmentItem]()
    
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
    
//    init(items: [SegmentItem]) {
//        super.init(frame: .zero)
//        self.items = items
//        self.addSubview(self.collectionView)
//    }
    
    init(titles: [String]) {
        super.init(frame: .zero)
        var items = [SegmentItem]()
        for title in titles {
            let button = WJButton.intrinsicSizeButton(titlePosition: .left, padding: .zero, contentSpacing: 0)
            button.setTitle(title, for: .normal)
            items.append(SegmentItem(button: button, indicator: nil))
        }
        self.items = items
        self.addSubview(self.collectionView)
    }
    
    init(buttons: [WJButton]) {
        super.init(frame: .zero)
        var items = [SegmentItem]()
        for button in buttons {
            items.append(SegmentItem(button: button, indicator: nil))
        }
        self.items = items
        self.addSubview(self.collectionView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(dataSource: WJSegmentViewDataSource) {
        super.init(frame: .zero)
        self.dataSource = dataSource;
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
        for item in self.items {
            item.maxHeight = maxHeight
        }
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
        cell.contentView.addSubview(item)
        let size = self.getItemSize(indexPath: indexPath)
        item.frame = CGRect(origin: CGPoint.zero, size: size)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.getItemSize(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.setSelctedState(indexPath: indexPath)
        if self.didSelectItem != nil {
            self.didSelectItem!(indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.didDeselectedItem != nil {
            self.didDeselectedItem!(indexPath.row)
        }
    }
    
    func setSelctedState(indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
    }
    
    private func getItemSize(indexPath: IndexPath) -> CGSize {
        let item = self.items[indexPath.row]
        let itemSize = CGSize(width:item.intrinsicContentSize.width, height:item.maxHeight)
        return itemSize
    }
    
    func startIndicatorAnimation(offset: CGFloat, index: Int, isIndexIncreaze: Bool, pageWidth: CGFloat) {
        print("\(index)")
    }

}
