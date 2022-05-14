//
//  DynamicLayout.swift
//  Bunker
//
//  Created by Дмитрий Соколов on 14.05.2022.
//
import UIKit

protocol DynamicLayoutDelegate: AnyObject {
    func textForItem(
        _ collectionView: UICollectionView,
        widthForCell: CGFloat,
        textForItemAtIndexPath indexPath: IndexPath
    ) -> CGFloat
}

class DynamicLayout: UICollectionViewLayout {
    weak var delegate: DynamicLayoutDelegate?

    var numberOfColumns = 2
    
    private let cellPadding: CGFloat = 6
    private var multiCache: [[UICollectionViewLayoutAttributes]] = []
    private var contentHeight: CGFloat = 0
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        var insets = collectionView.contentInset
        collectionView.contentInset = UIEdgeInsets(top: 16 , left: insets.left, bottom: insets.bottom, right: insets.right)
        insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func prepare() {
        multiCache.removeAll()
        guard  let collectionView = collectionView else { return }
        
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)
        
        for section in 0..<collectionView.numberOfSections {
            var arrayForSection: [UICollectionViewLayoutAttributes] = []
            for item in 0..<collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                
                
                let photoHeight = delegate?.textForItem(collectionView, widthForCell: (columnWidth-36), textForItemAtIndexPath: indexPath) ?? 180
                
                let height = cellPadding * 2 + photoHeight
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: height)
                let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
                
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = insetFrame
                arrayForSection.append(attributes)
                
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + height
                
                column = column < (numberOfColumns - 1) ? (column + 1) : 0
            }
            multiCache.append(arrayForSection)
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
        for array in multiCache {
            for attributes in array {
                if attributes.frame.intersects(rect) {
                    visibleLayoutAttributes.append(attributes)
                }
            }
        }
        return visibleLayoutAttributes
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return multiCache[indexPath.section][indexPath.row]
    }
}
