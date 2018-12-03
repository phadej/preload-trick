-- "Mock" version of @http-client-tls@ main module
--
-- Just enough to make @github@ compile.
--
module Network.HTTP.Client.TLS (tlsManagerSettings) where

import           Network.HTTP.Client         (ManagerSettings)
import           Network.HTTP.Client.OpenSSL (opensslManagerSettings)

import qualified OpenSSL.Session as OpenSSL

tlsManagerSettings :: ManagerSettings
tlsManagerSettings = opensslManagerSettings OpenSSL.context
