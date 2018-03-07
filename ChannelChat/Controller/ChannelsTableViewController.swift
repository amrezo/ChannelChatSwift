//
//  ChannelsTableViewController.swift
//  ChannelChat
//
//  Created by Amr Al-Refae on 3/5/18.
//  Copyright © 2018 Amr Al-Refae. All rights reserved.
//

import UIKit
import Firebase


class ChannelsTableViewController: UITableViewController {
    
    // MARK: Properties
    public var senderDisplayName: String?
    var newChannelTextField: UITextField?
    var channels: [Channel] = []
    
    var channelRef: DatabaseReference = Database.database().reference().child("channels")
    var channelRefHandle: DatabaseHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeChannels()
        
        refreshControl?.addTarget(self, action: #selector(refreshChannelList), for: .valueChanged)


    }
    
    deinit {
        if let refHandle = channelRefHandle {
            channelRef.removeObserver(withHandle: refHandle)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if channels.count == 0 {
            
            // Placeholder creation, displayed when the tableView is empty
            let placeholderTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
            placeholderTitle.font = UIFont(name: "Avenir Next", size: CGFloat(integerLiteral: 27))
            placeholderTitle.numberOfLines = 3
            placeholderTitle.textColor = .black
            placeholderTitle.center = CGPoint(x: 160, y: 284)
            placeholderTitle.textAlignment = .center
            placeholderTitle.text = "There are currently no channels.😞\nAdd one now!"
            
            // Remove separation line in tableView and add placeholder to its backgroundView
            tableView.separatorStyle = .none
            tableView.backgroundView = placeholderTitle
            
        } else {
            
            // Reset tableView to original settings and remove separatipn line in empty cells
            tableView.backgroundView = UIView()
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .singleLine
        }
        
        //Number of sections in this channel list
        return 1

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channels.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        let indexPath = self.tableView.indexPathForSelectedRow!
        let channel = channels[indexPath.row]
        
        let chatVC = segue.destination as! ChatViewController
        chatVC.senderDisplayName = senderDisplayName
        chatVC.channel = channel
        chatVC.channelRef = channelRef.child(channel.id)

        
        
    }

    @IBAction func addChannel(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add a channel", message: "Enter the channel name:", preferredStyle: .alert)
        alert.addTextField { (channelNameField) in
            self.newChannelTextField = channelNameField
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (cancelAction) in }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (addAction) in
            if let name = self.newChannelTextField?.text {
                let newChannelRef = self.channelRef.childByAutoId()
                let channelItem = ["name": name]
                newChannelRef.setValue(channelItem)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell", for: indexPath)
        
        cell.textLabel?.text = channels[indexPath.row].name
        
        return cell
    }
    
    
    func observeChannels() {
        
        channelRefHandle = channelRef.observe(.childAdded, with: { (snapshot) -> Void in
            let channelData = snapshot.value as! Dictionary<String, AnyObject>
            let id = snapshot.key
            
            if let name = channelData["name"] as! String!, name.count > 0 {
                self.channels.append(Channel(id: id, name: name))
                self.tableView.reloadData()
            } else {
                print("Error! Could not decode channel data.")
            }
        })
    }
    
    @objc func refreshChannelList() {
        self.tableView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.refreshControl?.endRefreshing()
        })

    }
    

}
