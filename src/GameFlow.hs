{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module GameFlow where

import           Data.Text (Text, unpack)
import           Network.Curl (curlPost)
import           Data.List (isPrefixOf)
import           WebhookUtil

page_access_token :: String
page_access_token = "<PAGE_ACCESS_TOKEN>"
genEndPoint :: String
genEndPoint = concat ["https://graph.facebook.com/v2.6/",
                      "me/messages/",
                      "?",
                      "&access_token=",
                      page_access_token]

postMessage :: String -> String -> IO ()
postMessage psid message = do
    curlPost (genEndPoint) ["messaging_type=RESPONSE",
                            "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                            "message=%7B%0A%20%20%22text%22%3A%20%22"++message'++"%22%0A%7D"
                           ]
    where message' = foldr replacement message replacementInput

postYoutubeVideo :: String -> String -> IO ()
postYoutubeVideo psid youtube_id = do
    curlPost (genEndPoint) ["messaging_type=RESPONSE",
                            "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                            "message=%7B%0A%20%20%20%20%22attachment%22%3A%7B%0A%20%20%20%20%20%20%22type%22%3A%22template%22%2C%0A%20%20%20%20%20%20%22payload%22%3A%7B%0A%20%20%20%20%20%20%20%20%22template_type%22%3A%22open_graph%22%2C%0A%20%20%20%20%20%20%20%20%22elements%22%3A%5B%0A%20%20%20%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22url%22%3A%22https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D"++youtube_id++"%22%20%20%20%20%0A%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%5D%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D"
                           ]

postFixImage :: String -> IO ()
postFixImage psid = do
    curlPost (genEndPoint) ["messaging_type=RESPONSE",
                            "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                            "message=%7B%0A%20%20%20%20%22attachment%22%3A%7B%0A%20%20%20%20%20%20%22type%22%3A%22image%22%2C%20%0A%20%20%20%20%20%20%22payload%22%3A%7B%0A%20%20%20%20%20%20%20%20%22url%22%3A%22https%3A%2F%2Fcdn.glitch.com%2F05a5c2fa-5c29-4ad8-a5ce-a3499492e5d4%252Fthumbnails%252Fpigstory.jpg%22%2C%20%0A%20%20%20%20%20%20%20%20%22is_reusable%22%3Atrue%0A%20%20%20%20%20%20%7D%0A%20%20%20%20%7D%0A%20%20%7D"
                           ]

postFixPreRegistrationRequestButton :: String -> IO ()
postFixPreRegistrationRequestButton psid = do
   curlPost (genEndPoint) ["messaging_type=RESPONSE",
                           "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                           "message=%7B%0A%20%20%20%20%22text%22%3A%20%22Do%20you%20wish%20to%20be%20notify%20when%20the%20game%20is%20launch%22%2C%0A%20%20%20%20%22quick_replies%22%3A%5B%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%22content_type%22%3A%22text%22%2C%0A%20%20%20%20%20%20%20%20%22title%22%3A%22Yes%22%2C%0A%20%20%20%20%20%20%20%20%22payload%22%3A%22YES_NOTIFY_PAYLOAD%22%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%22content_type%22%3A%22text%22%2C%0A%20%20%20%20%20%20%20%20%22title%22%3A%22No%22%2C%0A%20%20%20%20%20%20%20%20%22payload%22%3A%22NO_NOTIFY_PAYLOAD%22%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%5D%0A%20%20%7D"
                          ]

postFixUpdateRequestButton :: String -> IO ()
postFixUpdateRequestButton psid = do
    curlPost (genEndPoint) ["messaging_type=RESPONSE",
                            "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                            "message=%7B%0A%20%20%20%20%22text%22%3A%20%22Commander!%20Do%20you%20wish%20to%20know%20more%20about%20the%20version%20update%3F%22%2C%0A%20%20%20%20%22quick_replies%22%3A%5B%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%22content_type%22%3A%22text%22%2C%0A%20%20%20%20%20%20%20%20%22title%22%3A%22Yes%20for%20update%22%2C%0A%20%20%20%20%20%20%20%20%22payload%22%3A%22YES_UPDATE_PAYLOAD%22%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%22content_type%22%3A%22text%22%2C%0A%20%20%20%20%20%20%20%20%22title%22%3A%22No%22%2C%0A%20%20%20%20%20%20%20%20%22payload%22%3A%22NO_UPDATE_PAYLOAD%22%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%5D%0A%20%20%7D"
                           ]

postFixSurveyRequestButton :: String -> IO ()
postFixSurveyRequestButton psid = do
   curlPost (genEndPoint) ["messaging_type=RESPONSE",
                           "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                           "message=%7B%0A%20%20%20%20%22text%22%3A%20%22Do%20you%20think%20the%20game%20will%20be%20balance%3F%22%2C%0A%20%20%20%20%22quick_replies%22%3A%5B%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%22content_type%22%3A%22text%22%2C%0A%20%20%20%20%20%20%20%20%22title%22%3A%22Yes%20the%20game%20balance%20will%20be%20fix%20with%20this%20update%22%2C%0A%20%20%20%20%20%20%20%20%22payload%22%3A%22YES_SURVEY_PAYLOAD%22%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%22content_type%22%3A%22text%22%2C%0A%20%20%20%20%20%20%20%20%22title%22%3A%22No%20the%20game%20balance%20is%20broken%20with%20this%20update%22%2C%0A%20%20%20%20%20%20%20%20%22payload%22%3A%22NO_SURVEY_PAYLOAD%22%2C%0A%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%5D%0A%20%20%7D"
                          ]


postFixShareButton :: String -> IO ()
postFixShareButton psid = do
 curlPost (genEndPoint) ["messaging_type=RESPONSE",
                         "recipient=%7B%0A%20%20%22id%22%3A%20%22"++psid++"%22%0A%7D",
                         "message=%7B%0A%20%20%20%20%20%20%20%20%22attachment%22%3A%7B%0A%20%20%20%20%20%20%20%20%20%20%22type%22%3A%22template%22%2C%0A%20%20%20%20%20%20%20%20%20%20%22payload%22%3A%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22template_type%22%3A%22generic%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22elements%22%3A%5B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22title%22%3A%22Lets%20Rock%20and%20Roll%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22image_url%22%3A%22https%3A%2F%2Fcdn.glitch.com%2F05a5c2fa-5c29-4ad8-a5ce-a3499492e5d4%252Fthumbnails%252Fpigstory.jpg%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22subtitle%22%3A%22Share%20the%20new%20release%20weapon%20with%20your%20friends!%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22buttons%22%3A%5B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22type%22%3A%22element_share%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%5D%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%20%20%20%20%5D%0A%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%7D"
                        ]

startPreRegistrationAnnouncement :: Text -> IO ()
startPreRegistrationAnnouncement v = case (getSenderId v) of
    Just x -> do
        postYoutubeVideo x' "21OxXZyxK0c"
        postMessage x' "Welcome Commander, awaiting for your order."
        postMessage x' "The battle is yet to begin. All you have to do now command YES to the pre-registration and we will notify you when the game is launch."
        postFixPreRegistrationRequestButton x'
        where x' = unpack x
    _ -> return ()

contPreRegistrationAnnouncement :: String -> IO ()
contPreRegistrationAnnouncement x = postMessage x "Thank you for confimation. We will notify you when the game is launch and await further order from you."

demoUpdate :: String -> IO ()
demoUpdate x = do
    postFixImage x
    postMessage x "Good morning Commader, we have a NEW update"
    postMessage x "Version 3.1.4 update: \n - All guns plus 10 ATK \n - All armours minus 10 DEF \n - All magic comes with protection buff"
    postFixSurveyRequestButton x

demoShare :: String -> IO ()
demoShare = postFixShareButton

processPayload :: Text -> IO ()
processPayload v = case (getSenderId v) of
                    Just x -> do
                            case (getMessagePayload v) of
                                Just "GET_STARTED" -> startPreRegistrationAnnouncement v
                                Just "HPMP_PAYLOAD" -> postMessage x' "Commander! 100/100HP 96/100MP"
                                Just "AUCTION_PAYLOAD" -> postMessage x' "Commander! You won the auction, Tank X34-H will arrive in armoury once you login into the game"
                                Just "BATTLE_PAYLOAD" -> postMessage x' "Commander! Player Wynners have attacked your city. Enter the game to reinforce our defence forces"
                                _                   -> postMessage x' "WARNING:INVALID PAYLOAD DEBUG CMD"
                            where x' = unpack x
                    Nothing -> return ()

yes_game_balance :: Text
yes_game_balance = "Yes the game balance will be fix with this update"
processMessage :: Text -> IO ()
processMessage v = case (getSenderId v) of
                    Just x -> do
                            case (getMessageText v) of
                                Just "Yes"              -> contPreRegistrationAnnouncement x'
                                Just "DemoUpdate"       -> postFixUpdateRequestButton x'
                                Just "Yes for update"   -> demoUpdate x'
                                Just "DemoShare"        -> demoShare x'
                                Just yes_game_balance   -> postMessage x' "Thank you for the feedback"
                                _                       -> postMessage x' "WARNING:INVALID MESSAGE DEBUG CMD"
                            where x' = unpack x
                    Nothing -> return ()

processTrigger :: Text -> Text -> IO ()
processTrigger psid mode = case mode of
                            "DemoUpdate"          -> postFixUpdateRequestButton psid'
                            "DemoPreRegistration" -> startPreRegistrationAnnouncement psid
                            _                     -> putStrLn "Invalid trigger"
                           where psid' = unpack psid


formatMessage :: String -> String
formatMessage message = foldr replacement message replacementInput

data Replacement = ReplacementCharacter (Char, String) | ReplacementString (String, String)

replacementInput :: [Replacement]
replacementInput =
     [ ReplacementCharacter ('&', "%26"),
       ReplacementCharacter ('\n', "%5Cr%5Cn"),
       ReplacementString ("\"", "%5C%22")
     ]

replacement :: Replacement -> String -> String
replacement (ReplacementCharacter x) m = replaceCharacter x m
replacement (ReplacementString x) m = replaceSubstring x m

replaceCharacter :: (Char, String) -> String -> String
replaceCharacter _ [] = []
replaceCharacter or'@(o,r') (m:ms)
    | m == o = r' ++ replaceCharacter or' ms
    | otherwise = m : replaceCharacter or' ms

replaceSubstring :: (String, String) -> String -> String
replaceSubstring _ [] = []
replaceSubstring or'@(o, r') m'@(m:ms)
    | o `isPrefixOf` m' = r' ++ replaceSubstring or' (drop (length o) m')
    | otherwise = m : replaceSubstring or' ms
