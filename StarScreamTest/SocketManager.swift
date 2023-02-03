//
//  SocketManager.swift
//  StarScreamTest
//
//  Created by 신상원 on 2023/02/03.
//

import Combine
import Foundation

import Starscream

// MARK: -
/// 1) 싱글톤 구현
/// 2) 의존성 주입을 통한 구현
final class SocketManager {
  static let shared = SocketManager()

  private var socket: WebSocket?
//  var chatNumber: Int = 0
//
//  let sub1 = PassthroughSubject<String, Never>()
//  let sub2 = PassthroughSubject<String, Never>()
//  let sub3 = PassthroughSubject<String, Never>()
//  let sub4 = PassthroughSubject<String, Never>()

  private init() {
    setupWebSocket()
    test()
  }

  deinit {
    socket?.delegate = nil
  }

  private func setupWebSocket() {
    let url = URL(string: "wss://api.upbit.com/websocket/v1")!
    var request = URLRequest(url: url)
    request.timeoutInterval = 5 // ping 주기랑 동일한 의미를 가지는지?
    socket = WebSocket(request: request)
  }

  func connect() {
    socket?.delegate = self
    socket?.connect()
  }

  func disconnect() {
    socket?.disconnect()
  }

  private func sendMessage(_ message: String) {
    socket?.write(string: message)
  }

  private func sendRequest() -> String {
    """
    [{"ticket":"\(UUID())"},{"type":"orderbook","codes":["KRW-BTC"]}]
    """
  }

  func test() {
    socket?.onEvent = { event in
      print("--------------")
      print(event)
    }
  }

}

extension SocketManager: WebSocketDelegate {
  func didReceive(event: WebSocketEvent, client: WebSocket) {
    switch event {
    case .connected(let headers):
      print(headers)
      print("websocket is connected: \(headers)")
//      let params = [["ticket":"test"],
//                    ["format":"SIMPLE"],
//                    ["type":"orderbook","codes":["\(currency)-\(coin)"]],
//                    ["type":"trade","codes":["\(currency)-\(coin)"]]]
//
//      let jParams = try! JSONSerialization.data(withJSONObject: params, options: [])
//      client.write(string: String(data:jParams, encoding: .utf8)!, completion: nil)
//      client.write(string: sendRequest())
    case .disconnected(let reason, let code):
      print("websocket is disconnected: \(reason) with code: \(code)")
    case .text(let text):
      print("received text: \(text)")
    case .binary(let data):
      print("Received data: \(data.count)")
    case .ping(_):
      print("Ping: ")
    case .pong(_):
      print("Pong: ")
    case .viabilityChanged(_):
      print("viabilityChanged")
    case .reconnectSuggested(_):
      print("reconnectSuggested")
    case .cancelled:
      print("websocket is canclled")
    case .error(let error):
      print("websocket is error = \(error!)")
    }
  }
}
