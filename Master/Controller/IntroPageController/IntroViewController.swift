//
//  IntroViewController.swift
//  Master
//
//  Created by Mohammad Fallah on 12/3/1398 AP.
//  Copyright © 1398 iPersianDeveloper. All rights reserved.
//

import UIKit
struct IntroData {
    var title : String?
    var description : String?
    var image : UIImage?
}
class IntroViewController: UIViewController,UIScrollViewDelegate {

//    ==== outlets ====
    @IBOutlet weak var backwardBtn: UIButton!
    @IBOutlet weak var forwardBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
//    ==== vars ====
    let PAGE_COUNT = 3
    let pages = [
        IntroData(
            title: "علی ویترین چیست؟",
            description: "تجربه خوب دیده شدن و رسیدن به همکاران در صنعت کفش",
            image:#imageLiteral(resourceName: "logo_vertically.pdf") ),
        
        IntroData(
            title: "!دیده می شوم پس هستم",
            description: "علی ویترین برای بهتر دیده شدن تولیدکنندگان و محصولاتشان در کفش و صنایع وابسته",
            image: #imageLiteral(resourceName: "factory_symbol.pdf")),
        
        IntroData(
            title: "کارخانه دوست کجاست؟",
            description: "با چند کلیک تمام همکاران رو پیدا کن و  همیشه در جریان محصولات جدید در رسته کاری خودت باش",
            image: #imageLiteral(resourceName: "store_symbol.pdf"))
    ]
    var slides : [IntroPageView]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides!)
        pageControl.numberOfPages = PAGE_COUNT
        checkForwardAndBackeardBtnAppearence()
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    func createSlides() -> [IntroPageView] {
        return (0 ..< PAGE_COUNT).map { (i) -> IntroPageView in
            let slide :IntroPageView = Bundle.main.loadNibNamed("IntroPageView", owner: self, options: nil)?.first as! IntroPageView
            slide.imageView.image = pages[i].image
            slide.subjectLabel.text = pages[i].title
            slide.descriptionLabel.text = pages[i].description
            return slide
        }
    }
    func checkForwardAndBackeardBtnAppearence () {
        if pageControl.currentPage == 0 {
            backwardBtn.isHidden = true
            forwardBtn.isHidden = false
        }
        else if 1 ..< (PAGE_COUNT - 1) ~= pageControl.currentPage {
            backwardBtn.isHidden = false
            forwardBtn.isHidden = false
        }
        else {
            backwardBtn.isHidden = false
            forwardBtn.isHidden = true
        }
    }
    @IBAction func pageControlValueDidChange(_ sender: Any) {
        checkForwardAndBackeardBtnAppearence()
    }
    func setupSlideScrollView(slides : [IntroPageView]) {
        //scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(slides.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: scrollView.frame.width * CGFloat(i), y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
            let currentPageIndex = Int(scrollView.contentOffset.x/view.frame.width)
            pageControl.currentPage = Int(pageIndex)
            checkForwardAndBackeardBtnAppearence()
        
            let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
            let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
            
            // vertical
            let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
            let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
            
            let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
            let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
 
            if currentPageIndex < PAGE_COUNT - 1 {
                let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
                let unit : CGFloat  = CGFloat(1) / CGFloat(PAGE_COUNT-1)
                let this = unit * CGFloat(Int(currentPageIndex) + 1)
                
                slides?[Int(currentPageIndex)].imageView.transform = CGAffineTransform(scaleX: (this-percentOffset.x)/unit, y: (this-percentOffset.x)/unit)
                slides?[Int(currentPageIndex) + 1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/this, y: percentOffset.x/this)
            }
        }

    @IBAction func forwardBtnClicked(_ sender: Any) {
        scrollToPage(page: pageControl.currentPage + 1)
        
    }
    @IBAction func backwardBtnClicked(_ sender: Any) {
        scrollToPage(page: pageControl.currentPage - 1)
    }
    func scrollToPage (page : Int) {
        scrollView.setContentOffset(CGPoint(x: CGFloat((scrollView.frame.width) * CGFloat(page)), y: 0), animated: true)
        checkForwardAndBackeardBtnAppearence()
    }
}
