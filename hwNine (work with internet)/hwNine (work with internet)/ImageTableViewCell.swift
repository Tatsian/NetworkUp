import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!

//20
    func setUpCell(imageInfo: ImageInfo) {
        myLabel.text = imageInfo.title
        //24
        loadImage(url: imageInfo.url)
        
    }

//23
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
