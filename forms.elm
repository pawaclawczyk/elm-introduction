import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main =
    Html.beginnerProgram { model = model, view = view, update = update }

-- MODEL

type alias Model =
    {
        name : String,
        password : String,
        passwordAgain : String
    }

model : Model
model =
    Model "" "" ""

-- UPDATE

type Msg =
    Name String |
    Password String |
    PasswordAgain String

update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }
        Password password ->
            { model | password = password }
        PasswordAgain password ->
            { model | passwordAgain = password }


-- VIEW

view : Model -> Html Msg
view model =
    div [] [
        input [ placeholder "Name", onInput Name ] [],
        input [ type_ "password", placeholder "Password", onInput Password ] [],
        input [ type_ "password", placeholder "Re-enter password", onInput PasswordAgain ] [],
        viewValidation model
    ]

viewValidation : Model -> Html Msg
viewValidation model =
    let
        (color, message) =
            if passwordLengthValidation (.password model) then
                if passwordAgainValidation (.password model) (.passwordAgain model) then
                    ("green", "OK")
                else
                    ("red", "Passwords do not match!")
            else
                ("red", "Password too short!")
    in
        div [ style [ ("color", color) ] ] [ text message ]

passwordLengthValidation : String -> Bool
passwordLengthValidation password =
    String.length password >= 8

passwordAgainValidation : String -> String -> Bool
passwordAgainValidation password passwordAgain =
    password == passwordAgain
