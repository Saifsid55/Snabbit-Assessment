//
//  AppColor.swift
//  Snabbit Assesment
//
//  Created by Muhammad Saif on 15/03/26.
//

import UIKit
 
enum AppColors {
 
    // ── Progress bar ────────────────────────────────────────────────
    /// Filled (active) portion of the progress bar.
    static let progressFill  = UIColor(hex: "#371382")
    /// Track (background) of the progress bar.
    static let progressTrack = UIColor(hex: "#E5E5EA")
 
    
    // ── Buttons ──────────────────────────────────────────────────────
    /// Primary action button background (Continue).
    static let primaryButton = UIColor(hex: "#371382")
    /// Primary button text color.
    static let primaryButtonTitle = UIColor.white
 
    
    // ── Checkbox ─────────────────────────────────────────────────────
    /// Checked-state fill color for multi-select checkboxes.
    static let checkboxChecked   = UIColor(hex: "#371382")
    /// Unchecked border color.
    static let checkboxUnchecked = UIColor(hex: "#C7C7CC")
 
    // ── Radio ────────────────────────────────────────────────────────
    static let radioSelected   = UIColor(hex: "#371382")
    static let radioUnselected = UIColor(hex: "#C7C7CC")
}
