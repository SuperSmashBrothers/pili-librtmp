//
//  SSBRtmp.swift
//  pili-librtmp-swift
//
//  Created by Jiang,Zhenhua on 2018/12/12.
//  Copyright © 2018 Daubert. All rights reserved.
//

import Foundation

@objcMembers open class SSBRtmp: NSObject {
    
    public static var libVersion: Int32 {
        return RTMP_LIB_VERSION
    }
    
    public static var defaultChunkSize: Int32 {
        return RTMP_DEFAULT_CHUNKSIZE
    }
    
    /// needs to fit largest number of bytes recv() may return
    public static var bufferCacheSize: Int32 {
        return RTMP_BUFFER_CACHE_SIZE
    }
    
    public static var channels: Int32 {
        return RTMP_CHANNELS
    }
    
    public static var maxHeaderSize: Int32 {
        return RTMP_MAX_HEADER_SIZE
    }
    
    public struct Feature: OptionSet {
        public let rawValue: Int32
        public static let http = Feature(rawValue: RTMP_FEATURE_HTTP)
        public static let enc = Feature(rawValue: RTMP_FEATURE_ENC)
        public static let ssl = Feature(rawValue: RTMP_FEATURE_SSL)
        public static let mfp = Feature(rawValue: RTMP_FEATURE_MFP)
        public static let write = Feature(rawValue: RTMP_FEATURE_WRITE)
        public static let http2 = Feature(rawValue: RTMP_FEATURE_HTTP2)
        public static let all: Feature = [.http, .enc, .ssl, .mfp, .write, .http2]
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
    }
    
