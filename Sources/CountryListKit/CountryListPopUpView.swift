//
//  CountryListPopUpView.swift
//  
//
//  Created by Sandeep Tharu on 28/05/2023.
//

import UIKit
import CountryKit

public protocol CountryListPopUpDelegate : AnyObject{
    func didSelectCountry(selectedCountry : CountryDTO)
}

public class CountryListPopUpView: UIView {
    
    private var isSearchEnabled: Bool = false
    var showPhoneCode : Bool = true
    
    var delegate : CountryListPopUpDelegate

    private var countryList     : [CountryDTO] = []
    private var searchedList    : [CountryDTO] = []
    
    var closeButtonColor : UIColor = .black
    
    //MARK: UI Elements
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let view = UIButton(type: .system)
        let path            = Bundle.module.path(forResource: "close", ofType: "png")
        let image           = UIImage(contentsOfFile: path ?? "")?.withRenderingMode(.alwaysTemplate)
        view.setImage(image, for: .normal)
        view.tintColor = self.closeButtonColor
        view.addTarget(self, action: #selector(self.closePressed(_:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var searchBar: ListSearchView = {
        let view = ListSearchView()
        view.delegate = self
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(CountryListCell.self, forCellReuseIdentifier: CountryListCell.identifier)
        view.dataSource = self
        view.delegate = self
        return view
    }()
    
    //MARK: initialization
    public init(delegate : CountryListPopUpDelegate){
        self.delegate = delegate
        let frame = UIScreen.main.bounds
        super.init(frame: frame)
        self.uiSetUp()
        self.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let _ = CountryManager(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    //MARK: Lifecycle
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 20
        self.searchBar.layer.cornerRadius = 32
    }
    
    //MARK: actions
    @objc func closePressed(_ sender: UIButton){
        self.dismiss()
    }
    
    
    //MARK: private funcs
    private func dismiss(){
        self.alpha = 1
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {() -> Void in
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    public func present(from vc : UIViewController){
        self.containerView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.alpha = 0
        vc.view.addSubview(self)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {() -> Void in
            self.containerView.transform = CGAffineTransform.identity
            self.alpha = 1
        }, completion: { _ in })
    }
    
    private func uiSetUp(){
        
        self.addSubview(self.containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 63),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -59),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        self.containerView.addSubview(self.closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 50),
            closeButton.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        self.containerView.addSubview(self.searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 64.3),
            searchBar.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 28),
            searchBar.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -28),
            searchBar.heightAnchor.constraint(equalToConstant: 64)
        ])

        self.containerView.addSubview(self.tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 24.7),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -33)
        ])
    }
}

extension CountryListPopUpView : UITableViewDataSource{
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.isSearchEnabled {
        case true:
            return self.searchedList.count
        case false:
            return self.countryList.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryListCell.identifier, for: indexPath) as? CountryListCell
            else {
                return CountryListCell()
        }
        cell.showPhoneCode = self.showPhoneCode
        switch self.isSearchEnabled {
        case true:
            cell.loadData(data: self.searchedList[indexPath.row])
        case false:
            cell.loadData(data: self.countryList[indexPath.row])
        }
        return cell
    }
}

extension CountryListPopUpView : UITableViewDelegate{
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.isSearchEnabled {
        case true:
            let data = self.searchedList[indexPath.row]
            self.delegate.didSelectCountry(selectedCountry: data)
        case false:
            let data = self.countryList[indexPath.row]
            self.delegate.didSelectCountry(selectedCountry: data)
        }
        self.dismiss()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension CountryListPopUpView : CountryManagerDelegate{
    public func didLoadCountry(countryList: [CountryKit.CountryDTO]) {
        self.countryList = countryList
    }
}

// MARK: UISearchBarDelegate
extension CountryListPopUpView: ListSearchViewDelegate{
    
    func textDidStart() {}
    
    func textDidChanged(_ text: String?) {
        guard let searchText = text , searchText != "" else{
            self.isSearchEnabled = false
            return
        }
        self.isSearchEnabled = true
        self.searchedList = self.countryList.filter({
            return $0.getName().lowercased().contains(searchText.lowercased())
        })
        self.tableView.reloadData()
    }
    
}
