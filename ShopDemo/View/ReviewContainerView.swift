//
//  ReviewContainerView.swift
//  ShopDemo
//
//  Created by gem on 1/4/26.
//

import UIKit

class ReviewContainerView: UIView {
    
    @IBOutlet weak var upLoadImageBtn: UIButton!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var characterLbl: UILabel!
    @IBOutlet weak var reviewTxt: UITextView!
    @IBOutlet weak var reviewBtn: UIButton!
    @IBOutlet weak var upLoadVIew: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromXib()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadFromXib()
    }
    
    private func loadFromXib() {
        print("loaded")
        let xib = UINib(nibName: "Review", bundle: nil)
        guard let view = xib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            addDashedBorderToUploadView()
        }
        
        private func addDashedBorderToUploadView() {
            let shapeLayer = CAShapeLayer()
            shapeLayer.name = "dashedBorder"
            shapeLayer.strokeColor = UIColor.systemGray2.cgColor
            shapeLayer.lineWidth = 1 / UIScreen.main.scale
            shapeLayer.lineDashPattern = [6, 3]
            shapeLayer.fillColor = nil
            
            shapeLayer.path = UIBezierPath(
                roundedRect: upLoadVIew.bounds,
                cornerRadius: 8
            ).cgPath
            
            upLoadVIew.layer.addSublayer(shapeLayer)
        }
    
}
