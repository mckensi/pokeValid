//
//  PokemonDetailViewController.swift
//  PokeDeskApp
//
//  Created by Daniel Steven MURCIA ALMANZA on 10/24/19.
//  Copyright © 2019 Daniel Steven Murcia Almanza. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class MovesDetailViewController: UIViewController {
    
    //MARK: Outlets
    
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
    @IBOutlet weak var lblTypePokemon: UILabel!
    @IBOutlet weak var containerViewTypePokemon: UIView!
    
    @IBOutlet weak var containerViewButtonStats: UIView!
    @IBOutlet weak var containerViewButtonsEvolutions: UIView!
    @IBOutlet weak var containerViewButtonMoves: UIView!
    
    @IBOutlet weak var lblBasePowerTitle: UILabel!
    @IBOutlet weak var lblBasePower: UILabel!
    @IBOutlet weak var lblAccuracyTitle: UILabel!
    @IBOutlet weak var lblAccuracy: UILabel!
    @IBOutlet weak var lblPpTitle: UILabel!
    @IBOutlet weak var lblPp: UILabel!
    
    @IBOutlet weak var imgType: UIImageView!
    
    
    private var viewModel = PokemonDetailViewModel()
    private var evolutions = [Species]()
    private let maxHeaderHeight: CGFloat = 300
    private let minHeaderHeight: CGFloat = 120
    private var previousScrollOffset: CGFloat = 0
    private var previousScrollViewHeight: CGFloat = 0
    private var imageUrl : URL?
    private var titleForLabels: String?
    
    var move : MoveRes?
    
    private var stats : [String:Int]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var abilities : [Ability]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var moves : [Move]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var colors : [CGColor]? {
        didSet{
            lblAccuracyTitle?.textColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1))
            lblBasePowerTitle?.textColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1))
            lblPpTitle?.textColor = UIColor(cgColor: colors?.first ?? #colorLiteral(red: 0.3330000043, green: 0.6200000048, blue: 0.875, alpha: 1))
           
        }
    }
    
    
    @IBOutlet weak var ctrTitleTop: NSLayoutConstraint!
    @IBOutlet weak var imageMain: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.evolutions.removeAll()
    }
    
    private func setUpUI(){
        setHeaderGradient()
        setUpTable()
        
        self.previousScrollViewHeight = self.tableView.contentSize.height
        
        if imageUrl != nil{
            imageMain.kf.setImage(with: imageUrl)
        }
        
        lblTitleCollapsed.text = titleForLabels?.capitalizingFirstLetter()
        lblTitleWithImage.text = titleForLabels?.capitalizingFirstLetter()
        
        containerViewTypePokemon.layer.cornerRadius = 10
        
        containerViewButtonStats.layer.cornerRadius = 14
        containerViewButtonsEvolutions.layer.cornerRadius = 14
        containerViewButtonMoves.layer.cornerRadius = 14
        
        if let move = move{
            lblAccuracy.text = ("\(move.acuracy ?? 0)")
            lblBasePower.text = "\(move.power ?? 0)"
            lblPp.text = "\(move.pp ?? 0)"
            lblTitleCollapsed.text = move.name ?? ""
            lblTitleWithImage.text = move.name ?? ""
            tableView.isHidden = true
            
            imageMain.image = getImageMainForType(type: move.type?.name ?? "")
            imgType.image = getImageForType(type: move.type?.name ?? "")
        }
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
    
    private func setHeaderGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.viewHeaderContainer.bounds
        
        let colors = getColorTypePokemon(type: move?.type?.name ?? "")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        self.updateHeader()
        DispatchQueue.main.async {
            self.containerTitleFrontView.roundCorners(corners: [.topLeft, .topRight], radius: 40)
        }
    }
    
    //MARK: Actions
    
    @IBAction func actionHideView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension MovesDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension MovesDetailViewController: UITableViewDelegate {
    
    
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
}
