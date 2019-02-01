//
//  ViewController.swift
//  WJPageView
//
//  Created by zhouweijie on 2019/2/1.
//  Copyright © 2019 zhouweijie. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var textButton: WJButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.segmentView
        self.view.addSubview(self.pageView)
//        self.view.addSubview(self.segmentView)
    }
    
    let titles = ["首页","我的","房地产","商业","财经","新闻","美丽中国","科技","工业","数据"]
    
    lazy var segmentView: WJSegmentView = {
        var items = [SegmentItem]()
        for title in self.titles {
            let button = WJButton(titlePosition: .bottom, contentSpacing: 0)
            button.setTitle(title, for: .normal)
            if title.count > 2{
                button.setImage(UIImage(named: "sort-up"), for: .normal)
                button.position = .left
                button.contentSpacing = 3
            }
            button.setTitleColor(UIColor.red, for: .normal)
            button.setTitleColor(UIColor.blue, for: .selected)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
            button.isHighlighted = false
            button.useIntrinsicSize = true
            button.isUserInteractionEnabled = false
            let item = SegmentItem(button: button, indicator: nil)
            item.indicatorView.backgroundColor = UIColor.blue
            item.indicatorInset = UIEdgeInsets(top: 2, left: 0, bottom: 1, right: 0)
            items.append(item)
        }
        let segmentView = WJSegmentView(items: items)
        segmentView.selectedIndex = 1
        segmentView.backgroundColor = UIColor.lightGray
        self.pageView = WJPageView(items: items, views: self.views)
        self.pageView.detailView.backgroundColor = UIColor.gray
        return segmentView
    }()
    
    lazy var views: [UIView] = {
        var views = [UIView]()
        for i in 0..<self.titles.count {
            views.append(UIView(frame: .zero))
        }
        return views
    }()
    
    var pageView: WJPageView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        segmentView.frame = CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: self.view.bounds.width, height: segmentView.intrinsicContentSize.height))
        var frame = self.view.bounds
        frame.size.height -= 50
        frame.origin.y = 50
        self.pageView.frame = frame
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

