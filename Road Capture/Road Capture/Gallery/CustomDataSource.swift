//
//  CustomDataSource.swift
//  Road Capture
//
//  Created by Aaron Sletten on 3/23/19.
//  Copyright © 2019 Aaron Sletten. All rights reserved.
//

import UIKit
import CoreData

class CustomDataSource: NSObject, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>!
    var collectionView : UICollectionView!

    init(collectionView : UICollectionView){
        super.init()
        self.collectionView = collectionView
        initializeFetchedResultsController()
    }

    //Data Source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections!.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell

        // Set up the cell
        guard let object = self.fetchedResultsController?.object(at: indexPath) as? ImageCapture else {
            fatalError("Attempt to configure cell without a managed object")
        }
        //Populate the cell from the object
        cell.imageView.image = StoreImagesHelper.loadImage(imageNameWithExtention: "\(object.id)_thumbnail.jpg")

        return cell
    }

    func initializeFetchedResultsController() {
        let request = NSFetchRequest<ImageCapture>(entityName: "ImageCapture")
        let dateSort = NSSortDescriptor(key: "id", ascending: false)
        request.sortDescriptors = [dateSort]

        //get app delegate
        let appDelegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
        //get context
        let context = appDelegate.persistentContainer.viewContext

        fetchedResultsController = (NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<NSFetchRequestResult>)
        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }


//    //NSFetchedResultsControllerDelegate
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        collectionView.performBatchUpdates()
//    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            collectionView.insertSections(IndexSet(integer: sectionIndex))
        case .delete:
            collectionView.deleteSections(IndexSet(integer: sectionIndex))
        case .move:
            break
        case .update:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
//            tableView.insertRows(at: [newIndexPath!], with: .fade)
            collectionView.insertItems(at: [newIndexPath!])
        case .delete:
//            tableView.deleteRows(at: [indexPath!], with: .fade)
            collectionView.deleteItems(at: [indexPath!])
        case .update:
//            tableView.reloadRows(at: [indexPath!], with: .fade)
            collectionView.reloadItems(at: [indexPath!])
        case .move:
//            tableView.moveRow(at: indexPath!, to: newIndexPath!)
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        }
    }

//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
////        tableView.endUpdates()
//    }

    
    
    
//    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
//        // Begin asynchronously fetching data for the requested index paths.
//        for indexPath in indexPaths {
//            let model = models[indexPath.row]
//            asyncFetcher.fetchAsync(model.id)
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func configure(with data: DisplayData?) {
//        backgroundColor = data?.color
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier, for: indexPath) as? Cell else {
//            fatalError("Expected `\(Cell.self)` type for reuseIdentifier \(Cell.reuseIdentifier). Check the configuration in Main.storyboard.")
//        }
//
//        let model = models[indexPath.row]
//        let id = model.id
//        cell.representedId = id
//
//        // Check if the `asyncFetcher` has already fetched data for the specified identifier.
//        if let fetchedData = asyncFetcher.fetchedData(for: id) {
//            // The data has already been fetched and cached; use it to configure the cell.
//            cell.configure(with: fetchedData)
//        } else {
//            // There is no data available; clear the cell until we've fetched data.
//            cell.configure(with: nil)
//
//            // Ask the `asyncFetcher` to fetch data for the specified identifier.
//            asyncFetcher.fetchAsync(id) { fetchedData in
//                DispatchQueue.main.async {
//                    /*
//                     The `asyncFetcher` has fetched data for the identifier. Before
//                     updating the cell, check if it has been recycled by the
//                     collection view to represent other data.
//                     */
//                    guard cell.representedId == id else { return }
//
//                    // Configure the cell with the fetched image.
//                    cell.configure(with: fetchedData)
//                }
//            }
//        }
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
//        // Cancel any in-flight requests for data for the specified index paths.
//        for indexPath in indexPaths {
//            let model = models[indexPath.row]
//            asyncFetcher.cancelFetch(model.id)
//        }
//    }
}
