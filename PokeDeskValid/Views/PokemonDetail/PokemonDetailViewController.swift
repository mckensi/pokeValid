//
//  PokemonDetailViewController.swift
//  PokeDeskApp
//
//  Created by Daniel Steven Murcia Almanza on 25/08/20.
//  Copyright © 2020 selvamatic. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import NotificationBannerSwift

enum SectionDetail {
    case STATS
    case EVOLUTIONS
    case MOVEMENTS
}

class PokemonDetailViewController: UIViewController {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var viewHeaderContainer: UIView!
    @IBOutlet var lblTitleCollapsed: UILabel!
    @IBOutlet var lblTitleWithImage: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTitleView: UIView!
    @IBOutlet weak var containerTitleFrontView: UIView!
    @IBOutlet weak var btnStats: UIButton!
    @IBOutlet weak var btnEvolutions: UIButton!
    @IBOutlet weak var btnMovements: UIButton!
    @IBOutlet weak var containerViewTypePokemon: UIView!
    
    @IBOutlet weak var imgFirstType: UIImageView!
    @IBOutlet weak var imgSecondType: UIImageView!
    
    @IBOutlet weak var containerViewButtonStats: UIView!
    @IBOutlet weak var containerViewButtonsEvolutions: UIView!
    @IBOutlet weak var containerViewButtonMoves: UIView!
    
    @IBOutlet weak var ctrTitleTop: NSLayoutConstraint!
    @IBOutlet weak var imageMain: UIImageView!
    
    private var typeSectionSelected : SectionDetail = .STATS {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var viewModel = PokemonDetailViewModel()
    private var evolutions = [Species]()
    private let maxHeaderHeight: CGFloat = 300
    private let minHeaderHeight: CGFloat = 120
    private var previousScrollOffset: CGFloat = 0
    private var previousScrollViewHeight: CGFloat = 0
    private var imageUrl : URL?
    private var titleForLabels: String?
    
    private var idPokemon : Int?
    var pokemon : PokemonRes?
    
    private var stats : [String:Int]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    private var colors : [CGColor]? {
        didSet{
            btnStats?.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
            btnEvolutions?.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
            btnMovements?.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
        }
    }
    
    private var abilities : [Ability]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    private var moves : [Move]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.evolutions.removeAll()
    }
    
    private func setUpUI(){
        
        setUpPokemonDataUI()
        setUpTable()
        initListener()
        
        self.previousScrollViewHeight = self.tableView.contentSize.height
        
        if imageUrl != nil{
            imageMain.kf.setImage(with: imageUrl)
        }
        
        viewModel.getPokemonEvolutions(id: self.idPokemon ?? 1)
    }
    
    private func setUpPokemonDataUI(){
        guard let pokemon = pokemon else {return}
               self.stats = [String: Int]()
               guard let stats = pokemon.stats else {return}
               for stats in stats{
                   self.stats?.updateValue(stats.baseStat ?? 0, forKey: stats.stat?.name ?? "")
               }
               
               self.abilities = pokemon.abilities
               self.moves = pokemon.moves
               if let numberOfTypes = pokemon.types?.count, numberOfTypes != 0{
                   self.containerViewTypePokemon.isHidden = false
                   
                   if numberOfTypes == 1{
                       self.imgSecondType.isHidden = true
                       if let type = pokemon.types?[0].type?.name {
                           self.setHeaderGradient(type: type)
                           self.imgFirstType.image = getImageForType(type: type)
                       }
                   }else{
                       if let type = pokemon.types?[0].type?.name {
                           self.setHeaderGradient(type: type)
                           self.imgFirstType.image = getImageForType(type: type)
                       }
                       if let secondType = pokemon.types?[1].type?.name {
                           self.imgSecondType.image = getImageForType(type: secondType)
                       }
                       self.imgSecondType.isHidden = false
                   }
               }else{
                   self.containerViewTypePokemon.isHidden = true
               }
        
        lblTitleCollapsed.text = titleForLabels?.capitalizingFirstLetter()
        lblTitleWithImage.text = titleForLabels?.capitalizingFirstLetter()
        
        containerViewTypePokemon.layer.cornerRadius = 10
        containerViewButtonStats.layer.cornerRadius = 14
        containerViewButtonsEvolutions.layer.cornerRadius = 14
        containerViewButtonMoves.layer.cornerRadius = 14
    }
    
