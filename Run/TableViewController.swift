import UIKit
import HealthKit
 class TableViewController: UIViewController {

    var ss = DataForSevenDay.shared
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .white
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        view.addSubview(buttonBack)
        
        NSLayoutConstraint.activate([
            
            buttonBack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            buttonBack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,constant: 16),
            buttonBack.widthAnchor.constraint(equalToConstant: 25),
            
            tableView.topAnchor.constraint(equalTo: buttonBack.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension TableViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ss.steps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as! UserTableViewCell
        cell.configure(with: ss.steps.reversed()[indexPath.row], date: ss.datee.reversed()[indexPath.row],kcal: ss.kcal.reversed()[indexPath.row], meter: ss.meter.reversed()[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    @objc func diss(){
        dismiss(animated: true)
    }
    
}
