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

class WJPageView: UIViewController {

    var currentPage: UInt! = 0
    
    private(set) var segmentView: WJSegmentView
    
    private(set) var views: [UIView]
    
    private(set) lazy var detailView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
//    init(items: [WJButton], views: [UIView], setting: wj_segmentSettings) {
//        assert(items.count == views.count && items.count != 0, "titles.count != viewControllers.count 或者 titles.count == 0")
//        self.segmentView = WJSegmentView(items: items, selectedIndex: 0, maxWidth:nil, setting: setting)
//        self.views = views
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    init(separatedSegmentView: WJSegmentView, views: [UIView]) {
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let size = CGSize(width: self.view.frame.width, height: self.view.frame.height-self.segmentView.frame.height)
        let layout = self.detailView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = size
        self.detailView.frame = CGRect(origin: CGPoint(x: 0, y: self.segmentView.frame.height), size: size)
    }

}