    private func setUpTable(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let nibCellStats = UINib(nibName: "PokemonStatsTableViewCell", bundle: nil)
        tableView.register(nibCellStats.self, forCellReuseIdentifier: "statsCell")
        
        let nibCellEvolution = UINib(nibName: "PokemonEvolutionTableViewCell", bundle: nil)
        tableView.register(nibCellEvolution.self, forCellReuseIdentifier: "evolutionCell")
        
        let nibCellAbilites = UINib(nibName: "PokemonAbilitiesTableViewCell", bundle: nil)
        tableView.register(nibCellAbilites.self, forCellReuseIdentifier: "abilityCell")
        
        let nibCellMoves = UINib(nibName: "PokemonMoveTableViewCell", bundle: nil)
        tableView.register(nibCellMoves.self, forCellReuseIdentifier: "moveCell")
        
        let nibCellWeaknesses = UINib(nibName: "PokemonWeaknessesTableViewCell", bundle: nil)
        tableView.register(nibCellWeaknesses.self, forCellReuseIdentifier: "weaknessesCell")
    }
    
    private func setHeaderGradient(type: String){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.viewHeaderContainer.bounds
        let colors = getColorTypePokemon(type: type)
        self.colors = colors
        gradientLayer.colors = [colors.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor, colors.last ??  #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.viewHeaderContainer.layer.insertSublayer(gradientLayer, at: 0)
        
        let gradientLayerBackTitle = CAGradientLayer()
        gradientLayerBackTitle.frame = self.containerTitleView.bounds
        gradientLayerBackTitle.colors = [colors.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor, colors.last ??  #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor]
        gradientLayerBackTitle.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayerBackTitle.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.containerTitleView.layer.insertSublayer(gradientLayerBackTitle, at: 0)
    }
    
    func setImage(url: URL){
        self.imageUrl = url
    }
    
    func setTitle(title: String){
        titleForLabels = title
    }
    
    func setIdPokemon(id: Int){
        self.idPokemon = id
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        self.updateHeader()
        DispatchQueue.main.async {
            self.containerTitleFrontView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        }
    }
    
    private func initListener(){
        
        viewModel.pokemonEvolutionsRes = { [weak self] response in
            self?.evolutions.append(response.chain?.species ?? Species())
            if response.chain?.evolvesTo?.count != 0{
                self?.evolutions.append(response.chain?.evolvesTo?[0].species ?? Species())
            }
            
            if response.chain?.evolvesTo != nil && response.chain?.evolvesTo?.count != 0 && response.chain?.evolvesTo?[0].evolvesTo?.count != 0 {
                self?.evolutions.append(response.chain?.evolvesTo?[0].evolvesTo?[0].species ?? Species())
            }
        }
        
        viewModel.onFailure = {
            let banner = NotificationBanner(title: "Error", subtitle: "Ocurrio un problema con tu busqueda, trabajamos para resolverlo.", style: .danger)
            banner.backgroundColor = .systemRed
            banner.show()
        }
        
        
    }
    
    //MARK: Actions
    
    @IBAction func actionHideView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionStats(_ sender: Any) {
        self.typeSectionSelected = .STATS
        containerViewButtonStats.backgroundColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1))
        containerViewButtonsEvolutions.backgroundColor = .systemBackground
        containerViewButtonMoves.backgroundColor = .systemBackground
        
        btnStats.setTitleColor(.white, for: .normal)
        btnEvolutions.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
        btnMovements.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
    }
    
    @IBAction func actionEvolutions(_ sender: Any) {
        self.typeSectionSelected = .EVOLUTIONS
        containerViewButtonsEvolutions.backgroundColor =  UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1))
        containerViewButtonStats.backgroundColor = .systemBackground
        containerViewButtonMoves.backgroundColor = .systemBackground
        
        btnEvolutions.setTitleColor(.white, for: .normal)
        btnStats.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
        btnMovements.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
    }
    
    @IBAction func actionMoves(_ sender: Any) {
        self.typeSectionSelected = .MOVEMENTS
        containerViewButtonMoves.backgroundColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1))
        containerViewButtonStats.backgroundColor = .systemBackground
        containerViewButtonsEvolutions.backgroundColor = .systemBackground
        
        btnMovements.setTitleColor(.white, for: .normal)
        btnStats.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
        btnEvolutions.setTitleColor(UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1)), for: .normal)
    }
}

extension PokemonDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch typeSectionSelected {
        case .STATS:
            return 3
        case .EVOLUTIONS:
            return 1
        case .MOVEMENTS:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch typeSectionSelected {
        case .STATS:
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            case 2:
                return abilities?.count ?? 0
            default :
                return 0
            }
            
