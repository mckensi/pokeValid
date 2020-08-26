//
//  ItemsViewController.swift
//  PokeDeskApp
//
//  Created by Daniel Steven Murcia Almanza on 29/04/20.
//  Copyright © 2020 Daniel Steven Murcia Almanza. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblViewItems: UITableView!
    
    private var items : [Species]?
    private var itemListShow : [Species]? {
        didSet {
            DispatchQueue.main.async {
                self.tblViewItems.reloadData()
            }
        }
    }
    private var currentPage = 0
    private var showFilteredList = false
    private var urlNextPage : String?
    private var viewModel = ItemsViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.getListMoves(limit: 20, offset: 0, urlNextPage: urlNextPage)
    }
    
    private func setUpUI(){
        setUpTableView()
        initListener()
        setupKeyboard()
        setHeaderGradient()
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enabledDistanceHandlingClasses.append(ItemsViewController.self)
        IQKeyboardManager.shared.enabledToolbarClasses.append(ItemsViewController.self)
        IQKeyboardManager.shared.enabledTouchResignedClasses.append(ItemsViewController.self)
    }
    
    
    private func setHeaderGradient(){
        let firstColor = #colorLiteral(red: 0.3176470588, green: 0.9098039216, blue: 0.368627451, alpha: 1).cgColor
        let secondColor = #colorLiteral(red: 0.4352941176, green: 0.8705882353, blue: 0.9803921569, alpha: 1).cgColor
        let thirdColor = #colorLiteral(red: 0.5529411765, green: 0.8784313725, blue: 0.3803921569, alpha: 1).cgColor
        let lastColor = #colorLiteral(red: 0.3176470588, green: 0.9098039216, blue: 0.3803921569, alpha: 1).cgColor
        
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [firstColor, secondColor, thirdColor, lastColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setUpTableView(){
        searchBar.delegate = self
        tblViewItems.delegate = self
        tblViewItems.dataSource = self
        searchBar.searchBarStyle = .minimal
        let nibCellMoves = UINib(nibName: "PokemonMoveTableViewCell", bundle: nil)
        tblViewItems.register(nibCellMoves.self, forCellReuseIdentifier: "moveCell")
    }
    
    private func initListener(){
        viewModel.itemsListRes = { [weak self] response in
            
            if self?.currentPage != 0 {
                self?.items?.append(contentsOf: response.results ?? [Species]())
            }else{
                self?.items = response.results
            }
            
            self?.itemListShow = self?.items
            self?.urlNextPage = response.next
            
            DispatchQueue.main.async {
                self?.tblViewItems.reloadData()
            }
        }
    }
    
    
}

extension ItemsViewController : UITableViewDelegate{
    
}

extension ItemsViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemListShow?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemListShow?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell") as! PokemonMoveTableViewCell
        cell.lblNameMove.text = item?.name?.capitalizingFirstLetter() ?? ""
        cell.lblLevelMove.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((self.itemListShow?.count ?? 0) - 2) {
            currentPage = currentPage + 1
            viewModel.getListMoves(limit: 20, offset: 0, urlNextPage: urlNextPage)
        }
    }
    
}

extension ItemsViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            showFilteredList = true
            itemListShow = items?.filter {($0.name?.contains(searchText.lowercased())) ?? false }
        }else{
            showFilteredList = false
            itemListShow = items
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
