
import UIKit

class HourlyCell: UITableViewCell, NibCell, ConfigurableCell{
    @IBOutlet weak var collectionView: UICollectionView!

    var weathers: [List]?
    func config(for weathers: [List]) {
        self.selectionStyle = .none
        self.weathers = weathers
        
        collectionView.register(cell: HourlyCVCell.self)
        collectionView.dataSource = self
        
        let itemSize = CGSize(width: bounds.width * 0.3 - 11, height: bounds.height)
        collectionView.contentSize = CGSize(width: itemSize.width * 3, height: bounds.height)
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
    }
}

//MARK: - UICollectionViewDataSource
extension HourlyCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weathers?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let list = weathers?[indexPath.row] else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(ofType: HourlyCVCell.self, for: indexPath)
        cell.setup(withHour: list.dt_txt, image: list.weather.first!.icon, temp: "\(KelvinToCelsius.convert(list.main.temp))º")
        return cell
    }
}
