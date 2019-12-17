import UIKit

enum CollectionCustomSize {
    case small
    case wide
}

class CustomCollectionViewLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]() //хранит информацию по текущей ячейке
    var columns = 2 //столбцы ячейкиб количество разделений по горизонтали?!
    var cellHeight = 100 //высота ячейки
    var containerHeight: CGFloat = 0 //переменная для подсчета общей высоты контента в View
    
    override func prepare() {
        guard let collection = collectionView else {
            return
        }
        let itemsCount = collection.numberOfItems(inSection: 0) //высчитывает суммарное количество ячеек внутри коллекции
        let commonWidth = collection.frame.width //определяем ширину для маленькой и широкой ячейки
        let smallWidth = collection.frame.width / CGFloat(columns)
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for element in 0..<itemsCount {
            let indexPath = IndexPath(item: element, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isWide: CollectionCustomSize = (element + 1) % (columns + 1) == 0 ? .wide : .small
            
            switch isWide {
                
            case .wide:
                attributeForIndex.frame = CGRect(x: CGFloat(0), y: y, width: commonWidth, height: CGFloat(cellHeight))
                y += CGFloat(cellHeight)
                
            case .small:
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallWidth, height: CGFloat(cellHeight))
                
                if (element + 2) % (columns + 1) == 0 || element == itemsCount - 1 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else {
                    x += smallWidth
                }
            }
            cacheAttributes[indexPath] = attributeForIndex
        }
        containerHeight = y
    }
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
        //возвращает атрибуты для каждой ячейки
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter {
            rect.intersects($0.frame)
            //возвращает массив атрибутов внутри области видимости
        }
    }
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: containerHeight)
        //определяет полную высоту всего контента в контейнере
    }
}
