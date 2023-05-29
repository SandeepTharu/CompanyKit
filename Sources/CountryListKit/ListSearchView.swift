//
//  ListSearchView.swift
//  
//
//  Created by Sandeep Tharu on 28/05/2023.
//

import UIKit

protocol ListSearchViewDelegate: AnyObject {
    func textDidChanged(_ text: String?)
    func textDidStart()
}

class ListSearchView: UIView {

    //MARK: properties
    weak var delegate:ListSearchViewDelegate?
    
    //ui properties for search
    private var searchFont : UIFont         = UIFont.boldSystemFont(ofSize: 16)
    private var searchTextColor : UIColor   = .black
    private var searchTintColor : UIColor   = .gray
    private var cornerRadius    : CGFloat   = 10
    
    //MARK: UI Elements
    private lazy var searchImageView: UIImageView = {
        let view            = UIImageView()
        let path            = Bundle.module.path(forResource: "iconFeatherSearch", ofType: "png")
        view.image         = UIImage(contentsOfFile: path ?? "")?.withRenderingMode(.alwaysTemplate)
        view.tintColor     = self.searchTintColor
        return view
    }()
    
    private lazy var searchTextField: UITextField = {
        let view = UITextField()
        view.textColor = self.searchTextColor
        view.attributedPlaceholder = self.attributedText(key:"Search",
                                                         font: searchFont,
                                                         color: searchTintColor.withAlphaComponent(0.5)
        )
        view.addTarget(self, action: #selector(textFieldDidBegin(_:)), for: .editingDidBegin)
        view.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return view
    }()
    
    private  lazy var verticalBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    //MARK: initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.uiSetUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.uiSetUp()
    }
    
    //MARK: lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.cornerRadius
        self.dropShadow(scale: true, shadowRadius: 5)
    }
    
    //MARK: actions
    @objc func textFieldDidBegin(_ textField: UITextField){
        if let del = self.delegate
        {
            del.textDidStart()
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField){
        if let del = self.delegate{
            del.textDidChanged(textField.text)
        }
    }
    
    //MARK: private functions
    private func uiSetUp(){
        self.backgroundColor = .white
        self.addSubview(searchImageView)
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        let searchImageConstraints = [
            searchImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            searchImageView.heightAnchor.constraint(equalToConstant: 22.4),
            searchImageView.widthAnchor.constraint(equalToConstant: 22.4)
        ]
        
        self.addSubview(searchTextField)
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        let searchTestFieldConstraints = [
            searchTextField.leadingAnchor.constraint(equalTo: self.searchImageView.trailingAnchor, constant: 14.6),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -24.6),
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(
            searchImageConstraints + searchTestFieldConstraints
        )
        
    }
    
    private func attributedText(kern: CGFloat = 0.0, key: String, font: UIFont, color: UIColor = .black) -> NSAttributedString{
        let textAttributes: [NSAttributedString.Key : Any] = [
            .foregroundColor : color,
            .kern : kern,
            .font: font
        ]
        return NSAttributedString(string: key, attributes: textAttributes)
    }

}

extension ListSearchView{
    
    func dropShadow(scale: Bool = true, shadowRadius : CGFloat = 10) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.16
        layer.shadowOffset = CGSize(width: -1, height: 2)
        layer.shadowRadius = shadowRadius
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
