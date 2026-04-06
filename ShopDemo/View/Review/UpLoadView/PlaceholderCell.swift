//
//  PlaceholderCell.swift
//  ShopDemo
//
//  Created by gem on 2/4/26.
//

import UIKit

protocol PlaceholderCellDelegate : AnyObject {
    func didTapAddImageFromPlaceholder()
}

class PlaceholderCell: UICollectionViewCell {
    @IBOutlet weak var upLoadView: UIView!
    private var dashLayer: CAShapeLayer?
    
    weak var delegate : PlaceholderCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    @IBAction func upLoadImageTapped(_ sender: Any) {
        delegate?.didTapAddImageFromPlaceholder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBorder()
    }
    //Vẽ border nét đứt
    private func addDashedBorder() {
        dashLayer?.removeFromSuperlayer()
        
        let shapeLayer = CAShapeLayer()
        
        let viewBounds = self.contentView.bounds
        
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = nil
        shapeLayer.lineDashPattern = [4, 4]
        shapeLayer.lineWidth = 1
        shapeLayer.frame = viewBounds
        shapeLayer.path = UIBezierPath(roundedRect: viewBounds, cornerRadius: 8).cgPath
        
        self.contentView.layer.addSublayer(shapeLayer)
        self.dashLayer = shapeLayer
    }
}
