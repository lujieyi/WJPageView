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

class WJPageViewController: UIViewController {
    
    enum ScrollingDirection {
        case increaze, decreaze, none
    }
    
    var scrollDirection: UICollectionView.ScrollDirection = .horizontal
    
    var isJointed: Bool = false

    var selectedIndex: Int = 0 {
        didSet {
            self.segmentView?.selectedIndex = selectedIndex
//            self.detailView.scrollToItem(at: IndexPath(item: selectedIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    private let detailViewCellReuseID = "detailViewCellReuseID"
    
    private(set) var views: [UIView]
    
    private(set) var segmentView: WJSegmentView?
    
    private(set) lazy var detailView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: self.flowLayout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
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

    init(items: [SegmentItem], views: [UIView]) {
        self.views = views
        super.init(nibName: nil, bundle: nil)
        let segmentView = WJSegmentView(items: items)
        self.setupPageView(segmentView: segmentView, views: views)
    }
    
    init(disjointedSegmentView: WJSegmentView, views: [UIView]) {
        self.views = views
        super.init(nibName: nil, bundle: nil)
        self.isJointed = true
        self.setupPageView(segmentView: disjointedSegmentView, views: views)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPageView(segmentView: WJSegmentView, views: [UIView]) {
        assert(segmentView.items.count == views.count && segmentView.items.count != 0, "titles.count != viewControllers.count 或者 titles.count == 0")
        self.segmentView = segmentView
        self.segmentView!.flowLayout.scrollDirection = self.scrollDirection
        self.view.addSubview(self.detailView)
        self.view.addSubview(self.segmentView!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if self.isJointed {
            self.detailView.frame = view.bounds
        } else {
            if self.scrollDirection == .horizontal {
                self.segmentView?.frame = CGRect(origin: .zero, size: CGSize(width: view.bounds.width, height: (self.segmentView?.intrinsicContentSize.height ?? 0)))
                let size = CGSize(width: view.bounds.width, height: view.bounds.height-(self.segmentView?.frame.height ?? 0))
                self.flowLayout.itemSize = size
                self.detailView.frame = CGRect(origin: CGPoint(x: 0, y: (self.segmentView?.frame.height ?? 0)), size: size)
            } else {
                //                self.segmentView?.frame = CGRect(origin: .zero, size: CGSize(width: (self.segmentView?.intrinsicContentSize.width ?? 0), height: self.bounds.height))
                let size = CGSize(width: view.bounds.width-(self.segmentView?.frame.width ?? 0), height: view.bounds.height)
                self.flowLayout.itemSize = size
                self.detailView.frame = CGRect(origin: CGPoint(x: self.segmentView?.frame.width ?? 0, y: 0), size: size)
            }
        }
    }
    
    private lazy var cloneIndicator: UIImageView = {
        let indicator = UIImageView()
        let defaultIndicator = self.segmentView?.selectedItem.indicatorView
        indicator.image = defaultIndicator?.image
        indicator.layer.masksToBounds = true
        indicator.layer.cornerRadius = defaultIndicator?.layer.cornerRadius ?? 0
        indicator.backgroundColor = defaultIndicator?.backgroundColor
        self.segmentView?.collectionView.addSubview(indicator)
        return indicator
    }()
    
    
    private var indicatorMidFrame: CGRect?
}

extension WJPageViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return views.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: detailViewCellReuseID, for: indexPath)
        cell.backgroundColor = UIColor(red: CGFloat(Double(arc4random_uniform(256))/255.0), green: CGFloat(Double(arc4random_uniform(256))/255.0), blue: CGFloat(Double(arc4random_uniform(256))/255.0), alpha: 1.0)
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.segmentView == nil {return}
        if self.scrollDirection == .horizontal {
            let offsetX = scrollView.contentOffset.x
            let detailViewWidth = self.detailView.bounds.width
            let defaultFrame: CGRect?
            let fmodfValue = fmodf(Float(offsetX), Float(detailViewWidth))
            if fmodfValue == 0 {
                //翻页完成
                self.segmentView!.selectedItem.indicatorView.isHidden = false
                let index = Int(offsetX/detailViewWidth)
                self.segmentView!.selectedIndex = index
                let selectedItem = self.segmentView!.selectedItem
                defaultFrame = selectedItem!.convert(selectedItem!.indicatorView.frame, to: self.segmentView!.collectionView)
                self.cloneIndicator.frame = defaultFrame ?? .zero
                self.cloneIndicator.backgroundColor = UIColor.red
                self.cloneIndicator.alpha = 0.5
            } else {
                //正在翻页
                self.segmentView!.selectedItem.indicatorView.isHidden = true
                let point = scrollView.panGestureRecognizer.translation(in: self.detailView)
                self.cloneIndicator.backgroundColor = UIColor.orange
                if point.x < 0 {
                    //往右滑
                    let index = Int(offsetX/detailViewWidth)
                    if index == self.segmentView!.items.count - 1 {return}
                    let startItem = self.segmentView!.items![index]
                    let toItem = self.segmentView!.items![index+1]
                    if toItem.window == nil || startItem.window == nil {return}
                    let startFrame = startItem.convert(startItem.indicatorView.frame, to: self.segmentView!.collectionView)
                    let toFrame = toItem.convert(toItem.indicatorView.frame, to: self.segmentView!.collectionView)
                    let indicatorDistance = toFrame.maxX - startFrame.maxX
                    var indicatorOffset = CGFloat(fmodfValue) / detailViewWidth * indicatorDistance * 2
                    var newFrame: CGRect
                    if indicatorOffset < indicatorDistance {
                        //头部到到达目标位置
                        newFrame = CGRect(x: startFrame.minX, y: startFrame.minY, width: startFrame.width+indicatorOffset, height: startFrame.height)
                        indicatorMidFrame = CGRect(x: startFrame.minX, y: startFrame.minY, width: toFrame.maxX - startFrame.minX, height: toFrame.height)
                    } else {
                        //尾部开始收缩
                        let indicatorDistance = toFrame.minX - startFrame.minX
                        indicatorOffset = (CGFloat(fmodfValue) - detailViewWidth / 2) / detailViewWidth * indicatorDistance * 2
                        newFrame = CGRect(x: indicatorMidFrame!.minX + indicatorOffset, y: indicatorMidFrame!.minY, width: indicatorMidFrame!.width - indicatorOffset, height: indicatorMidFrame!.height)
                    }
                    self.cloneIndicator.frame = newFrame
                } else {
                    //往左滑
                    let index = Int(offsetX/detailViewWidth) + 1
                    if offsetX < 0 || index > self.segmentView!.items.count - 1 {return}
                    let startItem = self.segmentView!.items![index]
                    let toItem = self.segmentView!.items![index-1]
                    if toItem.window == nil || startItem.window == nil {return}
                    let startFrame = startItem.convert(startItem.indicatorView.frame, to: self.segmentView!.collectionView)
                    let toFrame = toItem.convert(toItem.indicatorView.frame, to: self.segmentView!.collectionView)
                    let indicatorDistance = startFrame.minX - toFrame.minX
                    let indicatorOffset = (detailViewWidth - CGFloat(fmodfValue)) / detailViewWidth * indicatorDistance * 2
                    let newFrame: CGRect
                    if indicatorOffset < indicatorDistance {
                        newFrame = CGRect(x: startFrame.minX - indicatorOffset, y: startFrame.minY, width: startFrame.width + indicatorOffset, height: startFrame.height)
                        indicatorMidFrame = CGRect(x: toFrame.minX, y: toFrame.minY, width: startFrame.maxX - toFrame.minX, height: toFrame.height)
                    } else {
                        let indicatorDistance = toFrame.maxX - startFrame.maxX
                        let indicatorOffset = (detailViewWidth / 2 - CGFloat(fmodfValue)) / detailViewWidth * indicatorDistance * 2
                        newFrame = CGRect(x: indicatorMidFrame!.minX, y: indicatorMidFrame!.minY, width: indicatorMidFrame!.width + indicatorOffset, height: indicatorMidFrame!.height)
                    }
                    self.cloneIndicator.frame = newFrame
                }
            }
        } else {
            
        }
        
    }
    
    
}
