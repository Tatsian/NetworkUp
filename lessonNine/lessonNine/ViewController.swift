
import UIKit

struct User: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

class ViewController: UIViewController {

    @IBOutlet weak var textLabal: UILabel!
    let urlString = "https://jsonplaceholder.typicode.com/todos/4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func actionButton(_ sender: Any) {
        let url = URL(string: urlString)
        let downloadTask = URLSession.shared.downloadTask(with: url!) { (url, response, error) in
            
//            print("URL: \(url)") //место куда загрузился файл
//            print("response: \(response)") //объект кот сод метаданные ответа
//            print("error: \(error)") //ошибка кот произошла или нет
        }
        downloadTask.resume()
        
        let dataTask = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            let user = try! JSONDecoder().decode(User.self, from: data!) //парсим данные с помощью decodable
            let dictionaty = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:AnyObject] //парсим данные в словарь (старый способ)
            let title = dictionaty["title"]
            print("Data: \(data)")
            print(String(data: data!, encoding: .utf8))
            
            DispatchQueue.main.async {
                self.updateUser(user: user)
            }
        }
        dataTask.resume()
        
    }
    
    func updateUser(user: User) {
        textLabal.text = user.title
        
        if user.completed {
            textLabal.textColor = .green
        } else {
            textLabal.textColor = .red
        }
        
        
    }
    
    

}

