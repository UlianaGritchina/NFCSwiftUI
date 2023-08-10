//
//  NFCManager.swift
//  NFCSwiftUI
//
//  Created by Ульяна Гритчина on 10.08.2023.
//

import Foundation
import CoreNFC

final class NFCManager: NSObject, ObservableObject, NFCNDEFReaderSessionDelegate {
    
    var actualData = ""
    var nfcSession: NFCNDEFReaderSession?
    
    func scan(actualData: String) {
        self.actualData = actualData
        nfcSession = NFCNDEFReaderSession(
            delegate: self,
            queue: nil,
            invalidateAfterFirstRead: true
        )
        nfcSession?.alertMessage = "Hold your iPhone near the NFC Tag"
        nfcSession?.begin()
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) { }
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) { }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        let str = actualData
        
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            nfcSession?.alertMessage = "Please try agin"
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        guard let tag = tags.first else { return }
        
        session.connect(to: tag) { error in
            if error != nil {
                self.nfcSession?.alertMessage = "Unable to connect"
                session.invalidate()
                return
            }
        }
        
        tag.queryNDEFStatus { status, capacity, error in
            if error != nil {
                self.nfcSession?.alertMessage = "Unable to connect"
                session.invalidate()
                return
            }
            
            switch status {
            case .notSupported:
                self.nfcSession?.alertMessage = "Unable to connect"
                session.invalidate()
            case .readWrite:
                tag.writeNDEF(.init(records: [.wellKnownTypeURIPayload(string: str)!])) { error in
                    guard error != nil else {
                        self.nfcSession?.alertMessage = "Write faild"
                        session.invalidate()
                        return
                    }
                    
                    session.alertMessage = "You have successfully activate your tag"
                    session.invalidate()
                }
            case .readOnly:
                self.nfcSession?.alertMessage = "Unable to connect"
                session.invalidate()
            @unknown default:
                self.nfcSession?.alertMessage = "Unknown error"
                session.invalidate()
            }
            
        }
        
    }
    
}
