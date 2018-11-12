module Main exposing (Msg(..), main, update, view)

import Browser
import Html exposing (Html, a, button, div, h1, h2, hr, img, text)
import Html.Attributes exposing (alt, href, src)
import Html.Events exposing (onClick)
import Process
import Random
import Task


type alias Model =
    { count : Int
    , contents : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 500
      , contents = ""
      }
    , generateRandom
    )


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions

        --, subscriptions = \_ -> Sub.none
        }



{--
main =
    Browser.sandbox { init = init, view = view, update = update }
--}


type Msg
    = Increment
    | Decrement
    | DelayedHello
    | Greet String
    | GenerateRandom
    | NewCount Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }
            , Cmd.none
            )

        Decrement ->
            ( { model | count = model.count - 1 }
            , Cmd.none
            )

        DelayedHello ->
            ( { model | contents = "" }
            , taskHello model.count
            )

        Greet s ->
            ( { model | contents = s }
            , Cmd.none
            )

        GenerateRandom ->
            ( model
            , generateRandom
            )

        NewCount val ->
            ( { model | count = val, contents = "" }
            , taskHello val
            )


generateRandom =
    Random.int 1000 5000
        |> Random.generate NewCount



{--
 - https://discourse.elm-lang.org/t/how-to-use-process-sleep-in-elm-0-19/1754/6?u=kgashok
 - https://guide.elm-lang.org/effects/random.html
 --}


taskHello count =
    let
        _ =
            Debug.log "Random sleep value " count

        greeting =
            "Hello, World!"
                ++ " (slept for "
                ++ String.fromInt count
                ++ ")"
    in
    Process.sleep (toFloat count)
        |> Task.perform (always (Greet greeting))



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Counter " ]
        , div [] [ text "Counter" ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , hr [] []
        , button [ onClick DelayedHello ] [ text "Greet" ]
        , button [ onClick GenerateRandom ] [ text "Randomize and Greet" ]
        , h2 [] [ text model.contents ]
        ]
