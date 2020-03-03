import UIKit

enum CollectionCustomNewsSize {
    case oneBigCell
    case oneWideCell
    case cellInFirstRow
    case cellInSecondRow
    case cellInThirdRow
    case nillCell
}

class CustomNewsCollectionLayout: UICollectionViewLayout {
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]() //хранит информацию по текущей ячейке
    var rowOne = 2 //количество ячеек в "первой" линии
    var rowTwo = 2 //количество ячеек во "второй" линии
    var rowThree = 2 //количество ячеек в "третей" линии
    var cellHeight: CGFloat = 100 //задаем дефолтную высоту ячеек
    var containerHeight: CGFloat = 0 //переменная для подсчета общей высоты контента в View
    
    override func prepare() {
        guard let collection = collectionView else { return }
        let cellsCount = collection.numberOfItems(inSection: 0) //высчитывает суммарное количество ячеек внутри коллекции
        guard cellsCount > 0 else { return } //проверяем наличие хотя бы одной ячейки
        
        let commonWidth = collection.frame.width //задаем ширину для "широкой" ячейки
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        for cell in 0..<cellsCount {
            let indexPath = IndexPath(item: cell, section: 0)
            let attributeForIndex = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            var cellDisplayLine: CollectionCustomNewsSize = .oneBigCell   //задаем дефорлтное значение
            
            //царь портянка, делаем разное отображение коллекции при разных значениях itemsCount (<= 10)
            if cellsCount == 1 {
                cellDisplayLine = .oneBigCell
                cellHeight = commonWidth
            } else if cellsCount == 2 {
                cellDisplayLine = .oneWideCell
                cellHeight = commonWidth / CGFloat(2)
            } else if cellsCount == 3 {
                rowOne = 2
                cellHeight = commonWidth / CGFloat(2)
                cellDisplayLine = (cell + 1) % (rowOne + 1) != 0 ? .cellInFirstRow : .oneWideCell
            } else if cellsCount == 4 {
                rowOne = 3
                cellHeight = commonWidth / CGFloat(2)
                cellDisplayLine = (cell + 1) % (rowOne + 1) != 0 ? .cellInFirstRow : .oneWideCell
            } else if cellsCount == 5 {
                rowOne = 3
                rowTwo = 2
                cellHeight = commonWidth / CGFloat(2)
                cellDisplayLine = cell > 2 ? .cellInSecondRow : .cellInFirstRow
            } else if cellsCount == 6 {
                rowOne = 3
                rowTwo = 3
                cellHeight = commonWidth / CGFloat(2)
                cellDisplayLine = cell > 2 ? .cellInSecondRow : .cellInFirstRow
            } else if cellsCount == 7 {
                rowOne = 2
                rowTwo = 3
                rowThree = 2
                cellHeight = commonWidth / CGFloat(3)
                if cell < 2 {
                    cellDisplayLine = .cellInFirstRow
                } else if cell < 5 {
                    cellDisplayLine = .cellInSecondRow
                } else {
                    cellDisplayLine = .cellInThirdRow
                }
            } else if cellsCount == 8 {
                rowOne = 3
                rowTwo = 2
                rowThree = 3
                cellHeight = commonWidth / CGFloat(3)
                if cell < 3 {
                    cellDisplayLine = .cellInFirstRow
                } else if cell < 5 {
                    cellDisplayLine = .cellInSecondRow
                } else {
                    cellDisplayLine = .cellInThirdRow
                }
            } else if cellsCount == 9 {
                rowOne = 2
                rowTwo = 3
                rowThree = 4
                cellHeight = commonWidth / CGFloat(3)
                if cell < 2 {
                    cellDisplayLine = .cellInFirstRow
                } else if cell < 5 {
                    cellDisplayLine = .cellInSecondRow
                } else {
                    cellDisplayLine = .cellInThirdRow
                }
            } else if cellsCount == 10 {
                rowOne = 3
                rowTwo = 4
                rowThree = 3
                cellHeight = commonWidth / CGFloat(3)
                if cell < 3 {
                    cellDisplayLine = .cellInFirstRow
                } else if cell < 7 {
                    cellDisplayLine = .cellInSecondRow
                } else {
                    cellDisplayLine = .cellInThirdRow
                }
            } else if cellsCount > 10 {
                rowOne = 3
                rowTwo = 4
                rowThree = 3
                cellHeight = commonWidth / CGFloat(3)
                if cell < 3 {
                    cellDisplayLine = .cellInFirstRow
                } else if cell < 7 {
                    cellDisplayLine = .cellInSecondRow
                } else if cell < 11 {
                    cellDisplayLine = .cellInThirdRow
                }
            } else {
                cellDisplayLine = .nillCell
            }
            
            //расчитываем ширину ячеек для каждой линии
            let smallOneWidth = collection.frame.width / CGFloat(rowOne)
            let smallTwoWidth = collection.frame.width / CGFloat(rowTwo)
            let smallThreeWidth = collection.frame.width / CGFloat(rowThree)
            
            switch cellDisplayLine {
                
            case .oneBigCell:
                //рендерим одну большую ячейку, с высотой равной ширине ячейки
                attributeForIndex.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: commonWidth, height: cellHeight)
                y += cellHeight
                
            case .oneWideCell:
                //рендерим одну широкую ячейку
                attributeForIndex.frame = CGRect(x: CGFloat(0), y: y, width: commonWidth, height: cellHeight)
                y += cellHeight
                
            case .cellInFirstRow:
                //рендерим ячейки для первой линии
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallOneWidth, height: CGFloat(cellHeight))
                
                if (cell + 2) % (rowOne + 1) == 0 || cell == cellsCount - 1 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else {
                    x += smallOneWidth
                }
                
            case .cellInSecondRow:
                //рендерим ячейки для второй линии
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallTwoWidth, height: CGFloat(cellHeight))
                
                if (cell - rowOne + 2) % (rowTwo + 1) == 0 || cell == cellsCount - 1 {
                    y += CGFloat(cellHeight)
                    x = CGFloat(0)
                } else {
                    x += smallTwoWidth
                }
                
            case .cellInThirdRow:
                //рендерим ячейки для третьей линии
                attributeForIndex.frame = CGRect(x: x, y: y, width: smallThreeWidth, height: CGFloat(cellHeight))
                
                if (cell - rowOne - rowTwo + 2) % (rowThree + 1) == 0 || cell == cellsCount - 1 {
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
