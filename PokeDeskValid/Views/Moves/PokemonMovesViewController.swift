//
//  PokemonMovesViewController.swift
//  PokeDeskApp
//
//  Created by Daniel Steven Murcia Almanza on 29/04/20.
//  Copyright © 2020 Daniel Steven Murcia Almanza. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PokemonMovesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tblViewMoves: UITableView!
    
    private var currentPage = 0
    private var urlNextPage : String?
    private var moves : [Species]?
    private var movesListShow : [Species]? {
        didSet{
            DispatchQueue.main.async {
                self.tblViewMoves.reloadData()
            }
        }
    }
    
    private var viewModel = PokemonMovesViewModel()
    private var showFilteredList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        viewModel.getListMoves(limit: 20, offset: 0, urlNextPage: nil)
    }
    
    private func setUpUI(){
        searchBar.delegate = self
        setUpTableView()
        initListener()
        setupKeyboard()
        setHeaderGradient()
        searchBar.searchBarStyle = .minimal
    }
    
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enabledDistanceHandlingClasses.append(PokemonMovesViewController.self)
        IQKeyboardManager.shared.enabledToolbarClasses.append(PokemonMovesViewController.self)
        IQKeyboardManager.shared.enabledTouchResignedClasses.append(PokemonMovesViewController.self)
    }
    
    
    private func initListener(){
        viewModel.pokemonMovesListRes = { [weak self] response in
            if self?.currentPage != 0 {
                self?.moves?.append(contentsOf: response.results ?? [Species]())
            }else{
                self?.moves = response.results
            }
            
            self?.movesListShow = self?.moves
       
            self?.urlNextPage = response.next
            DispatchQueue.main.async {
                self?.tblViewMoves.reloadData()
            }
        }
    }
    
    private func setUpTableView(){
        tblViewMoves.delegate = self
        tblViewMoves.dataSource = self
        
        let nibCellMoves = UINib(nibName: "PokemonMoveTableViewCell", bundle: nil)
        tblViewMoves.register(nibCellMoves.self, forCellReuseIdentifier: "moveCell")
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

}

extension PokemonMovesViewController : UITableViewDelegate {
    
}


extension PokemonMovesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movesListShow?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let move = movesListShow?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell") as! PokemonMoveTableViewCell
        cell.lblNameMove.text = move?.name?.capitalizingFirstLetter() ?? ""
        cell.lblLevelMove.isHidden = true
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if indexPath.row == ((self.movesListShow?.count ?? 0) - 2) {
               currentPage = currentPage + 1
               viewModel.getListMoves(limit: 20, offset: 0, urlNextPage: urlNextPage)
           }
       }
    
}

extension PokemonMovesViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            showFilteredList = true
            movesListShow = moves?.filter {($0.name?.contains(searchText.lowercased())) ?? false }
        }else{
            showFilteredList = false
            movesListShow = moves
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
