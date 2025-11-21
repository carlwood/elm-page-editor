-- Public page editor with editable:
    -- Page title
    -- Alert message
    -- Page description

module Main exposing (..)


import Browser
import Html exposing (Html, button, div, h1, h2, h3, input, textarea, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = 
    { title : String
    , description : String
    , alertMessage: String
    , theme: String
    , themes : List (String, String) -- (value, label)
    }

init : Model
init = 
    { title = "Upcoming Brighton Yoga events"
    , description = "Join us for exciting events and workshops. Sign up now to secure your spot!"
    , alertMessage = "10% off our yoga classes this week only!"
    , theme = "default"
    , themes = 
        [ ("default", "Default")
        , ("vibrant", "Vibrant")
        , ("cool", "Cool")
        ]
    }

-- UPDATE

type Msg
    = UpdateTitle String
    | UpdateAlertMessage String
    | UpdateDescription String
    | UpdateTheme String

update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTitle newTitle ->
            { model | title = newTitle }
        UpdateDescription newDescription ->
            { model | description = newDescription }
        UpdateAlertMessage newAlertMessage ->
            { model | alertMessage = newAlertMessage }
        UpdateTheme newTheme ->
            { model | theme = newTheme }
        

-- VIEW

view : Model -> Html Msg
view model =
    div [class "layout"]
        [
            div [ class ("preview " ++ "preview--" ++ model.theme) ]
            [
                h1 [] [ text model.title ]
                , div [ class "page-description" ]
                    [ text (model.description) ]
                , div [ class "alert-message" ]
                    [ text (model.alertMessage) ]
                , div [ class "events-list" ]
                    (List.map
                        (\event ->
                            div [ class "event-card" ]
                                [ h3 [] [ text event.title ]
                                , div [] [ text (event.date) ]
                                , div [] [ text ("Location: " ++ event.location) ]
                                , div [] [ text ("Price: " ++ event.price) ]
                                , div [] [ button [] [ text "Buy ticket" ] ]
                                ]
                        )
                        [ { title = "Sunrise Yoga", date = "Dec 15, 2025", location = "Brighton Beach", price = "£15" }
                        , { title = "Vinyasa Flow", date = "Dec 18, 2025", location = "Yoga Studio", price = "£12" }
                        , { title = "Yoga & Brunch", date = "Dec 19, 2025", location = "Cafe Bliss", price = "£20" }
                        , { title = "Evening Meditation", date = "Dec 22, 2025", location = "Community Hall", price = "£10" }
                        , { title = "Family Yoga", date = "Dec 25, 2025", location = "Central Park", price = "£18" }
                        ]
                    )
            ]
            , div [class "editor"]
            [
                h2 [] [ text "Public Page Editor" ]
                , Html.form []
                [
                    label [ for "page-title"] [ text "Page title"]
                    , input [ type_ "text", value model.title, onInput UpdateTitle, id "page-title" ] []
                    , label [ for "page-description"] [ text "Page description"]
                    , textarea [ value model.description, onInput UpdateDescription, id "page-description", rows 5 ] []
                    , label [ for "alert-message"] [ text "Alert message" ]
                    , textarea [ value model.alertMessage, onInput UpdateAlertMessage, id "alert-message", rows 3 ] []
                    , label [ for "theme"] [ text "Theme" ]
                    , Html.select [ value model.theme, onInput UpdateTheme, id "theme" ]
                        (List.map
                            (\( val, labelText ) ->
                                Html.option [ value val ] [ text labelText ]
                            )
                            model.themes
                        )
                ]
            ]
        ]