    public struct ProtocolType: OptionSet {
        public let rawValue: Int32
        public static let undefined = ProtocolType(rawValue: -1)
        public static let rtmp = ProtocolType(rawValue: 0)
        public static let rtmpE = ProtocolType(rawValue: Feature.enc.rawValue)
        public static let rtmpT = ProtocolType(rawValue: Feature.http.rawValue)
        public static let rtmpS = ProtocolType(rawValue: Feature.ssl.rawValue)
        public static let rtmpTE = ProtocolType(rawValue: ([Feature.http, Feature.enc] as Feature).rawValue)
        public static let rtmpHTTP2 = ProtocolType(rawValue: Feature.mfp.rawValue)
    
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }
    }
    
    enum Error: CustomNSError {
        case unknown(String?)
        case unknownOption(String?)
        /// Failed to access the DNS
        case accessDNSFailed(String?)
        case failedToConnectSocket(String?)
        case socksNegotiationFailed(String?)
        case failedToCreateSocket(String?)
        case handshakeFailed(String?)
        case rtmpConnectFailed(String?)
        case sendFailed(String?)
        case serverRequestedClose(String?)
        case netStreamFailed(String?)
        case netStreamPlayFailed(String?)
        case netStreamPlayStreamNotFound(String?)
        /// NetConnection connect invalip app
        case netConnectionConnectInvalidApp(String?)
        case sanityFailed(String?)
        case socketClosedByPeer(String?)
        case rtmpConnectStreamFailed(String?)
        case socketTimeout(String?)
        case tlsConnectFailed(String?)
        case noSSLOrTLSSupport(String?)
        
        public static var errorDomain: String {
            return "com.ssb.pili-librtmp-swift"
        }
        
        public var errorCode: Int {
            switch self {
            case .unknown: return PILI_RTMPErrorUnknow
            case .unknownOption: return PILI_RTMPErrorUnknowOption
            case .accessDNSFailed: return PILI_RTMPErrorAccessDNSFailed
            case .failedToCreateSocket: return PILI_RTMPErrorFailedToConnectSocket
            case .socksNegotiationFailed: return PILI_RTMPErrorSocksNegotiationFailed
            case .failedToConnectSocket: return PILI_RTMPErrorFailedToConnectSocket
            case .handshakeFailed: return PILI_RTMPErrorHandshakeFailed
            case .rtmpConnectFailed: return PILI_RTMPErrorRTMPConnectFailed
            case .sendFailed: return PILI_RTMPErrorSendFailed
            case .serverRequestedClose: return PILI_RTMPErrorServerRequestedClose
            case .netStreamFailed: return PILI_RTMPErrorNetStreamFailed
            case .netStreamPlayFailed: return PILI_RTMPErrorNetStreamPlayFailed
            case .netStreamPlayStreamNotFound: return PILI_RTMPErrorNetStreamPlayStreamNotFound
            case .netConnectionConnectInvalidApp: return PILI_RTMPErrorNetConnectionConnectInvalidApp
            case .sanityFailed: return PILI_RTMPErrorSanityFailed
            case .socketClosedByPeer: return PILI_RTMPErrorSocketClosedByPeer
            case .rtmpConnectStreamFailed: return PILI_RTMPErrorRTMPConnectStreamFailed
            case .socketTimeout: return PILI_RTMPErrorSocketTimeout
            case .tlsConnectFailed: return PILI_RTMPErrorTLSConnectFailed
            case .noSSLOrTLSSupport: return PILI_RTMPErrorNoSSLOrTLSSupport
            }
        }
        
        public var errorUserInfo: [String : Any] {
            switch self {
            case .unknown(let msg),
                 .unknownOption(let msg),
                 .accessDNSFailed(let msg),
                 .failedToCreateSocket(let msg),
                 .socksNegotiationFailed(let msg),
                 .failedToConnectSocket(let msg),
                 .handshakeFailed(let msg),
                 .rtmpConnectFailed(let msg),
                 .sendFailed(let msg),
                 .serverRequestedClose(let msg),
                 .netStreamFailed(let msg),
                 .netStreamPlayFailed(let msg),
                 .netStreamPlayStreamNotFound(let msg),
                 .netConnectionConnectInvalidApp(let msg),
                 .sanityFailed(let msg),
                 .socketClosedByPeer(let msg),
                 .rtmpConnectStreamFailed(let msg),
                 .socketTimeout(let msg),
                 .tlsConnectFailed(let msg),
                 .noSSLOrTLSSupport(let msg):
                return [NSLocalizedDescriptionKey: msg ?? "No description"]
            }
        }
        
        public var rawError: RTMPError {
            return RTMPError(code: Int32(errorCode), message: localizedDescription.UTF8CString)
        }
        
        public init?(error: RTMPError) {
            let code: Int = Int(error.code)
            let messsage = String(cString: error.message)
            switch code {
            case PILI_RTMPErrorUnknow: self = .unknown(messsage)
            case PILI_RTMPErrorUnknowOption: self = .unknownOption(messsage)
            case PILI_RTMPErrorAccessDNSFailed: self = .accessDNSFailed(messsage)
            case PILI_RTMPErrorFailedToConnectSocket: self = .failedToConnectSocket(messsage)
            case PILI_RTMPErrorSocksNegotiationFailed: self = .socksNegotiationFailed(messsage)
            case PILI_RTMPErrorFailedToCreateSocket: self = .failedToCreateSocket(messsage)
            case PILI_RTMPErrorHandshakeFailed: self = .handshakeFailed(messsage)
            case PILI_RTMPErrorRTMPConnectFailed: self = .rtmpConnectFailed(messsage)
            case PILI_RTMPErrorSendFailed: self = .sendFailed(messsage)
            case PILI_RTMPErrorServerRequestedClose: self = .serverRequestedClose(messsage)
            case PILI_RTMPErrorNetStreamFailed: self = .netStreamFailed(messsage)
            case PILI_RTMPErrorNetStreamPlayFailed: self = .netStreamPlayFailed(messsage)
            case PILI_RTMPErrorNetStreamPlayStreamNotFound: self = .netStreamPlayStreamNotFound(messsage)
            case PILI_RTMPErrorNetConnectionConnectInvalidApp: self = .netConnectionConnectInvalidApp(messsage)
            case PILI_RTMPErrorSanityFailed: self = .sanityFailed(messsage)
            case PILI_RTMPErrorSocketClosedByPeer: self = .socketClosedByPeer(messsage)
            case PILI_RTMPErrorRTMPConnectStreamFailed: self = .rtmpConnectStreamFailed(messsage)
            case PILI_RTMPErrorSocketTimeout: self = .socketTimeout(messsage)
            case PILI_RTMPErrorTLSConnectFailed: self = .tlsConnectFailed(messsage)
            case PILI_RTMPErrorNoSSLOrTLSSupport: self = .tlsConnectFailed(messsage)
            case PILI_RTMPErrorNoSSLOrTLSSupport: self = .noSSLOrTLSSupport(messsage)
            default: return nil
            }
        }
    }
    
    public class AMFObject: NSObject {
        
    }
    
    @objcMembers public class Packet: NSObject {
        var packet: UnsafeMutablePointer<PILI_RTMPPacket>?
        
        public var isReady: Bool {
            return packet?.pointee.m_nBytesRead == packet?.pointee.m_nBodySize
        }
        
        @objc public enum HeaderType: Int32 {
            case unknown = -1, large, medium, small, minimum
            
            public init(rawValue: Int32) {
                switch rawValue {
                case RTMP_PACKET_SIZE_LARGE: self = .large
                case RTMP_PACKET_SIZE_LARGE: self = .medium
                case RTMP_PACKET_SIZE_SMALL: self = .small
                case RTMP_PACKET_SIZE_MINIMUM: self = .minimum
                default: self = .unknown
                }
            }
        }
        
        public var headerType: HeaderType {
            set(newValue) {
                packet?.pointee.m_headerType = UInt8(newValue.rawValue)
            }
            get {
                guard let p = packet?.pointee else {
                    return .unknown
                }
                return HeaderType(rawValue: Int32(p.m_headerType))
            }
        }
        
        public enum PacketType: Int32 {
            case audio = 0x08, video
            case info = 0x12
            case unknown = -1
            
            public init(rawValue: Int32) {
                switch rawValue {
                case RTMP_PACKET_TYPE_AUDIO: self = .audio
                case RTMP_PACKET_TYPE_VIDEO: self = .video
                case RTMP_PACKET_TYPE_INFO: self = .info
                default: self = .unknown
                }
            }
        }
        
        public var type: PacketType {
            set(newValue) {
                packet?.pointee.m_packetType = UInt8(type.rawValue)
            }
            get {
                guard let p = packet?.pointee else {
                    return .unknown
                }
                return PacketType(rawValue: Int32(p.m_packetType))
            }
        }
        
        public var data: Data? {
            set(newValue) {
                guard let d = newValue else {
                    packet?.pointee.m_body = nil
                    packet?.pointee.m_nBodySize = 0
                    return
                }
                let size = d.count
                packet?.pointee.m_nBodySize = UInt32(size)
                memcpy(packet?.pointee.m_body, d.withUnsafeBytes { UnsafeRawPointer($0) } , size)
            }
            get {
                guard let ptr = packet?.pointee else {
                    return nil
                }
                return Data(bytes: ptr.m_body, count: Int(ptr.m_nBodySize))
            }
        }
        
        public var timeStamp: Int {
            set(newValue) {
                packet?.pointee.m_nTimeStamp = UInt32(newValue)
            }
            get {
                return Int(packet?.pointee.m_nTimeStamp ?? 0)
            }
        }
        
        public var useExtTimestamp: Bool {
            set(newValue) {
                packet?.pointee.m_useExtTimestamp = newValue ? 1 : 0
            }
            get {
                return packet?.pointee.m_useExtTimestamp == 1
            }
        }
        
        /// timestamp absolute or relative
        public var hasAbsTimestamp: Bool {
            set(newValue) {
                packet?.pointee.m_hasAbsTimestamp = newValue ? 1 : 0
            }
            get {
                return packet?.pointee.m_hasAbsTimestamp == 1
            }
        }
        
        public var size: Int {
            return Int(packet?.pointee.m_nBodySize ?? 0)
        }
        
        public override init() {
            super.init()
            PILI_RTMPPacket_Reset(packet)
            PILI_RTMPPacket_Alloc(packet, Int32(size))
        }
        
        public func reset() {
            PILI_RTMPPacket_Reset(packet)
        }
        
        public func dump() {
            PILI_RTMPPacket_Dump(packet)
        }
        
        deinit {
            PILI_RTMPPacket_Free(packet)
        }
    }
    
    var rtmp = PILI_RTMP_Alloc()
    
    public var isConnected: Bool {
        return PILI_RTMP_IsConnected(rtmp) == 1
    }
    
    public var isTimeout: Bool {
        return PILI_RTMP_IsTimedout(rtmp) == 1
    }
    
    public var url: String? {
        didSet {
            if let url = self.url?.UTF8CString,
                PILI_RTMP_SetupURL(rtmp, url, nil) > 0 {
                self.url = nil
            }
        }
    }
    
    public override init() {
        super.init()
        // 调用初始化方法
        PILI_RTMP_Init(rtmp)
    }
    
   public func close() throws {
        guard let rtmp = self.rtmp else {
            return
        }
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        PILI_RTMP_Close(rtmp, &err)
        if let error = Error(error: err) {
            throw error
        }
    }
    
   public func connect(packet: Packet? = nil) throws {
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        guard PILI_RTMP_Connect(rtmp, packet?.packet, &err) > 0 else {
            if let e = Error(error: err) {
                throw e
            }
            return
        }
    }
    
    public func pause(doPause: Bool) throws {
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        guard PILI_RTMP_Pause(rtmp, doPause ? 1 : 0, &err) > 0 else {
            if let e = Error(error: err) {
                throw e
            }
            return
        }
    }
    
    public func connectStream(seekTime: Int) throws {
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        guard PILI_RTMP_ConnectStream(rtmp, Int32(seekTime), &err) > 0 else {
            if let e = Error(error: err) {
                throw e
            }
            return
        }
    }
    
    public func reconnectStream(seekTime: Int) throws {
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        guard PILI_RTMP_ReconnectStream(rtmp, Int32(seekTime), &err) > 0 else {
            if let e = Error(error: err) {
                throw e
            }
            return
        }
    }
    
    public func deleteStream() throws {
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        PILI_RTMP_DeleteStream(rtmp, &err)
        if let e = Error(error: err) {
            throw e
        }
    }
    
    @discardableResult
    public func read(packet: Packet) -> Int32 {
        return Int32(PILI_RTMP_ReadPacket(rtmp, packet.packet))
    }
    
    public func serve() throws {
        var err = RTMPError()
        defer {
            PILI_RTMPError_Free(&err)
        }
        guard PILI_RTMP_Serve(rtmp, &err) > 0 else {
            if let e = Error(error: err) {
                throw e
            }
            return
        }
    }
    
    public func enableWrite() {
        PILI_RTMP_EnableWrite(rtmp)
    }
    
    deinit {
        try? close()
        PILI_RTMP_Free(rtmp)
    }
}

extension String {
    var UTF8CString: UnsafeMutablePointer<Int8> {
        var messageCString = utf8CString
        return messageCString.withUnsafeMutableBytes { mesUMRBP in
            return mesUMRBP.baseAddress!.bindMemory(to: Int8.self, capacity: mesUMRBP.count)
        }
    }
}
