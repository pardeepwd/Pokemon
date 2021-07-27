//
//  PokemonListExt.swift
//  Pokemon
//
//  Created by Simran Singh Sandhu on 23/07/21.
//

import UIKit

extension PokemonTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsColViewCell", for: indexPath) as! CustomTagColViewCell
        DispatchQueue.main.async {
            cell.tagName = self.tagsArray[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = tagsArray[indexPath.row]
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font: UIFont.init(name: "Montserrat-Regular", size: 9)!])
        return CGSize(width: itemSize.width + 20, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
