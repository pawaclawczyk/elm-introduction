import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import String exposing (length, any)
import Char exposing (isDigit, isUpper, isLower)

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
            if not (passwordLengthValidation model) then ("red", "Password too short!")
            else if not (passwordAgainValidation model) then ("red", "Passwords do not match!")
            else if not (passwordContains isDigit model) then ("red", "Password must contain a digit!")
            else if not (passwordContains isUpper model) then ("red", "Password must contain an uppercase letter!")
            else if not (passwordContains isLower model) then ("red", "Password must contain a lowercase letter!")
            else ("green", "OK")
    in
        div [ style [ ("color", color) ] ] [ text message ]

passwordLengthValidation : Model -> Bool
passwordLengthValidation model =
    length (.password model) >= 8

passwordAgainValidation : Model -> Bool
passwordAgainValidation model =
    (.password model) == (.passwordAgain model)

passwordContains : (Char -> Bool) -> Model -> Bool
passwordContains check model =
    any check (.password model)