        case .EVOLUTIONS:
            return evolutions.count
        case .MOVEMENTS:
            return moves?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch typeSectionSelected {
        case .STATS:
            switch indexPath.section {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell") as? PokemonStatsTableViewCell
                cell?.stats = stats
                cell?.colors = self.colors
                cell?.selectionStyle = .none
                return cell ?? UITableViewCell()
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "weaknessesCell") as? PokemonWeaknessesTableViewCell
                cell?.selectionStyle = .none
                return cell ?? UITableViewCell()
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "abilityCell") as? PokemonAbilitiesTableViewCell
                cell?.lblTitle.text = abilities?[indexPath.row].ability?.name?.capitalizingFirstLetter() ?? ""
                cell?.lblTitle.textColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor)
                cell?.selectionStyle = .none
                return cell ?? UITableViewCell()
            default:
                return UITableViewCell()
            }
            
        case .EVOLUTIONS:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "evolutionCell") as! PokemonEvolutionTableViewCell
            let firstIndex = indexPath.row
            let secondIndex = indexPath.row + 1
            let urlEvolution = evolutions[firstIndex].url ?? ""
            let charactersUrl = urlEvolution.split(separator: "/")
            let idPokemon = charactersUrl.last
            let idString = String(idPokemon ?? "")
            var id2 : String?
            
            if secondIndex > evolutions.count - 1{
                let urlEvolution2 = evolutions[indexPath.row].url ?? ""
                let charactersUrl = urlEvolution2.split(separator: "/")
                let idPokemon = charactersUrl.last
                id2 = String(idPokemon ?? "")
            }else{
                let urlEvolution2 = evolutions[indexPath.row + 1].url ?? ""
                let charactersUrl = urlEvolution2.split(separator: "/")
                let idPokemon = charactersUrl.last
                id2 = String(idPokemon ?? "")
            }
            
            if let fisrtEvolutionUrl = URL(string: "\(PokemonImageApi.baseImageUrl)\(idString).png") {
                print(fisrtEvolutionUrl)
                cell.imgViewFirstEvolution?.kf.setImage(with: fisrtEvolutionUrl)
            }
            
            if let secondEvolutionUrl = URL(string: "\(PokemonImageApi.baseImageUrl)\(id2 ?? "1").png") {
                print(secondEvolutionUrl)
                cell.imgViewSecondEvolution?.kf.setImage(with: secondEvolutionUrl)
            }
            
            return cell
            
        case .MOVEMENTS:
            let move = moves?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "moveCell") as! PokemonMoveTableViewCell
            cell.lblNameMove.text = move?.move?.name?.capitalizingFirstLetter() ?? ""
            if move?.versionGroupDetails?.count != 0 {
                cell.lblLevelMove.text = "Level \(move?.versionGroupDetails?[0].levelLearnedAt ?? 0)"
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch typeSectionSelected {
        case .STATS:
            switch section {
            case 0:
                return 0
            case 1:
                return 50
            case 2:
                return 50
            default:
                return 0
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch typeSectionSelected {
        case .STATS:
            switch section {
            case 0:
                return UIView()
            case 1:
                let headerWeaknesses = HeaderStatsView.instanceFromNib() as? HeaderStatsView
                headerWeaknesses?.lblTitleHeader.text = "Weaknesses"
                headerWeaknesses?.lblTitleHeader.textColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor)
                return headerWeaknesses ?? UIView()
            case 2:
                let headerWeaknesses = HeaderStatsView.instanceFromNib() as? HeaderStatsView
                headerWeaknesses?.lblTitleHeader.text = "Abilities"
                headerWeaknesses?.lblTitleHeader.textColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1).cgColor)
                return headerWeaknesses ?? UIView()
            default:
                return UIView()
            }
            
     
        default:
            return UIView()
        }
    }
}

extension PokemonDetailViewController: UITableViewDelegate {
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        defer {
            self.previousScrollViewHeight = scrollView.contentSize.height
            self.previousScrollOffset = scrollView.contentOffset.y
        }
        
        let heightDiff = scrollView.contentSize.height - self.previousScrollViewHeight
        let scrollDiff = (scrollView.contentOffset.y - self.previousScrollOffset)
        
        guard heightDiff == 0 else { return }
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        _ = openAmount / range
        
        self.ctrTitleTop.constant = -openAmount + 48
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch typeSectionSelected {
        case .STATS:
            switch indexPath.section {
            case 0:
                return 200
            case 1:
                return 390
            case 2:
                return 60
            default:
                return 0
            }
        case .EVOLUTIONS:
            return 150
        case .MOVEMENTS:
            return 60
        }
    }
}

extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
