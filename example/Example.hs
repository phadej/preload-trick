{-# LANGUAGE CPP               #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import qualified GitHub  as GH

#ifdef MIN_VERSION_HsOpenSSL
import           OpenSSL (withOpenSSL)
#else
withOpenSSL :: IO a -> IO a
withOpenSSL = id
#endif

main :: IO ()
main = withOpenSSL $ do
    possibleUser <- GH.executeRequest' $ GH.userInfoForR "phadej"
    print possibleUser
