//
//  ListVC.swift
//  APIManager
//
//  Created by Amey Dalvi on 22/04/24.
//

import UIKit
class ListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var data: [User] = []
    private let completion: (_ name: String?,_ dict: [String:Any]?) -> Void
    var count = 1
    private var selectedUser: User?
    
    init(completion: @escaping (_ name: String?,_ dict: [String:Any]?) -> Void) {
        self.completion = completion
        super.init(nibName: "ListVC", bundle: Bundle(for: ListVC.self))
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        
    }
    
    private func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "UserCell", bundle: Bundle(for: ListVC.self)), forCellReuseIdentifier: "UserCell")
        self.data.removeAll()

        
        APIManagerService.fetchUserEmails(count: count) { isSuccess, userList, page  in
            if isSuccess{
                if self.count != page || page == 0
                {
                    print("reached end")
                }else{
                    self.count = self.count + 1
                    self.data.append(contentsOf: userList ?? [User]())
                    self.tableView.reloadData()
                }
                
            }
            else
            {
                print("unbable to get users")
            }
            
        }
    }
    
    @IBAction func onDoneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self  else { return }
            if self.selectedUser != nil {
                let name = "\(self.selectedUser?.firstName ?? "") \(self.selectedUser?.lastName ?? "")"
                self.completion(name, self.selectedUser?.toDict())
            }
        }
       
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Count -- \( self.data.count)")
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = self.data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        cell.selectionStyle = .none
        cell.lblUserName.text = "\(data.firstName ?? "") \(data.lastName ?? "")"
        if data.id == self.selectedUser?.id{
            cell.cardView.backgroundColor = .blue.withAlphaComponent(0.1)
            cell.lblUserName.textColor = .white
        }
        else
        {
            cell.cardView.backgroundColor = .white
            cell.lblUserName.textColor = .black
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let firstUser = self.data[indexPath.row]
        self.selectedUser = firstUser
        self.tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        
        if distanceFromBottom < height{
            APIManagerService.fetchUserEmails(count: count) { isSuccess, userList, page  in
                if isSuccess{
                    if self.count != page || page == 0
                    {
                        print("reached end")
                    }else{
                        self.count = self.count + 1
                        self.data.append(contentsOf: userList ?? [User]())
                        self.tableView.reloadData()
                    }
                    
                }
                else
                {
                    print("unbable to get users")
                }
                
            }
        }
    }
    
}
