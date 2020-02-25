import UIKit

enum CollectionCustomNewsSize {
    case bigOne
    case wideOne
    case smallOne
    case smallTwo
    case smallThree
    case nillCell
}

class CustomNewsCollectionLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]() //хранит информацию по текущей ячейке
    var columnsOne = 2 //количество ячеек в "первой" линии
    var columnsTwo = 2 //количество ячеек во "второй" линии
    var columnsThree = 2 //количество ячеек в "третей" линии
    var cellHeight: CGFloat = 100 //задаем дефолтную высоту ячеек
    var containerHeight: CGFloat = 0 //переменная для подсчета общей высоты контента в View
    
    override func prepare() {
        guard let collection = collectionView else { return }
        let itemsCount = collection.numberOfItems(inSection: 0) //высчитывает суммарное количество ячеек внутри коллекции
        guard itemsCount > 0 else { return } //проверяем наличие хотя бы одной ячейки
        
        let commonWidth = collection.frame.width //задаем ширину для "широкой" ячейки
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for element in 0..<itemsCount {
            let indexPath = IndexPath(item: element, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            var isWide: CollectionCustomNewsSize = .bigOne   //задаем дефорлтное значение
            
            //царь портянка, делаем разное отображение коллекции при разных значениях itemsCount (<= 10)
            if itemsCount == 1 {
                isWide = .bigOne
                cellHeight = commonWidth
            } else if itemsCount == 2 {
                isWide = .wideOne
                cellHeight = commonWidth / CGFloat(2)
            } else if itemsCount == 3 {
                columnsOne = 2
                cellHeight = commonWidth / CGFloat(2)
                isWide = (element + 1) % (columnsOne + 1) != 0 ? .smallOne : .wideOne
            } else if itemsCount == 4 {
                columnsOne = 3
                cellHeight = commonWidth / CGFloat(2)
                isWide = (element + 1) % (columnsOne + 1) != 0 ? .smallOne : .wideOne
            } else if itemsCount == 5 {
                columnsOne = 3
                columnsTwo = 2
                cellHeight = commonWidth / CGFloat(2)
                isWide = element > 2 ? .smallTwo : .smallOne
            } else if itemsCount == 6 {
                columnsOne = 3
                columnsTwo = 3
                cellHeight = commonWidth / CGFloat(2)
                isWide = element > 2 ? .smallTwo : .smallOne
            } else if itemsCount == 7 {
                columnsOne = 2
                columnsTwo = 3
                columnsThree = 2
                cellHeight = commonWidth / CGFloat(3)
                if element < 2 {
                    isWide = .smallOne
                } else if element < 5 {
                    isWide = .smallTwo
                } else {
                    isWide = .smallThree
                }
            } else if itemsCount == 8 {
                columnsOne = 3
                columnsTwo = 2
                columnsThree = 3
                cellHeight = commonWidth / CGFloat(3)
                if element < 3 {
                    isWide = .smallOne
                } else if element < 5 {
                    isWide = .smallTwo
                } else {
                    isWide = .smallThree
                }
            } else if itemsCount == 9 {
                columnsOne = 2
                columnsTwo = 3
                columnsThree = 4
                cellHeight = commonWidth / CGFloat(3)
                if element < 2 {
                    isWide = .smallOne
                } else if element < 5 {
                    isWide = .smallTwo
                } else {
                    isWide = .smallThree
                }
            } else if itemsCount == 10 {
                columnsOne = 3
                columnsTwo = 4
                columnsThree = 3
                cellHeight = commonWidth / CGFloat(3)
                if element < 3 {
                    isWide = .smallOne
                } else if element < 7 {
                    isWide = .smallTwo
                } else {
                    isWide = .smallThree
                }
            } else if itemsCount > 10 {
                columnsOne = 3
                columnsTwo = 4
                columnsThree = 3
                cellHeight = commonWidth / CGFloat(3)
                if element < 3 {
                    isWide = .smallOne
                } else if element < 7 {
                    isWide = .smallTwo
                } else if element < 11 {
                    isWide = .smallThree
                }
            } else {
                isWide = .nillCell
            }
            
            //расчитываем ширину ячеек для каждой линии
            let smallOneWidth = collection.frame.width / CGFloat(columnsOne)
            let smallTwoWidth = collection.frame.width / CGFloat(columnsTwo)
            let smallThreeWidth = collection.frame.width / CGFloat(columnsThree)
            
            switch isWide {
                
            case .bigOne:
                //рендерим одну большую ячейку, с высотой равной ширине ячейки
                attributeForIndex.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: commonWidth, height: cellHeight)
                y += cellHeight
                
            case .wideOne:
                //рендерим одну широкую ячейку
                attributeForIndex.frame = CGRect(x: CGFloat(0), y: y, width: commonWidth, height: cellHeight)
                y += cellHeight
                
            case .smallOne:
                //рендерим ячейки для первой линии
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallOneWidth, height: CGFloat(cellHeight))
                
                if (element + 2) % (columnsOne + 1) == 0 || element == itemsCount - 1 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else {
                    x += smallOneWidth
                }
                
            case .smallTwo:
                //рендерим ячейки для второй линии
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallTwoWidth, height: CGFloat(cellHeight))
                
                if (element - columnsOne + 2) % (columnsTwo + 1) == 0 || element == itemsCount - 1 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else {
                    x += smallTwoWidth
                }
                
            case .smallThree:
                //рендерим ячейки для третьей линии
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallThreeWidth, height: CGFloat(cellHeight))
                
                if (element - columnsOne - columnsTwo + 2) % (columnsThree + 1) == 0 || element == itemsCount - 1 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else {
                    x += smallThreeWidth
                }
                
            case .nillCell:   //ограничили отображение максимум 10 изображениями
                break
            }
            cacheAttributes[indexPath] = attributeForIndex
        }
        //"y" поидее у нас всегда равен ширине контейнера
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
