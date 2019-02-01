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
        let titles = ["首页","我的","房地产","商业","财经","新闻","美丽中国","科技","工业","数据"]
        var items = [SegmentItem]()
        for title in titles {
            let button = WJButton(titlePosition: .left, contentSpacing: 0)
            button.setTitle(title, for: .normal)
            if title.count > 2{
                button.setImage(UIImage(named: "video_icon"), for: .normal)
            }
            button.setTitleColor(UIColor.red, for: .normal)
            button.setTitleColor(UIColor.blue, for: .selected)
            button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
            button.isHighlighted = false
            button.useIntrinsicSize = true
            button.isUserInteractionEnabled = false
            let item = SegmentItem(button: button, indicator: nil)
            items.append(item)
        }
        let segmentView = WJSegmentView(items: items)
        self.view.addSubview(segmentView)
        segmentView.backgroundColor = UIColor.lightGray
        segmentView.frame = CGRect(origin: CGPoint(x: 0, y: 50), size: CGSize(width: self.view.bounds.width, height: segmentView.intrinsicContentSize.height))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}

