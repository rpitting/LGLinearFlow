//
//  LGMagnifyingLinearFlowLayout.swift
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

public class LGMagnifyingLinearFlowLayout: UICollectionViewFlowLayout {
    
    private var lastCollectionViewSize: CGSize = CGSizeZero
    
    public var scalingOffset: CGFloat = 200 //for offsets >= scalingOffset scale factor is minimumScaleFactor
    public var minimumScaleFactor: CGFloat = 0.7
    public var scaleItems: Bool = true

    public override init() {
        super.init()
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        self.scrollDirection = .Horizontal
    }
    
    public override func prepareLayout() {
        super.prepareLayout()
        
        guard let collectionView = self.collectionView else { return }
        
        let currentCollectionViewSize = collectionView.bounds.size
        if !CGSizeEqualToSize(currentCollectionViewSize, self.lastCollectionViewSize) {
            self.configureInset()
            self.lastCollectionViewSize = currentCollectionViewSize
        }
    }
    
    private func configureInset() -> Void {
        guard let collectionView = self.collectionView else { return }

        let inset = collectionView.bounds.size.width / 2 - self.itemSize.width / 2
        collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset)
        collectionView.contentOffset = CGPointMake(-inset, 0)
    }
    
    public override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else { return proposedContentOffset }
        
        let collectionViewSize = collectionView.bounds.size
        let proposedRect = CGRectMake(proposedContentOffset.x, 0, collectionViewSize.width, collectionViewSize.height)
        
        let layoutAttributes = self.layoutAttributesForElementsInRect(proposedRect)

        if layoutAttributes == nil {
            return proposedContentOffset
        }

        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2

        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            if attributes.representedElementCategory != .Cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.x - collectionView.bounds.size.width / 2
        
        let offset = newOffsetX - collectionView.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
            let pageWidth = self.itemSize.width + self.minimumLineSpacing
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPointMake(newOffsetX, proposedContentOffset.y)
    }
    
    public override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = self.collectionView where scaleItems != false else {
            return super.layoutAttributesForElementsInRect(rect) }
        
        guard let superAttributes = super.layoutAttributesForElementsInRect(rect) else { return nil }
                
        let contentOffset = collectionView.contentOffset
        let size = collectionView.bounds.size

        let visibleRect = CGRectMake(contentOffset.x, contentOffset.y, size.width, size.height)
        let visibleCenterX = CGRectGetMidX(visibleRect)
        
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()

        for (_, attributes) in superAttributes.enumerate() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        }
        
        return newAttributesArray;
    }
    
}
