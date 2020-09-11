//
//  ViewControllerExtension.swift
//  SortListChallenge
//
//  Created by Leonardo Diaz on 9/10/20.
//  Copyright © 2020 Leonardo Diaz. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentErrorToUser(localizedError: SortListError) {
        let alertController = UIAlertController(title: "Woops", message: localizedError.errorDescription, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(dismissAction)
        present(alertController, animated: true)
    }
}
