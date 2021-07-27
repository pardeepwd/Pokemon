//
//  PokemonTableCell.swift
//  Pokemon
//
//  Created by ABC on 21/07/21.
//

import UIKit

class PokemonTableCell: UITableViewCell {

    @IBOutlet weak var pokemonAbility: UILabel!
    @IBOutlet weak var pokemonNumber: UILabel!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var pokemonImg: UIImageView!
    @IBOutlet weak var imgBGColor: UIView!
    @IBOutlet weak var tagsCollectionView: UICollectionView!
    
    var tagsArray: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
        tagsCollectionView.register(UINib(nibName: "TagsColViewCell", bundle: nil), forCellWithReuseIdentifier: "TagsColViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Downloading the images from the URL
    func getImageFromURL(url: URL, completion: @escaping(UIImage) ->()) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            
            guard let data = data else {return}
            let img1 = UIImage(data: data)
            if let img1 = img1 {
                completion(img1)
            }
            
            return
        }.resume()
    }
    
    
    // Setting the 2 Sprites in Image View with an Animation.
    func setAnimatedImageToImageView(arr: [UIImage]) {
        DispatchQueue.main.async {
            self.pokemonImg.animationImages = arr
            self.pokemonImg.animationDuration = 1.0
            self.pokemonImg.startAnimating()
            
            self.imgBGColor.backgroundColor = arr[0].getPixelColor(pos: CGPoint(x: arr[0].size.width / 2, y: arr[0].size.height / 2))
            self.imgBGColor.alpha = 0.25
        }
    }
    
    func bindData(data:PokemonData) {
        pokemonName.text = data.name
        if data.pokemonDetail != nil {
            pokemonNumber.text = String(data.pokemonDetail!.baseExperience)
            if !data.pokemonDetail!.abilities.isEmpty {
                //let abilities  = ",".join( data.pokemonDetail!.abilities.map { toString($0.id) })
                
                tagsArray.removeAll()
                
                for ability in data.pokemonDetail!.abilities {
                    tagsArray.append(ability.ability.name)
                }
                
                DispatchQueue.main.async {
                    self.tagsCollectionView.reloadData()
                }
                
//                let joinedAbility = data.pokemonDetail!.abilities.compactMap{ $0.ability.name }.joined(separator: ",")
//                pokemonAbility.text = joinedAbility
            }
            
            pokemonImg.image = UIImage(named: "first.imageset")
            
            
            
//            let imageUrl = data.pokemonDetail!.sprites.frontShiny
            
            var imgArr: [UIImage] = [] // Creating an Array of Images to put sprites for Animation of Images
            
            if let img1 = data.pokemonDetail?.sprites.frontShiny { // Downloading the first Sprit
                if let url = URL(string: img1) {
                    getImageFromURL(url: url) { (image) in
                        imgArr.append(image)
                        
                        self.setAnimatedImageToImageView(arr: imgArr)
                    }
                }
            }
            
            if let img2 = data.pokemonDetail?.sprites.backShiny { // Downloading the Second Sprit
                if let url = URL(string: img2) {
                    getImageFromURL(url: url) { (image) in
                        imgArr.append(image)
                        
                        self.setAnimatedImageToImageView(arr: imgArr)
                    }
                }
            }
            
            
//            if imageUrl != nil && !imageUrl!.isEmpty {
//                pokemonImg.image = UIImage(named: "pokemon_ic")
//                //pokemonImg.downloadImageFrom(link: imageUrl!, contentMode: UIView.ContentMode.scaleAspectFit)
//
//                pokemonImg.loadImageUsingCacheWithUrlString(urlString: imageUrl!, imageKey: "\(data.name)_img") { (result) in
//                    switch result {
//                    case .failure(let error):
//                        print("Unable to Load LogoImageView", error)
//                    case .success(_):
//                        print("Logo Image Loaded Successfully")
////                        self.imgBGColor.backgroundColor = self.pokemonImg.image?.averageColor
//                        self.imgBGColor.backgroundColor = self.pokemonImg.image?.getPixelColor(pos: CGPoint(x: (self.pokemonImg.image?.size.width)! / 2, y: (self.pokemonImg.image?.size.height)! / 2))
//                        self.imgBGColor.alpha = 0.25
//                    }
//                }
//            }
        }
    }
}


// Getting a Color from the Image showing in the ImageView from a specific CGPoint.
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        
        let pixelData = self.cgImage!.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}



