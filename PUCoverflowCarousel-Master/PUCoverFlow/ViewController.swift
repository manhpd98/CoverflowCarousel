//
//  ViewController.swift
//  PUCoverFlow
//
//  Created by Payal Umraliya on 29/12/22.
//
import UIKit
import SDWebImage

class Character {
    let imageName: String
    let name: String
    let likecount: String
    let commentcount: String
    let title: String
    let subtitle: String
    let tag: String
    
    init(imageName: String, name: String, likecount: String, commentcount: String, title: String, subtitle: String, tag: String) {
        self.imageName = imageName
        self.name = name
        self.likecount = likecount
        self.commentcount = commentcount
        self.title = title
        self.subtitle = subtitle
        self.tag = tag
    }
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    private var items = [
        Character(imageName: "https://picsum.photos/id/11/2500/1667", name: "fishes", likecount: "20",commentcount:"10",title: "1.Five tips for a low-carb diet",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Physical wellbeing"),
        Character(imageName: "https://picsum.photos/id/5/5000/3334", name: "fishes", likecount: "30",commentcount:"13",title: "2.Meditation techniques for beginner",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Active days at home"),
        Character(imageName: "https://picsum.photos/id/6/5000/3333", name: "fishes", likecount: "210",commentcount:"60",title: "3.Stay fit, run 5k daily",subtitle: "your first time using Carthage in the project, you'll need to go through some additional steps as explained", tag: "Runners"),
        Character(imageName: "https://picsum.photos/id/7/4728/3168", name: "fishes", likecount: "740",commentcount:"68",title: "4.Travel together and healthy fitness",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Travelling"),
        Character(imageName: "https://picsum.photos/id/8/5000/3333", name: "fishes", likecount: "20",commentcount:"150",title: "5.Food choices makes difference in live",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Exercising"),
        Character(imageName: "https://picsum.photos/id/9/5000/3269", name: "fishes", likecount: "12",commentcount:"6",title: "6.Attempot to recover constarinta of your body",subtitle: "It’s important to take breaks for mental health.The Pomodoro Technique is a time management system that encourages people",tag: "Consultations")
    ]
    fileprivate var currentPage: Int = 0
    
    fileprivate var pageSize: CGSize {
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        var pageSize = layout.itemSize
        if layout.scrollDirection == .horizontal {
            pageSize.width += layout.minimumLineSpacing
        } else {
            pageSize.height += layout.minimumLineSpacing
        }
        print("Page : \(pageSize)")
        return pageSize
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(UINib(nibName: "CarouselCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CarouselCollectionViewCell")
        self.setupLayout()
        self.loadDataAtCenter()
    }
    
    func loadDataAtCenter() {
        self.currentPage = 0
        self.collectionView.reloadData()
        let indexPath = IndexPath(item: self.currentPage, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }

    fileprivate func setupLayout() {
        self.collectionView.backgroundColor = UIColor.clear
        
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: self.collectionView.frame.size.width - 80,
                                 height: self.collectionView.frame.size.height)
        layout.spacingMode = PUCoverFlowLayoutSpacingMode.overlap(visibleOffset: 40)
        layout.sideItemScale = 0.8
    }

    // MARK: - Card Collection Delegate & DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselCollectionViewCell", for: indexPath) as! CarouselCollectionViewCell
        cell.image.layer.masksToBounds = true
        cell.image.layer.cornerRadius = 10
        cell.image.clipsToBounds = true
        let character = items[indexPath.row % items.count ]
        if character.imageName != "" {
            cell.image.sd_setImage(with: URL(string: character.imageName),
                                   placeholderImage: UIImage(named: character.name), context: .none)
            cell.image.backgroundColor = UIColor.clear
        } else {
            cell.image.image = nil
            cell.image.backgroundColor = UIColor.gray
        }
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0, options: [], animations: {
            cell.layoutIfNeeded()
        })
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let layout = self.collectionView.collectionViewLayout as! PUCoverFlowLayout
        let pageSide = (layout.scrollDirection == .horizontal) ? self.pageSize.width : self.pageSize.height
        let offset = (layout.scrollDirection == .horizontal) ? scrollView.contentOffset.x : scrollView.contentOffset.y
        currentPage = Int(floor((offset - pageSide / 2) / pageSide) + 1)
    }
}
