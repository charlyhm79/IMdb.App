//
//  IMListMoviesViewController.swift
//  IMdb
//
//  Created by cice on 5/5/17.
//  Copyright © 2017 formador. All rights reserved.
//

import UIKit

import Kingfisher


class IMListMoviesViewController: UIViewController {
    
    //MARK VARIABLES LOCALES
    
    
    var movies = [MovieModel]()
    var collectionPadding : CGFloat = 0
    let customrefresh = UIRefreshControl ()
    let dataProvider = LocalCoreDataService()
    
    var tapGR : UITapGestureRecognizer!
    
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK IBOUTLETS
    
    
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        customrefresh.addTarget(self,
                                action: #selector(loadData),
                                for: .valueChanged)
        myCollectionView.refreshControl?.tintColor = UIColor.white
        myCollectionView.refreshControl = customrefresh
        
        tapGR = UITapGestureRecognizer(target: self,
                                       action: #selector(hideKeyboard))
        
        loadData()
        
        setupPadding()
        
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        mySearchBar.delegate = self
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK UTILS
    
    func loadData(){
        dataProvider.topMovie({ (localResult) in
            if let movieData = localResult{
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                }
            }else{
                print("No hay registros en CoreData")
            }
            
        }) {(remoteResult) in
            if let movieData = remoteResult{
                self.movies = movieData
                DispatchQueue.main.async {
                    self.myCollectionView.reloadData()
                    self.customrefresh.endRefreshing()
                }
            }
            
        }
    }
    
    
    
    
    
    
    
    
    func hideKeyboard(){
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}//FIN DE LA CLASE


//EXTENSION DE COLLECTION DELEGATE

extension IMListMoviesViewController : UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    
    func setupPadding(){
        let anchoPantalla = self.view.frame.width
        collectionPadding = (anchoPantalla - (3*113)) / 4
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: collectionPadding,
                            left: collectionPadding,
                            bottom: collectionPadding,
                            right: collectionPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionPadding
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! IMDetailCustomCell
        let model = movies[indexPath.row]
        configuredCell(cell, withMovie: model)
        
        return cell
    }
    
    
    func configuredCell ( _ cell : IMDetailCustomCell,withMovie movie : MovieModel){
        if let imageData = movie.image{
            if imageData != ""{
                cell.myImageMovie.kf.setImage(with: ImageResource(downloadURL :URL(string: imageData)!),
                                              placeholder: #imageLiteral(resourceName: "img-loading"),
                                              options: nil,
                                              progressBlock: nil,
                                              completionHandler: nil)
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 113, height: 175)
        
    }
    
    
    
    
    
    
    
}











