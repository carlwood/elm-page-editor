-- Public page editor with editable:
    -- Page title
    -- Alert message
    -- Page description

module Main exposing (..)


import Browser
import Html exposing (Html, button, div, h1, h2, h3, input, textarea, text, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)

-- MAIN

main =
    Browser.sandbox { init = init, update = update, view = view }

-- MODEL

type alias Model = 
    { title : String
    , description : String
    , showAlert : Bool
    , alertMessage: String
    , theme: String
    , themes : List (String, String) -- (value, label)
    , editorOpen : Bool
    }

init : Model
init = 
    { title = "Upcoming Brighton Yoga events"
    , description = "Join us for exciting events and workshops. Sign up now to secure your spot!"
    , showAlert = False
    , alertMessage = "10% off our yoga classes this week only!"
    , theme = "default"
    , themes = 
        [ ("default", "Default")
        , ("vibrant", "Vibrant")
        , ("cool", "Cool")
        , ("forest", "Forest")
        ]
    , editorOpen = False
    }

-- UPDATE

type Msg
    = UpdateTitle String
    | UpdateShowAlert Bool
    | UpdateAlertMessage String
    | UpdateDescription String
    | UpdateTheme String
    | UpdateEditorOpen Bool

update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateTitle newTitle ->
            { model | title = newTitle }
        UpdateDescription newDescription ->
            { model | description = newDescription }
        UpdateShowAlert newShowAlert ->
            { model | showAlert = newShowAlert }
        UpdateAlertMessage newAlertMessage ->
            { model | alertMessage = newAlertMessage }
        UpdateTheme newTheme ->
            { model | theme = newTheme }
        UpdateEditorOpen isOpen ->
            { model | editorOpen = isOpen }
        

-- VIEW

view : Model -> Html Msg
view model =
    div [class "layout"]
        [
            div [ class ("preview " ++ "preview--" ++ model.theme) ]
            [
                button [ class "edit-button", onClick (if model.editorOpen then UpdateEditorOpen False else UpdateEditorOpen True) ]
                    [ text (if model.editorOpen then "Close" else "Edit page") ]
                ,
                h1 [] [ text model.title ]
                , div [ class "page-description" ]
                    [ text (model.description) ]
                , div [ class "alert-message", class (if model.showAlert then "show" else "hide") ]
                    [ text (model.alertMessage) ]
                , div [ class "events-list" ]
                    (List.map
                        (\event ->
                            div [ class "event-card" ]
                                [ h3 [] [ text event.title ]
                                , div [] [ text (event.date) ]
                                , div [] [ text ("Location: " ++ event.location) ]
                                , div [] [ text ("Price: " ++ event.price) ]
                                , div [ class "event-card__footer" ] [ button [] [ text "Buy ticket" ] ]
                                ]
                        )
                        [ { title = "Sunrise Yoga", date = "Dec 15, 2025", location = "Brighton Beach", price = "£15" }
                        , { title = "Vinyasa Flow", date = "Dec 18, 2025", location = "Yoga Studio", price = "£12" }
                        , { title = "Yoga & Brunch", date = "Dec 19, 2025", location = "Cafe Bliss", price = "£20" }
                        , { title = "Evening Meditation", date = "Dec 22, 2025", location = "Community Hall", price = "£10" }
                        , { title = "Family Yoga", date = "Dec 25, 2025", location = "Central Park", price = "£18" }
                        , { title = "New Year Yoga Retreat", date = "Jan 1-3, 2026", location = "Countryside Lodge", price = "£150" }
                        , { title = "Power Yoga", date = "Jan 5, 2026", location = "Downtown Gym", price = "£14" }
                        ]
                    )
            ]
            , div [class "editor", class (if model.editorOpen then "editor--open" else "editor--closed")]
            [
                h2 [] [ text "Public Page Editor" ]
                , Html.form []
                [
                    label [ for "page-title"] [ text "Page title"]
                    , input [ type_ "text", value model.title, onInput UpdateTitle, id "page-title" ] []
                    , label [ for "page-description"] [ text "Page description"]
                    , textarea [ value model.description, onInput UpdateDescription, id "page-description", rows 5 ] []
                    , label [ for "show-alert"] [ input [ type_ "checkbox", checked model.showAlert, onInput (always (UpdateShowAlert (not model.showAlert))), id "show-alert" ] [], text "Show alert message" ]
                    , div [class (if model.showAlert then "show" else "hide")] [
                        label [ for "alert-message"] [ text "Alert message" ]                        
                        , textarea [ value model.alertMessage, onInput UpdateAlertMessage, id "alert-message", rows 3 ] []
                    ]
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
