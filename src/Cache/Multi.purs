module Cache.Multi
  ( Multi
  , delKeyListMulti
  , delKeyMulti
  , execMulti
  , expireMulti
  , getHashKeyMulti
  , getKeyMulti
  , incrMulti
  , lindexMulti
  , lpopMulti
  , lpushMulti
  , newMulti
  , publishToChannelMulti
  , rpopMulti
  , rpushMulti
  , setHashMulti
  , setMulti
  , subscribeMulti
  ) where

import Cache.Types (CacheConn, SetOptions)
import Control.Monad.Aff (Aff, attempt)
import Control.Monad.Eff.Exception (Error)
import Control.Promise (Promise, toAff)
import Data.Either (Either)
import Data.Int (round)
import Data.Maybe (Maybe, maybe)
import Data.Time.Duration (Milliseconds(..))
import Prelude (show, ($), (<<<))

foreign import data Multi :: Type

foreign import newMultiJ :: CacheConn -> Multi

foreign import setMultiJ :: String -> String -> String -> String -> Multi -> Multi
foreign import getKeyMultiJ ::  String -> Multi -> Multi
foreign import delKeyMultiJ :: Array String -> Multi -> Multi
foreign import expireMultiJ :: String -> String -> Multi -> Multi
foreign import incrMultiJ ::  String -> Multi -> Multi
foreign import setHashMultiJ :: String -> String -> String -> Multi -> Multi
foreign import getHashMultiJ :: String -> String -> Multi -> Multi
foreign import publishCMultiJ :: String -> String -> Multi -> Multi
foreign import subscribeMultiJ :: String -> Multi -> Multi
foreign import rpopMultiJ :: String -> Multi -> Multi
foreign import rpushMultiJ :: String -> String -> Multi -> Multi
foreign import lpopMultiJ :: String -> Multi -> Multi
foreign import lpushMultiJ :: String -> String -> Multi -> Multi
foreign import lindexMultiJ :: String -> Int -> Multi -> Multi
foreign import execMultiJ :: Multi -> Promise (Array String)

newMulti :: CacheConn -> Multi
newMulti = newMultiJ

execMulti :: forall e. Multi -> Aff e (Either Error (Array String))
execMulti = attempt <<< toAff <<< execMultiJ

setMulti :: String -> String -> Maybe Milliseconds -> SetOptions -> Multi -> Multi
setMulti key value mExp opts = setMultiJ key value (maybe "" msToString mExp) (show opts)
  where
        msToString (Milliseconds v) = show $ round v

getKeyMulti :: String -> Multi -> Multi
getKeyMulti val =  getKeyMultiJ val

delKeyMulti :: String -> Multi -> Multi
delKeyMulti key = delKeyMultiJ [key]

delKeyListMulti :: Array String -> Multi -> Multi
delKeyListMulti keys =  delKeyMultiJ keys

expireMulti :: String -> String -> Multi -> Multi
expireMulti key ttl = expireMultiJ key ttl

incrMulti :: String -> Multi -> Multi
incrMulti key = incrMultiJ key

setHashMulti :: String -> String -> String -> Multi -> Multi
setHashMulti key field val = setHashMultiJ key field val

getHashKeyMulti :: String -> String -> Multi -> Multi
getHashKeyMulti key field = getHashMultiJ key field

publishToChannelMulti :: String -> String -> Multi ->  Multi
publishToChannelMulti channel message = publishCMultiJ channel message

subscribeMulti :: String -> Multi -> Multi
subscribeMulti channel =  subscribeMultiJ channel

rpopMulti :: String -> Multi -> Multi
rpopMulti listName = rpopMultiJ listName

rpushMulti :: String -> String -> Multi -> Multi
rpushMulti listName value = rpushMultiJ listName value

lpopMulti :: String -> Multi -> Multi
lpopMulti listName = lpopMultiJ listName

lpushMulti :: String -> String -> Multi -> Multi
lpushMulti listName value = lpushMultiJ listName value

lindexMulti :: String -> Int -> Multi -> Multi
lindexMulti listName index = lindexMultiJ  listName index