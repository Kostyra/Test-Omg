import UIKit

final class ViewController: UIViewController {
    private var data: [[Int]] = []
    private var timer: Timer?
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 3
        let numberOfItemsPerRow = CGFloat(Int.random(in: 10...15))
        let itemWidth = (view.bounds.width - (numberOfItemsPerRow + 1) * 3) / numberOfItemsPerRow
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SquareCell.self, forCellWithReuseIdentifier: SquareCell.id)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateRandomData()
        setup()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.reloadData()
        }
    }
    
    private func setup() {
        view.addSubview(collectionView)
    }
    
    private func generateRandomData() {
        for _ in 0..<Int.random(in: 100...200) {
            var row: [Int] = []
            for _ in 0..<Int.random(in: 10...20) {
                row.append(Int.random(in: 1...100))
            }
            data.append(row)
        }
    }
    
    private func reloadData() {
        let visibleSections = Set(collectionView.indexPathsForVisibleItems.map { $0.section })
        for section in visibleSections {
            let randomRow = Int.random(in: 0..<data[section].count)
            data[section][randomRow] = Int.random(in: 1...100)
            let indexPath = IndexPath(row: randomRow, section: section)
            if let cell = collectionView.cellForItem(at: indexPath) as? SquareCell {
                cell.config(number: data[section][randomRow])
            }
        }
    }
}
    
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SquareCell.id, for: indexPath) as? SquareCell else { return UICollectionViewCell() }
        cell.config(number: data[indexPath.section][indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateVisibleCells()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            updateVisibleCells()
        }
    }
    
    func updateVisibleCells() {
        let visibleIndexPaths = collectionView.indexPathsForVisibleItems

        for indexPath in visibleIndexPaths {
            if let cell = collectionView.cellForItem(at: indexPath) as? SquareCell {
                cell.config(number: data[indexPath.section][indexPath.row])
            }
        }
    }
}

