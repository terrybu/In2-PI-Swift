//
//  AboutPIViewControlller.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import HMSegmentedControl

private let kLeftSidePadding: CGFloat = 15

class AboutPIViewController: UIViewController, UIScrollViewDelegate {
    
    var navDrawerVC : LeftNavDrawerController?
    var segmentedControl : HMSegmentedControl!
    var horizontalScrollView : UIScrollView!

    
    override func didMoveToParentViewController(parent: UIViewController?) {
        let viewWidth = CGRectGetWidth(self.view.frame)
        segmentedControl = HMSegmentedControl(frame: CGRectMake(0, 10, viewWidth, 50))
        segmentedControl.sectionTitles = ["Test1", "Test2", "Test3", "Test4"]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
//        segmentedControl.indexChangeBlock = ({ (index : NSInteger) -> Void in
//            self.horizontalScrollView.scrollRectToVisible(CGRectMake(viewWidth * CGFloat(index), 0, viewWidth, 200), animated: true)
//        })
        
        self.view.addSubview(segmentedControl)
//        
//        horizontalScrollView = UIScrollView(frame: CGRectMake(0, 60, viewWidth, 210))
//        horizontalScrollView.backgroundColor = UIColor(rgba: "FFFFFF")
//        horizontalScrollView.pagingEnabled = true
//        horizontalScrollView.contentSize = CGSizeMake(viewWidth * 3, 200)
//        horizontalScrollView.delegate = self
//        horizontalScrollView.scrollRectToVisible(CGRectMake(viewWidth, 0, viewWidth, 200), animated: false)
//        self.view.addSubview(horizontalScrollView)
        
        
        let bigBoldHeaderLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 50, self.view.frame.width-30, 25))
        bigBoldHeaderLabel.text = "In2 소개"
        bigBoldHeaderLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 25)
        self.view.addSubview(bigBoldHeaderLabel)

        let introLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 90, self.view.frame.width-30, self.view.frame.height-100))
        introLabel.numberOfLines = 0
        introLabel.text = "'Come IN2 Christ, Go IN2 the World' \n 온누리 교회는 사도행전적 ‘바로 그 교회’의 꿈을 가지고 시작되었고 지난 20년동안 사도행전적인 교회를 꿈꾸며 ‘가서 모든 족속을 제자 삼으라’고 말씀하신 예수님의 명령에 순종하려고 노력해왔습니다. 교회에서 하나님을 만나(COME) 하나님의 일꾼으로 성장하여, 세상으로 나가(GO) 평신도들이 전문인 선교사로 세상에 선한 영향력을 끼쳐 세상을 변화시키는 사역을 지속적으로 펼쳐나갈 것입니다. 앞으로도 IN2(뉴욕) 온누리 교회는 말씀과 기도로 교회를 강건하게 세워나가며 문화 사역을 통하여 뉴욕의 한인 유학생, 직장인, 교포 2세들, 더 나아가서는 다인종 및 전세계에 복음을 전하는 ACTS 29을 써나갈 것입니다."
        introLabel.sizeToFit() 
        self.view.addSubview(introLabel)
        
        let button = UIButton(frame: CGRectMake(self.view.frame.width/2-15, self.view.frame.height-60, 30, 30))
        button.setImage(UIImage(named: "btn_close"), forState: .Normal)
        button.addTarget(self, action: "closeButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(button)
    }
    
    //the reason this is private is because i wanted to keep it encapsulated
    //but then objective-c runtime can't find the method to use as selector
    //so you must use @objc keyword 
    @objc
    private func closeButtonPressed() {
        navDrawerVC?.closeAboutPIModal()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page : UInt = UInt(scrollView.contentOffset.x / pageWidth)
        segmentedControl.setSelectedSegmentIndex(page, animated: true)
    }
    
}