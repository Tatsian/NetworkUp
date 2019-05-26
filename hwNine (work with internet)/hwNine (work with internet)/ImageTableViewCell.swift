import UIKit

class ImageTableViewCell: UITableViewCell {
//7
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!

//20 создаем ф-ию для заполнения ячейки
    func setUpCell(imageInfo: ImageInfo) {
        myLabel.text = imageInfo.title
//24 вызываем ф-ию loadImage(url)
        loadImage(url: imageInfo.url)
    }

//23 создаем ф-ию для загрузки картинки по url
    func loadImage(url: URL) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            let image = UIImage.init(data: data) // преобразуем data в картинку
            
            DispatchQueue.main.async {
                self.myImageView.image = image //отобразила картинку на экран
            }
        }
        dataTask.resume() // нужно вызвать resume, чтобы загрузка началась, тк по умолчанию задачи на загрузку приостановлены
    }
}
