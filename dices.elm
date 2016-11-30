import Html exposing (..)
import Html.Events exposing (..)
import Random

type alias Model =
    {
        firstDie : Int,
        secondDie : Int
    }

type Msg =
    Roll |
    FirstDieFace Int |
    SecondDieFace Int

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Roll ->
            (model, Random.generate FirstDieFace (Random.int 1 6))

        FirstDieFace firstDieFace ->
            ({ model | firstDie = firstDieFace }, Random.generate SecondDieFace (Random.int 1 6))

        SecondDieFace secondDieFace ->
            ({ model | secondDie = secondDieFace }, Cmd.none)

view : Model -> Html Msg
view model =
    div []
    [ h1 [] [ text (toString model.firstDie ++ " " ++ toString model.secondDie) ]
    , button [ onClick Roll ] [ text "Roll" ]
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

init : (Model, Cmd Msg)
init =
    (Model 1 1, Cmd.none)

main =
    Html.program
        {
            init = init,
            view = view,
            update = update,
            subscriptions = subscriptions
        }
