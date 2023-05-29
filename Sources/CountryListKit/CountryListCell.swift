//
//  CountryListCell.swift
//  
//
//  Created by Sandeep Tharu on 28/05/2023.
//

import UIKit
import CountryKit

class  CountryListCell: UITableViewCell{
    
    //MARK: properties
    static let identifier: String = "CountryListCell_ID"
    var showPhoneCode : Bool = true
    
    private var textFont : UIFont       = UIFont.systemFont(ofSize: 16)
    private var textColor : UIColor     = .lightGray
    
    //MARK: UI Elements
    private lazy var flagIcon: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    private lazy var countryNameLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.font = self.textFont
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var countryCodeLabel: UILabel = {
        let view = UILabel()
        view.font = self.textFont
        view.textColor = self.textColor
        view.textAlignment = .right
        return view
    }()
    
    //MARK: initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.uiSetUp()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: setup UI
    private func uiSetUp(){
        
        self.addSubview(self.flagIcon)
        flagIcon.translatesAutoresizingMaskIntoConstraints = false
        let flagIconConstraints = [
            flagIcon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            flagIcon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            flagIcon.heightAnchor.constraint(equalToConstant: 20),
            flagIcon.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        self.addSubview(self.countryCodeLabel)
        countryCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        let countryCodeConstraints = [
            countryCodeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            countryCodeLabel.widthAnchor.constraint(equalToConstant: 100),
            countryCodeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ]
        
        self.addSubview(self.countryNameLabel)
        countryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let countryNameConstraints = [
            countryNameLabel.leadingAnchor.constraint(equalTo: self.flagIcon.trailingAnchor, constant: 10),
            countryNameLabel.trailingAnchor.constraint(equalTo: self.countryCodeLabel.leadingAnchor, constant: -10),
            countryNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            countryNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        ]
        
        NSLayoutConstraint.activate(
            flagIconConstraints
            + countryCodeConstraints
            + countryNameConstraints
        )
    }
    
    func loadData(data: CountryDTO){
        self.countryNameLabel.text  = data.getName()
        self.countryCodeLabel.text  = data.getDialCode()
        self.flagIcon.image         = data.getFlagImage()
        
        self.countryCodeLabel.isHidden = !self.showPhoneCode
    }
    
}
