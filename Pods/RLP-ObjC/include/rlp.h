@import Foundation;

// supported types: NSArray, NSData, NSString
FOUNDATION_EXPORT NSData *rlp_encode(id data);
FOUNDATION_EXPORT id rlp_decode(NSData *data);
