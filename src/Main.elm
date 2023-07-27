module Main exposing (Document, main)

import Browser
import Browser.Navigation as Nav
import Css.Global
import Html as UnstyledHtml
import Html.Events exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attr
import Http
import Job exposing (Job)
import Json.Decode as JD exposing (Decoder)
import Tailwind.Breakpoints as Breakpoints
import Tailwind.Theme as Tw
import Tailwind.Utilities as Tw
import Theme
import Url



-- MAIN


type alias Document msg =
    { title : String, body : List (UnstyledHtml.Html msg) }


main =
    Browser.application
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }



-- MODEL


type Model
    = Failure
    | Loading
    | Success (List Job)


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ _ _ =
    ( Loading, getJobs )



-- UPDATE


type Msg
    = GetJobs
    | GotJobs (Result Http.Error (List Job))
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        GetJobs ->
            ( Loading, getJobs )

        GotJobs result ->
            case result of
                Ok jobs ->
                    ( Success jobs, Cmd.none )

                Err err ->
                    Debug.log (Debug.toString err)
                        ( Failure, Cmd.none )

        LinkClicked _ ->
            Debug.todo "branch 'LinkClicked _' not implemented"

        UrlChanged _ ->
            Debug.todo "branch 'UrlChanged _' not implemented"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Document Msg
view model =
    Document "UppgiftGuru"
        [ toUnstyled <|
            div
                [ Attr.css
                    [ Tw.bg_color Theme.lightTheme.background
                    , Tw.h_screen
                    , Tw.w_screen
                    ]
                ]
                [ -- This will give us the standard tailwind style-reset as well as the fonts
                  Css.Global.global Tw.globalStyles
                , div
                    [ Attr.css
                        [ Tw.mt_8
                        , Tw.flex
                        , Breakpoints.lg [ Tw.mt_0, Tw.flex_shrink_0 ]
                        ]
                    ]
                    (renderJobs model)
                ]
        ]


renderJobs : Model -> List (Html msg)
renderJobs model =
    case model of
        Failure ->
            [ text "Failed to load the week data!" ]

        Loading ->
            [ text "Loading..." ]

        Success jobs ->
            renderJobsList jobs


renderJobsList : List Job -> List (Html msg)
renderJobsList jobs =
    jobs
        |> List.map (\job -> Job.renderJob job)



-- HTTP


getJobs : Cmd Msg
getJobs =
    Http.get
        { url = "http://localhost:3000/api/tasks/week"
        , expect = Http.expectJson GotJobs jobsDecoder
        }


jobsDecoder : Decoder (List Job)
jobsDecoder =
    JD.list Job.jobDecoder
