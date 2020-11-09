 
import UIKit

class HomeGlobalNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    private let cellIdentifier = "HomeGlobalNewsCollectionViewCell"
    
    let count = 20
    
    private let collectionMargin:CGFloat = UIScreen.main.bounds.size.width <= 320 ? 40.0 : 60.0
    private let itemSpacing:CGFloat = 0
    private var itemWidth:CGFloat = 0
    private let transformationValue = CGAffineTransform(scaleX: 0.85, y: 0.85)
    private let animationDuration = 0.2
    private var isfirstTimeTransform = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        collectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        pageControl.numberOfPages = count
        pageControl.currentPage = 0
        isfirstTimeTransform = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
   
}
 
// MARK: - UICollectionViewFlowLayout
extension HomeGlobalNewsTableViewCell : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeGlobalNewsCollectionViewCell
        if (indexPath.row == 0 && isfirstTimeTransform) {
            isfirstTimeTransform = false
        }else{
            cell.transform = transformationValue
        }
        return cell
    }
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        pageControl.currentPage = indexPath.item
//    }
    
}

 extension HomeGlobalNewsTableViewCell: UIScrollViewDelegate {
    
    // MARK: - UIScrollViewDelegate protocol
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView!.contentSize.width  )
        var newPage = Float(self.pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor( (targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? self.pageControl.currentPage + 1 : self.pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        self.pageControl.currentPage = Int(newPage)
        let point = CGPoint (x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
        targetContentOffset.pointee = point
        
        // Make Transition Effects for cells
        let cell:UICollectionViewCell = self.collectionView.cellForItem(at: IndexPath(row: Int(newPage), section: 0)) ?? UICollectionViewCell()
        
        // If first index
        if (newPage == 0) {
            self.setAnimation(cell: cell, transformationValue: CGAffineTransform.identity)
            
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: Int(newPage+1), section: 0)) {
                self.setAnimation(cell: cell, transformationValue: self.transformationValue)
            }
            
        } else if Int(newPage) == count {
            self.setAnimation(cell: cell, transformationValue: CGAffineTransform.identity)
        } else {
            // current cell
            self.setAnimation(cell: cell, transformationValue: CGAffineTransform.identity)
            
            // left cell
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: Int(newPage-1), section: 0)) {
                self.setAnimation(cell: cell, transformationValue: self.transformationValue)
            }
            
            // right cell
            if let cell = self.collectionView.cellForItem(at: IndexPath(row: Int(newPage+1), section: 0)) {
                self.setAnimation(cell: cell, transformationValue: self.transformationValue)
            }
        }
    }
 }

 extension HomeGlobalNewsTableViewCell: UICollectionViewDelegateFlowLayout {
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         itemWidth =  UIScreen.main.bounds.width - collectionMargin * 2.0
         return CGSize(width: itemWidth, height: collectionView.frame.size.height)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return itemSpacing
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
         return CGSize(width: collectionMargin, height: 0)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
         return CGSize(width: collectionMargin, height: 0)
     }
 }

 extension HomeGlobalNewsTableViewCell {
    private func setAnimation(cell: UICollectionViewCell, transformationValue: CGAffineTransform) {
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [ .curveEaseOut], animations: {
            cell.transform = transformationValue
        }, completion: nil)
    }
 }
