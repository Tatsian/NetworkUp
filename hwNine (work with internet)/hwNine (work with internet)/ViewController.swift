import UIKit

//14 создаем структуру для данных
struct ImageInfo {
    let url: URL
    let title: String
}

class ViewController: UIViewController {
//17
    @IBOutlet weak var myTable: UITableView!
    
//8 создаем переменную с адресом сайта
    let urlString = "http://www.raywenderlich.com/downloads/ClassicPhotosDictionary.plist" //url по которому будем делать запрос
    
//15 создаем массив эллементов ImageInfo
    var imageInfoArray: [ImageInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadData()
    }
    
//10 загружаем данные в оперативную память (func downloadData)
    func downloadData() {
        guard let url = URL(string: urlString) else { return }  //получаем url
       
//11 создаем переменную для загрузки данных
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
      //      print("URL: \(url)") //место куда загрузился файл
      //      print("response: \(response)") //объект кот сод метаданные ответа
      //      print("error: \(error)") //ошибка кот произошла или нет
            
//13 вызываем метод parse(data)
            guard let data = data else { return } //разворачиваем значение data, чтобы не использовать опциональное значение
            self.parse(data: data)
            
//22 перезагружаем таблицу в главном потоке, чтобы она подтянула данные из массива
            DispatchQueue.main.async {
                 self.myTable.reloadData()
            }
        }
        dataTask.resume() // нужно вызвать resume, чтобы загрузка началась, тк по умолчанию задачи на загрузку приостановлены
    }

//12 парсим данные (func parse)
    func parse(data: Data) {
        do {
            let animalsDictionary = try PropertyListDecoder().decode(Dictionary<String, String>.self, from: data) //парсим данные с помощью PropertyListDecoder в структуру Dictionary
            
//16 преобразовываем словарь в массив
            for (key, value) in animalsDictionary {
                guard let url = URL(string: value) else { continue } // не return, тк return возвращается к вызову функции. Инструкция continue заканчивает выполнение программы текущей итерации инструкции цикла, но не останавливает выполнение инструкции цикла
                let imageInfo = ImageInfo(url: url, title: key)
                imageInfoArray.append(imageInfo)
            }
            
        } catch let error {
            print("there is an error: \(error)")
        }
      // do- catch для отлавливания ошибок
    }
}
//19 extension для таблицы
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return imageInfoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell", for: indexPath) as? ImageTableViewCell else { return UITableViewCell()} //выгружаем переиспользованную ячейку, преобразуем ее тип в целевой тип (ImageTableViewCell), чтобы заполнить ее данными
        
 //21 заполняем ячейку данными из массива
        cell.setUpCell(imageInfo: imageInfoArray[indexPath.row])
        return cell
        
    }
}
