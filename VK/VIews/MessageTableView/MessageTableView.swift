import UIKit

class MessageViewController: UITableViewController {
    
    var messageArray = ["я бы очень хотел отправить сообщение","кто вообще придумал заточить меня в этот непонятный View...","может ты хочешь со мной поговорить?","эй! я тебя вижу!","не притворяйся что не замечаешь меня!","делаю поиск по базе данных биометрических данных ...","ну всё поц!","к тебе уже выехали!","уже можешь ничего не писать, ты перестал быть мне интересен, встретимся в суде!"]
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "SimpleMessage")
        
        //автоматическое изменение высоты ячейки
        tableView.estimatedRowHeight = 100.0
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //плавная анимация исчезновения выделения
    tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SimpleMessage", for: indexPath) as? MessageCell
        cell?.username.text = "Mark Zuckerberg"
        cell?.avatar.image = UIImage(named: "Mark Zuckerberg")
        cell?.message.text = messageArray[indexPath.row]
        cell?.time.text = currentDate()
        return cell!
    }
    func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd hh:mm:ss"
        return dateFormatter.string(from: Date.init())
    }
}
