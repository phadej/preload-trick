-- "Mock" version of @cryptohash@ "Crypto.Hash" module
--
-- Just enough to make @github@ compile.
--
module Crypto.Hash (
    HMAC (..),
    SHA1,
    hmac,
  ) where

import           Data.ByteString  (ByteString)

import qualified Crypto.Hash.SHA1 as SHA1

data SHA1

newtype HMAC a = HMAC { hmacGetDigest :: ByteString }

hmac :: ByteString -> ByteString -> HMAC SHA1
hmac secret payload = HMAC (SHA1.hmac secret payload)
