import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http exposing (..)
import Json.Decode as Json

main =
    Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

type alias Model =
    {
        topic : String,
        newTopic: String,
        gifUrl : String,
        error: String
    }


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
    | Search
    | NewTopic String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MorePlease ->
            (model, getRandomGif model.topic)
        Search ->
            ({model | topic = model.newTopic}, getRandomGif model.newTopic)
        NewGif (Ok newUrl) ->
            ({model | gifUrl = newUrl, error = ""}, Cmd.none)
        NewGif (Err error) ->
            ({model | error = errorToMessage(error)}, Cmd.none)
        NewTopic newTopic ->
            ({ model | newTopic = newTopic}, Cmd.none)

errorToMessage : Http.Error -> String
errorToMessage error =
    case error of
        BadUrl msg -> "Bad URL :: " ++ msg
        Timeout -> "Timeout"
        NetworkError -> "Network Error"
        BadStatus response -> "Bad Status :: " ++ toString response.status
        BadPayload payload response -> "Bad Payload :: " ++ payload ++ " :: " ++ toString response.status

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
        request = Http.get url decodeGifUrl
    in
        Http.send NewGif request

decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at ["data", "image_url"] Json.string

view : Model -> Html Msg
view model =
    div []
    [ h2 [] [ text model.topic ]
    , input [ type_ "text", placeholder "Search GIF topic", onInput NewTopic ] []
    , img [ src model.gifUrl ] []
    , button [ onClick MorePlease ] [ text "More Please!" ]
    , button [ onClick Search ] [ text "Search"]
    , renderError model
    ]

renderError : Model -> Html Msg
renderError model =
    if not (String.isEmpty model.error) then div [ style [("color", "red")] ] [ text model.error ]
    else div [] []

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init : (Model, Cmd Msg)
init =
    (Model "Cats" "" "wait.gif" "", Cmd.none)
