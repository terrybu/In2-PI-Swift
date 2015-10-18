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

class AboutPIViewController: UIViewController, UIScrollViewDelegate{
    
    var navDrawerVC : LeftNavDrawerController?
    var segmentedControl : HMSegmentedControl!
    var horizontalScrollView : UIScrollView!

    override func didMoveToParentViewController(parent: UIViewController?) {
        let viewWidth = CGRectGetWidth(self.view.frame)
        setUpHMSegmentedControl(viewWidth)
        setUpHorizontalScrollView(viewWidth)
        
        let viewCanvas1 = setUpCanvas(0, headerTitle: "In2 소개", bodyText: "'Come IN2 Christ, Go IN2 the World' \n 온누리 교회는 사도행전적 ‘바로 그 교회’의 꿈을 가지고 시작되었고 지난 20년동안 사도행전적인 교회를 꿈꾸며 ‘가서 모든 족속을 제자 삼으라’고 말씀하신 예수님의 명령에 순종하려고 노력해왔습니다. 교회에서 하나님을 만나(COME) 하나님의 일꾼으로 성장하여, 세상으로 나가(GO) 평신도들이 전문인 선교사로 세상에 선한 영향력을 끼쳐 세상을 변화시키는 사역을 지속적으로 펼쳐나갈 것입니다. 앞으로도 IN2(뉴욕) 온누리 교회는 말씀과 기도로 교회를 강건하게 세워나가며 문화 사역을 통하여 뉴욕의 한인 유학생, 직장인, 교포 2세들, 더 나아가서는 다인종 및 전세계에 복음을 전하는 ACTS 29을 써나갈 것입니다.")
        
        let viewCanvas2 = setUpCanvas(viewWidth, headerTitle: "청년부 소개", bodyText: "2013년 8월 인투교회 3부 예배 안에 청년부와 대학부 공동체가 분리되었으며, 2014년 청년부 예배(3부)와 대학부 예배(4부)로 예배가 증설되었습니다. 2015년 2월 청년부는 86 st.  Amsterdam ave.  에 위치한 West Park Presbyterian Church의 건물을 빌려 West IN2 캠퍼스로 분리 개척되어, 맨하탄을 비롯한 뉴욕 5 BORO의 청년들이 함께 모여 예배하며 현재에 이르고 있습니다.")
        
        let viewCanvas3 = setUpCanvas3(viewWidth * 2, headerTitle: "목사님 인사말", bodyText: "  크고 화려할 수록 아픈 사람이 많은 곳? 병원 그리고 교회입니다. 뉴욕이 크고 화려해서 아픈 사람이 많기에 PI가 존재합니다. \n  뉴욕을 지배하는 영은 허영입니다. 아는 척, 있는 척, 강한 척, 바쁜 척 살지만 실은 늘 두려움과 공허함과 목마름이 있습니다. 예수님께서 연약한 내 모습 그대로 사랑하시기에 PI가 존재합니다. \n  다들 잘 살기위해 아둥바둥 남을 먼저 짖밟고 죽여야 하는 곳, 하지만 정작 내가 목숨 걸 일은 찾지 못하기에 무언가에든 취해야 하는 곳. 그래서 깨어 기도하는 PI가 존재합니다. \n  가족이 있지만 멀리 있고 보호자가 있지만 나를 보호하지 않았기에 가족과 사랑을 찾아 방황합니다. 그 어느 곳에도 예수님 같은 분이 없기에 PI가 존재합니다. \n  환자가 군사가 되는 곳, 내가 정직해 질 수 있는 곳, 뉴욕이 홈타운이 되는 이유, 내가 살 자리가 아니라 죽을 자리를 찾는 이들을 위한 청년공동체. 바로 PI 입니다.")
        
        let viewCanvas4 = setUpCanvas4(viewWidth * 3, headerTitle: "주일예배", bodyText: " West Campus - 청년부 \n 오후 1:30PM \n West Park Church \n 165 West 86th st. New York, NY 10024")
        
        horizontalScrollView.addSubview(viewCanvas1)
        horizontalScrollView.addSubview(viewCanvas2)
        horizontalScrollView.addSubview(viewCanvas3)
        horizontalScrollView.addSubview(viewCanvas4)

        setUpXCloseButton()
    }
    
    
    //MARK: Each Canvas Creation for Scrollview
    private func setUpCanvas(x: CGFloat, headerTitle: String, bodyText:String) -> UIView {
        let width = CGRectGetWidth(self.view.frame)
        let height = view.frame.size.height - 60
        let viewCanvas = UIView(frame: CGRect(x: x, y: 40, width: width, height: height))
        let bigBoldHeaderLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 0, self.view.frame.width-30, 25))
        bigBoldHeaderLabel.text = headerTitle
        bigBoldHeaderLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 25)
        let textDescribeLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 45, self.view.frame.width-30, height))
        textDescribeLabel.numberOfLines = 0
        textDescribeLabel.text = bodyText
        textDescribeLabel.sizeToFit()
        viewCanvas.addSubview(bigBoldHeaderLabel)
        viewCanvas.addSubview(textDescribeLabel)
        return viewCanvas
    }
    
    private func setUpCanvas3(x: CGFloat, headerTitle: String, bodyText:String) -> UIView {
        let width = CGRectGetWidth(self.view.frame)
        let height = view.frame.size.height - 60
        let viewCanvas = UIView(frame: CGRect(x: x, y: 40, width: width, height: height))
        let bigBoldHeaderLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 0, self.view.frame.width-30, 25))
        bigBoldHeaderLabel.text = headerTitle
        bigBoldHeaderLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 25)
        let bodyTextView = UITextView(frame: CGRectMake(kLeftSidePadding, 45, self.view.frame.width-30, height-50))
        bodyTextView.text = bodyText
        bodyTextView.font = UIFont(name: "NanumBarunGothicOTF", size: 15.0)
        viewCanvas.addSubview(bigBoldHeaderLabel)
        viewCanvas.addSubview(bodyTextView)
        return viewCanvas
    }
    private func setUpCanvas4(x: CGFloat, headerTitle: String, bodyText:String) -> UIView {
        let width = CGRectGetWidth(self.view.frame)
        let height = view.frame.size.height - 60
        let viewCanvas = UIView(frame: CGRect(x: x, y: 40, width: width, height: height))
        let bigBoldHeaderLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 0, self.view.frame.width-30, 25))
        bigBoldHeaderLabel.text = headerTitle
        bigBoldHeaderLabel.font = UIFont(name: "NanumBarunGothicOTFBold", size: 25)
        let textDescribeLabel = UILabel(frame: CGRectMake(kLeftSidePadding, 45, self.view.frame.width-30, height))
        textDescribeLabel.numberOfLines = 0
        textDescribeLabel.text = bodyText
        textDescribeLabel.sizeToFit()
        viewCanvas.addSubview(bigBoldHeaderLabel)
        viewCanvas.addSubview(textDescribeLabel)
        
        let imageView = UIImageView(image: UIImage(named: "churchDirections"))
        imageView.frame = CGRectMake(0, 45 + textDescribeLabel.frame.height + 10, width, 250)
        viewCanvas.addSubview(imageView)
        
        return viewCanvas
    }
    
    
    //MARK: General Segmented Control Structure Setup
    private func setUpHMSegmentedControl(viewWidth: CGFloat) {
        let viewWidth = CGRectGetWidth(self.view.frame)

        segmentedControl = HMSegmentedControl(frame: CGRectMake(0, 10, viewWidth, 50))
        segmentedControl.sectionTitles = ["In2 ", "청년부", "목사님", "예배 "]
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        
        let segControlTitleFont = UIFont(name: "NanumBarunGothicOTF", size: 15.0)
        if let segControlTitleFont =  segControlTitleFont {
            //regular font
            segmentedControl.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor(rgba: "#bbbcbc"),
                NSFontAttributeName : segControlTitleFont
            ]
            //selected font
            segmentedControl.selectedTitleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.In2DeepPurple(),
                NSFontAttributeName : segControlTitleFont
            ]
        }
        
        segmentedControl.selectionIndicatorColor = UIColor.In2DeepPurple()
        segmentedControl.indexChangeBlock = ({ (index : NSInteger) -> Void in
            self.horizontalScrollView.scrollRectToVisible(CGRectMake(viewWidth * CGFloat(index), 0, viewWidth, 200), animated: true)
        })
        self.view.addSubview(segmentedControl)
    }
    
    private func setUpHorizontalScrollView(viewWidth: CGFloat) {
        let scrollViewHeight = view.frame.size.height - 60
        horizontalScrollView = UIScrollView(frame: CGRectMake(0, 60, viewWidth, scrollViewHeight))
        horizontalScrollView.backgroundColor = UIColor.whiteColor()
        horizontalScrollView.pagingEnabled = true
        horizontalScrollView.showsHorizontalScrollIndicator = false
        horizontalScrollView.contentSize = CGSizeMake(viewWidth * 4, 200)
        horizontalScrollView.delegate = self
        horizontalScrollView.scrollRectToVisible(CGRectMake(0, 0, viewWidth, 200), animated: false)
        self.view.addSubview(horizontalScrollView)
    }
    
    
    //MARK: UIScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page : UInt = UInt(scrollView.contentOffset.x / pageWidth)
        segmentedControl.setSelectedSegmentIndex(page, animated: true)
    }
    
    
    //MARK: Outside of Segmented Control Structure
    private func setUpXCloseButton() {
        let button = UIButton(frame: CGRectMake(self.view.frame.width/2-15, self.view.frame.height-40, 30, 30))
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
    

    
}