//
//  ViewController.swift
//  PokeDeskValid
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import UIKit
import Kingfisher
import IQKeyboardManagerSwift

class ViewController: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    var viewModel = HomeViewModel()
    
    var pokemonList : [PokemonData]? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var pokemonListToShow : [PokemonData]? {
           didSet{
               DispatchQueue.main.async {
                   self.tableView.reloadData()
               }
           }
       }
    
    var showFilteredList = false
    
    var currentPage = 0
    var urlNextPage: String?
    var pokemonImages :  [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        initListener()
        viewModel.getPokemonList(limit: 20, offset: currentPage, urlNextPage: urlNextPage)
        searchBar.delegate = self
    }
    
    func setUpUI(){
        searchBar.searchBarStyle = .minimal
        setUpTableView()
        setHeaderGradient()
        setupKeyboard()
    }
    
    private func setupKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enabledDistanceHandlingClasses.append(ViewController.self)
        IQKeyboardManager.shared.enabledToolbarClasses.append(ViewController.self)
        IQKeyboardManager.shared.enabledTouchResignedClasses.append(ViewController.self)
    }
    
    func setHeaderGradient(){
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
    
    func setUpTableView(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nibCell = UINib(nibName: "PokemonTableViewCell", bundle: nil)
        tableView.register(nibCell.self, forCellReuseIdentifier: "pokemonCell")
    }
    
    
    func initListener(){
        viewModel.pokemonListRes = { response in
            if !(response.results?.isEmpty ?? false){
                self.urlNextPage = response.next
                if self.currentPage != 0 {
                    self.pokemonList?.append(contentsOf: response.results ?? [PokemonData]())
                }else{
                    self.pokemonList = response.results
                }
                
                self.pokemonListToShow = self.pokemonList
            }
        }
    }
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = self.pokemonListToShow?[indexPath.row]
        let charactersUrl = pokemon?.url?.split(separator: "/")
        let idPokemon = charactersUrl?.last
        let idString = String(idPokemon ?? "")
        
        let vc = PokemonDetailViewController.instantiateFromXIB() as PokemonDetailViewController
        vc.modalPresentationStyle = .fullScreen
        
        if let url = URL(string: "\(PokemonImageApi.baseImageUrl)\(idPokemon!).png") {
            vc.setImage(url: url)
        }
        
        vc.setIdPokemon(id: Int(idString) ?? 0)
        vc.setTitle(title: pokemon?.name ?? "")
        
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonListToShow?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let pokemon = self.pokemonListToShow?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokemonCell") as? PokemonTableViewCell
        cell?.lblTitle.text = pokemon?.name?.capitalizingFirstLetter() ?? ""
        
        let charactersUrl = pokemon?.url?.split(separator: "/")
        let idPokemon = charactersUrl?.last ?? ""
        
        if let url = URL(string: "https://pokeres.bastionbot.org/images/pokemon/\(idPokemon).png") {
            cell?.imageView?.kf.setImage(with: url)
        }
        cell?.selectionStyle = .none
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == ((self.pokemonList?.count ?? 0) - 2) {
            currentPage = currentPage + 1
            viewModel.getPokemonList(limit: 20, offset: 0, urlNextPage: urlNextPage)
        }
    }
}


extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            showFilteredList = true
            pokemonListToShow = pokemonList?.filter {(($0.name?.contains(searchText.lowercased())) ?? false) }
        }else{
            showFilteredList = false
            pokemonListToShow = pokemonList
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
}
