//
//  MoviesCollectionViewLayout.swift
//  Movie Club
//
//  Created by Parth Mehta on 4/06/2016.
//  Copyright © 2016 Parth Mehta. All rights reserved.
//

import UIKit

let COLS = 16
let ROWS = 16

class MoviesCollectionViewLayout: UICollectionViewLayout {
    
    // MARK :- Properties
    let interimSpace: CGFloat = 0.0 // space between cells
    
    let cellWidth:CGFloat = 96 // width of each cell
    let cellHeight: CGFloat = 143 // height of each cell
    
    var center: CGPoint{
        return CGPoint(x: self.collectionView!.center.x, y: self.collectionView!.center.y)
    } // center of animation
    
    var cellCount: Int{
        return COLS * ROWS
    } // total no of cells
    
    var cViewSize: CGSize{
        return self.collectionView!.frame.size
    } // size of the collection view
    
    var a: CGFloat{
        return 2.1 * self.cViewSize.width
    } // value of the paraboloid parameter 'a'
    
    var b: CGFloat{
        return 1.8 * self.cViewSize.height
    } // value of the paraboloid parameter 'b'
    
    let c: CGFloat = 22 // value of the paraboloid parameter 'c'
    
    // MARK :- Methods
    
    // invalidate collection view at every bounds change
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    // get the collection view content size
    override func collectionViewContentSize() -> CGSize {
        //return CGSizeMake(self.cellWidth * CGFloat(COLS) + self.cViewSize.width, self.cellHeight * CGFloat(ROWS) + self.cViewSize.height)
        return CGSize(width: self.cellWidth * CGFloat(COLS + 1), height: self.cellHeight * CGFloat(ROWS + 3))
    }
    
    // layout attributes for each element in the bounds of the collection view\
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for i in 0..<cellCount {
            let indexPath = NSIndexPath(forItem: i, inSection: 0)
            attributes.append(self.layoutAttributesForItemAtIndexPath(indexPath)!)
        }
        
        return attributes
    }
    
    
    // set layout attributes for each cell
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        // set the row and column for the cell
        let oIndex = (indexPath as NSIndexPath).item % COLS
        let vIndex = ((indexPath as NSIndexPath).item - oIndex)/COLS
        
        // calculate x & y coordinates of each cell
        var x = CGFloat(oIndex) * self.cellWidth
        var y = CGFloat(vIndex) * self.cellHeight
        
        // shift odd rows to the right by amount = cell size / 2
        if vIndex % 2 != 0 {
            x += (self.cellWidth / 2)
        }
        
        // assign x & y to center
        attributes.center = CGPoint(x: x, y: y)
        
        // build the parabolic quation and calculate z i.e. the scale factor
        let offset = self.collectionView!.contentOffset
        
        x -= (self.center.x + CGFloat(offset.x))
        y -= (self.center.y + CGFloat(offset.y))
        
        x = (-x * x) / (a * a)
        y = (-y * y) / (b * b)
        
        var z = c * (x + y) + 1.0
        z = z < 0.0 ? 0.0 : z
        
        // set the scale factor
        attributes.transform = CGAffineTransformMakeScale(z, z)
        
        // apply the attributes to the cell
        attributes.size = CGSize(width: self.cellWidth, height: self.cellHeight)
        
        // return the attributes
        return attributes
    }
}
