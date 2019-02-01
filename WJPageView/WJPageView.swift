//
//  WJPageView.swift
//  customButton
//
//  Created by zhouweijie on 2019/1/15.
//  Copyright © 2019 zhouweijie. All rights reserved.
//

import UIKit

protocol WJPageViewControllerDatasource {
    func itemForIndex(index: UInt) -> WJButton
    func viewControllerForIndex(index: UInt) -> UIViewController
}

class WJPageView: UIView {
    
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    var isSeparated: Bool = false

    var selectedIndex: UInt! = 0 {
        didSet {
            
        }
    }
    
    private(set) var views: [UIView]
    
    private(set) var segmentView: WJSegmentView?
    
    private(set) lazy var detailView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: detailViewCellReuseID)
        return collectionView
    }()
    
    private(set) lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        flowLayout.scrollDirection = self.scrollDirection
        return flowLayout
    }()

    convenience init(items: [SegmentItem], views: [UIView]) {
        assert(items.count == views.count && items.count != 0, "titles.count != viewControllers.count 或者 titles.count == 0")
        let segmentView = WJSegmentView(items: items)
        self.init(segmentView: segmentView, views: views)
    }
    
    init(segmentView: WJSegmentView?, views: [UIView]) {
        if segmentView != nil {
            assert(segmentView!.items.count == views.count && segmentView!.items.count != 0, "titles.count != viewControllers.count 或者 titles.count == 0")
            self.segmentView = segmentView
            self.segmentView!.flowLayout.scrollDirection = self.scrollDirection
        }
        self.views = views
        super.init(frame: .zero)
        self.addSubview(self.detailView)
        self.addSubview(self.segmentView!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isSeparated {
            self.detailView.frame = self.bounds
        } else {
            if self.scrollDirection == .horizontal {
                self.segmentView?.frame = CGRect(origin: .zero, size: CGSize(width: self.bounds.width, height: (self.segmentView?.intrinsicContentSize.height ?? 0)))
                let size = CGSize(width: self.bounds.width, height: self.bounds.height-(self.segmentView?.frame.height ?? 0))
                self.flowLayout.itemSize = size
                self.detailView.frame = CGRect(origin: CGPoint(x: 0, y: (self.segmentView?.frame.height ?? 0)), size: size)
            } else {
//                self.segmentView?.frame = CGRect(origin: .zero, size: CGSize(width: (self.segmentView?.intrinsicContentSize.width ?? 0), height: self.bounds.height))
                let size = CGSize(width: self.bounds.width-(self.segmentView?.frame.width ?? 0), height: self.bounds.height)
                self.flowLayout.itemSize = size
                self.detailView.frame = CGRect(origin: CGPoint(x: self.segmentView?.frame.width ?? 0, y: 0), size: size)
            }
        }
    }
    
    private let detailViewCellReuseID = "detailViewCellReuseID"
    
}

extension WJPageView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailViewCellReuseID, for: indexPath)
        cell.backgroundColor = UIColor.blue
        return cell
    }
    
    
}
