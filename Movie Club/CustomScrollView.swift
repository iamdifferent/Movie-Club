//
//  CustomScrollView.swift
//  Movie Club
//
//  Created by Parth Mehta on 12/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

class CustomScrollView: UIScrollView, UIScrollViewDelegate {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func setContentOffset(contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: animated)
        
        print(contentOffset)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }

}
