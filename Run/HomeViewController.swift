import UIKit

final class HomeViewController: UIViewController {
    
    var ewr = ["27","26","25","24","23"]
    
    lazy var buttonBack: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self,
                         action: #selector(diss),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "nav_back_button"), for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "identifiier")
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    var dataSoure:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        view.backgroundColor = .white
        dataSoure = [User(steps: "\(HealthKitManager.shared.stepsToday) steps", kilo: "\(HealthKitManager.shared.km) m", kcal: "\(HealthKitManager.shared.activity) kcal", date: "27 May")]
    }
    
    private func setupUi(){
        self.view.addSubview(tableView)
        view.addSubview(buttonBack)
        
        NSLayoutConstraint.activate([
            
            buttonBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            buttonBack.widthAnchor.constraint(equalToConstant: 25),
            
            tableView.topAnchor.constraint(equalTo: buttonBack.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        let user = dataSoure[indexPath.row]
        cell.configCell(with: user)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    @objc func diss(){
        dismiss(animated: true)
    }
    
}
