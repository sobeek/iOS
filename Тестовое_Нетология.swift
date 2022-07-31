import UIKit
import PromiseKit
import NetworkLayer

final class PMNotificationsListViewController: PMViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noNotificationsLabel: UILabel!
    
    var viewModel: PMNotificationsListViewModel = PMNotificationsListViewModel()
    private var paginatorController: PMNotificationsPaginationController = PMNotificationsPaginationController()
    private var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchDataIfNeeded()
    }
    
    private func configure() {
        navigationController?.navigationBar.clipsToBounds = true
        extendedLayoutIncludesOpaqueBars = true
        navigationController?.navigationBar.isTranslucent = false
        
        noNotificationsLabel.text = R.string.all.lblNoNotifications()
        noNotificationsLabel.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: R.nib.ukNotificationCell.name, bundle: nil), forCellReuseIdentifier: R.reuseIdentifier.notificationCell.identifier)
        tableView.register(UINib(nibName: "UITableViewCell", bundle: nil), forCellReuseIdentifier: "UITableViewCell")
        
        title = "Notifications"
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.tintColor = UIColor.gray
    }
    
    private func fetchData() {
        noNotificationsLabel.isHidden = true
        paginatorController.loadData(pageSize: 15, tableView: tableView, refreshControl: refreshControl, viewController: self, updateHandler: { cellItems in
                self.noNotificationsLabel.isHidden = cellItems.count > 0
            })
    }
    
    private func fetchDataIfNeeded() {
        let isNewNotificationReceived = PMStaticDataStore.shared().needToUpdateNotificationList
        let isLoaded = viewModel.isLoaded
        if !isLoaded || isNewNotificationReceived {
            fetchData()
            viewModel.isLoaded = true
            PMStaticDataStore.shared().needToUpdateNotificationList = false
        }
    }
    
    private func getOrderDetailsPage(_ orderId: String?, _ notificationId: String?, completion: ((_: String) -> ())? = nil) {
        guard let id = orderId, let notificationId = notificationId else { return }
        
        let requestModel = UKMarkNotificationsAsReadRequestModel.init(notifications: [notificationId])
        let worker = WorkersFabric.shared().getWorkers().notificationsWorker()
        worker.markNotificationsAsRead(requestModel: requestModel).done { responseModel in
            if let unread = responseModel.data?.unread {
                PMStaticDataStore.shared().notificationsCount = "\(unread)"
            }
            if let completion = completion {
                completion(id)
            }
            }.catch { error in
                UKAlertHelper.showAlertWithOkButton(title: R.string.all.lblErrorTitle(), msg: error.localizedDescription, fromViewController: self)
        }
    }
    
    @objc func refreshData() {
        paginatorController.reloadData()
    }
}

extension PMNotificationsListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paginatorController.paginator?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.notificationCell.identifier, for: indexPath) as? UKNotificationCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
            return cell
        }
        if let item = paginatorController.paginator?.results[indexPath.row] {
            
            cell.configure(with: item)
        }
        return cell
    }
}

extension PMNotificationsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = paginatorController.paginator?.results[indexPath.row]
        item?.read = true
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
        getOrderDetailsPage(item?.entityId, item?.identifier) { [weak self] orderId in
            let orderDetailsViewModel = PMOrderDetailsViewModel.init(orderId: orderId)
            let vc = PMOrderDetailsViewController.init(viewModel: orderDetailsViewModel)
            vc.presentedByNotification = true
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // fetch new page if there are 5 or less cells left to display; also mark visible cells as read
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let paginator = paginatorController.paginator else { return }
        let totalCount = paginator.results.count
        if indexPath.row == totalCount - 5 {
            paginatorController.paginator?.fetchNextPage()
        }
    }
}
