//
//  PokemonListVC.swift
//  Pokemon
//
//  Created by ABC on 21/07/21.
//

import UIKit

class PokemonListVC: UIViewController {
    
    @IBOutlet weak var retryBtn: UIButton!
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var pokemonTableVw: UITableView!
    
    private var pokemonViewModel : PokemonViewModel!
    var pokemonArr = [PokemonData]()
    var filteredPokemonArr = [PokemonData]()
    var sortedPokemonArr = [PokemonData]()
    //var filteredSortedPokemonArr = [PokemonData]()
    
    var spinner = UIActivityIndicatorView(style: .gray)
    var refreshControl = UIRefreshControl()
    
    var totalCount = 0
    var currentPageNum = 1
    var nextPageUrl = ""
    var isSearchEnabled = false
    var isSortingEnabled = false
    
    var localPokemonData : Pokemon?
    var sortKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.showLoader(view:self.view)
        initializeUI()
        bindViewModel()
        fetchLocalData()
    }
    
    func initializeUI() {
        
        noDataLbl.isHidden = true
        retryBtn.isHidden = true
        searchTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        refreshControl.addTarget(self, action:
            #selector(eventsRefresh),for: UIControl.Event.valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0.737254902, blue: 0, alpha: 1)
        self.pokemonTableVw.addSubview(refreshControl)
        
//        self.title = "Pokemon encyclopedia"
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//        navigationController?.navigationBar.titleTextAttributes = Utility.shared.titleAttributes(textColor: #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1))
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: Utility.shared.addrightBarButton(onVC: self, tapAction: #selector(rightBtnAction)))
//
        pokemonTableVw.register(UINib(nibName: "PokemonTableCell", bundle: nil), forCellReuseIdentifier: "PokemonTableCell")
        pokemonTableVw.register(UINib(nibName: "ErrorTableCell", bundle: nil), forCellReuseIdentifier: "ErrorTableCell")
        
    }
    
    @IBAction func didPressSortBtn(_ sender: Any) {
        rightBtnAction()
    }
    func fetchLocalData() {
        
        localPokemonData = UserDefaults.standard.retrieve(object: Pokemon.self, fromKey: "localPokemonModel")
        if localPokemonData != nil {
            self.nextPageUrl = localPokemonData!.next
            self.pokemonArr = localPokemonData!.results
            self.totalCount = self.pokemonArr.count
            self.pokemonTableVw.reloadData()
        }else{
            callApiToGetPokemonData(isSwipeToRefresh: false)
        }
    }
    
    @objc private func eventsRefresh() {
        if localPokemonData != nil {
            self.refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.05)
        }else{
            currentPageNum = 1
            self.pokemonArr.removeAll()
            self.pokemonTableVw.reloadData()
            callApiToGetPokemonData(isSwipeToRefresh:true)
        }
    }
  
    //MARK:  button actions
    @IBAction func didPressRetry(_ sender: Any) {
        callApiToGetPokemonData(isSwipeToRefresh:false)
    }
    
    @objc func rightBtnAction() {
        print("right clicked")
        Utility.shared.showActionSheet(vc:self,title:"",message:"Sort by",completion: { sortBy in
            self.sortKey = sortBy
            
            if sortBy == "number" {
                if !self.isSearchEnabled {
                    self.isSortingEnabled = true
                    self.sortedPokemonArr = self.pokemonArr.sorted(by: { $0.pokemonDetail!.baseExperience < $1.pokemonDetail!.baseExperience })
                    self.pokemonTableVw.reloadData()
                }else{
                    Utility.shared.displayAlert(title: "", message: "Sorting is not available with search", control: ["Ok"])
                }
            }else if sortBy == "alphabet" {
                if !self.isSearchEnabled {
                    self.isSortingEnabled = true
                    self.sortedPokemonArr = self.pokemonArr.sorted(by: { $0.name < $1.name })
                    self.pokemonTableVw.reloadData()
                }else{
                    Utility.shared.displayAlert(title: "", message: "Sorting is not available with search", control: ["Ok"])
                }
            }else{
                self.isSortingEnabled = false
                self.sortedPokemonArr.removeAll()
                self.pokemonTableVw.reloadData()
            }
        })
    }
    
    //hide show pagination spinner
    private func showSpinner() {
        spinner.color = .gray
        spinner.startAnimating()
        self.currentPageNum = currentPageNum + 1
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: pokemonTableVw.bounds.width, height: CGFloat(44))
        pokemonTableVw.tableFooterView = spinner
        callApiToGetPokemonData(isSwipeToRefresh:false)
    }
    
    func hideSpinner() {
        self.pokemonTableVw.tableFooterView = UIView()
        self.spinner.stopAnimating()
    }
    
    //impliment search
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let searchText = textField.text!
        if searchText.isEmpty {
            isSearchEnabled = false
            pokemonTableVw.reloadData()
        }else{
            isSearchEnabled = true
            self.filteredPokemonArr = self.pokemonArr.filter {
                $0.name.range(of:  searchText, options: .caseInsensitive) != nil || ($0.pokemonDetail?.abilities.count != 0 ? ($0.pokemonDetail?.abilities[0].ability.name.range(of:  searchText, options: .caseInsensitive) != nil) : false)
            }
            pokemonTableVw.reloadData()
        }
    }

    //bind view model
    func bindViewModel() {
        self.pokemonViewModel =  PokemonViewModel()
        self.pokemonViewModel.bindDataToController = {
            self.removeLoader()
            self.pokemonArr.append(contentsOf: self.pokemonViewModel.pokemonData.results)
            self.isSortingEnabled = false
            self.sortKey = ""
            self.sortedPokemonArr.removeAll()
            self.totalCount = self.pokemonArr.count
            let pokemonData = self.pokemonViewModel.pokemonData
            pokemonData?.results = self.pokemonArr
            UserDefaults.standard.save(customObject: pokemonData, inKey: "localPokemonModel")
            self.nextPageUrl = self.pokemonViewModel.pokemonData.next
            DispatchQueue.main.async {
                self.noDataLbl.isHidden = !self.pokemonArr.isEmpty
                self.retryBtn.isHidden = !self.pokemonArr.isEmpty
                self.pokemonTableVw.isHidden =  self.pokemonArr.isEmpty
                self.refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.05)
                self.hideSpinner()
                self.pokemonTableVw.reloadData()
            }
        }
        
        self.pokemonViewModel.bindErrorToController = {
            self.removeLoader()
            DispatchQueue.main.async {
                self.noDataLbl.isHidden = false
                self.retryBtn.isHidden = false
                self.pokemonTableVw.isHidden =  true
                self.refreshControl.perform(#selector(UIRefreshControl.endRefreshing), with: nil, afterDelay: 0.05)
                self.hideSpinner()
                self.pokemonTableVw.reloadData()
            }
        }
    }
    
    //call api
    func callApiToGetPokemonData(isSwipeToRefresh:Bool) {
        let url = currentPageNum == 1 ? apiUrl.getPokemonUrl : nextPageUrl
        if currentPageNum == 1 && !isSwipeToRefresh {
            self.showLoader(view:self.view)
        }
        self.pokemonViewModel.callFuncToGetPokemonData(url: url, showLoader:currentPageNum == 1)
    }
    
}

extension PokemonListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSortingEnabled {
            return sortedPokemonArr.count
        }else{
            return isSearchEnabled ? filteredPokemonArr.count : pokemonArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var pokemonData = [PokemonData]()
        if isSortingEnabled {
            pokemonData = sortedPokemonArr
        }else{
            pokemonData = isSearchEnabled ? filteredPokemonArr : pokemonArr
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableCell") as! PokemonTableCell
        cell.bindData(data: pokemonData[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
            
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if !isSearchEnabled {
            if indexPath.row == self.pokemonArr.count - 1 {
                if !nextPageUrl.isEmpty && totalCount < 300 { //check if more item exist
                    self.showSpinner()
                }else{
                    self.hideSpinner()
                }
            }
        }
        
    }
}

extension PokemonListVC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == searchTf {
            if isSortingEnabled {
                view.endEditing(true)
                Utility.shared.displayAlert(title: "", message: "Searching is not available with sorting", control: ["Ok"])
            }
        }
    }
}
