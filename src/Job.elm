module Job exposing (..)

import Html.Styled exposing (..)
import Json.Decode as JD exposing (Decoder, nullable, string)
import Json.Decode.Extra as JDE
import Json.Decode.Pipeline exposing (optional, required)
import Time


type JobStatus
    = Unassigned
    | Assigned
    | Done


type JobRepetition
    = None
    | Daily
    | Weekly


type alias Job =
    { time : String
    , subjectId : String
    , taskDescription : String
    , assignee : Maybe String
    , status : JobStatus
    , repeat : JobRepetition
    , startDate : Time.Posix
    , endDate : Maybe Time.Posix
    , searchTag : Maybe String
    }



-- VIEW


renderJob : Job -> Html msg
renderJob job =
    div [] []



-- JSON


jobDecoder : Decoder Job
jobDecoder =
    JD.succeed Job
        |> required "time" string
        |> required "subjectId" string
        |> required "taskDescription" string
        |> optional "assignee" (nullable string) Nothing
        |> required "status" jobStatusDecoder
        |> required "repeat" jobRepititionDecoder
        |> required "startDate" JDE.datetime
        |> required "endDate" (nullable JDE.datetime)
        |> required "searchTag" (nullable string)


jobStatusDecoder : Decoder JobStatus
jobStatusDecoder =
    string
        |> JD.andThen
            (\str ->
                case str of
                    "Unassigned" ->
                        JD.succeed Unassigned

                    "Assigned" ->
                        JD.succeed Assigned

                    "Done" ->
                        JD.succeed Done

                    _ ->
                        JD.fail "Invalid job status value!"
            )


jobRepititionDecoder : Decoder JobRepetition
jobRepititionDecoder =
    string
        |> JD.andThen
            (\str ->
                case str of
                    "None" ->
                        JD.succeed None

                    "Daily" ->
                        JD.succeed Daily

                    "Weekly" ->
                        JD.succeed Weekly

                    _ ->
                        JD.fail "Invalid job repitition value!"
            )
