//
//  ImageUpLoadCell.swift
//  ShopDemo
//
//  Created by gem on 2/4/26.
//

import UIKit

protocol ImageUpLoadCellDelegate: AnyObject {
    func didTapDeleteImage(at index: IndexPath)
    func didTapAddImageFromUploadCell()
}
class ImageUpLoadCell: UICollectionViewCell {

    @IBOutlet weak var upLoadView: UIImageView!
    @IBOutlet weak var deleteImageBtn: UIButton!
    @IBOutlet weak var upLoadLbl: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    weak var delegate : ImageUpLoadCellDelegate?
    var indexPath : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        upLoadView.addGestureRecognizer(tapGesture)
    }

    func configure(with image: UIImage?) {
        if let actualImage = image {
            //Cell hiển thị ảnh
            photoImageView.image = actualImage
            photoImageView.isHidden = false
            upLoadView.isHidden = true
            deleteImageBtn.isHidden = false
            upLoadLbl.isHidden = true
            self.removeDashedBorder()
        } else {
            //Cell tải ảnh
            photoImageView.isHidden = true
            upLoadView .isHidden = false
            deleteImageBtn.isHidden = true
            upLoadLbl.isHidden = false
            self.addDashedBorder()
        }
    }
    
    @IBAction func deleteBtnTapped(_ sender: Any) {
        if let indexPath = indexPath {
            delegate?.didTapDeleteImage(at: indexPath)
        }
    }
    
    @objc func imageTapped(){
        print("Ảnh đã được tap")
        delegate?.didTapAddImageFromUploadCell()
    }
}

//Vẽ border nét đứt
extension UIView {
    
    func addDashedBorder(color: UIColor = .lightGray, width: CGFloat = 1, dashPattern: [NSNumber] = [4, 4], cornerRadius: CGFloat = 8) {
        removeDashedBorder()
        
        let dashedLayer = CAShapeLayer()
        dashedLayer.name = "dashed_border_layer"
        dashedLayer.strokeColor = color.cgColor
        dashedLayer.lineDashPattern = dashPattern
        dashedLayer.frame = self.bounds
        dashedLayer.fillColor = nil
        dashedLayer.lineWidth = width
        dashedLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        
        self.layer.addSublayer(dashedLayer)
    }
    
    func removeDashedBorder() {
        self.layer.sublayers?.forEach { layer in
            if layer.name == "dashed_border_layer" {
                layer.removeFromSuperlayer()
            }
        }
    }
}
