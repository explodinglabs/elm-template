port module Main exposing (main)

import Browser


init : () -> ( Model, Cmd Msg )
init _ =
    Nothing ->
        ( { zone = Time.utc, time = Time.millisToPosix 0, status = Failure ("Could not get route " ++ url.path) }, Cmd.none )

    Just teamId ->
        ( { zone = Time.utc, time = Time.millisToPosix 0, status = Loading }
        , Cmd.batch
            [ Task.perform GotZone Time.here
            , Task.perform GotViewport Browser.Dom.getViewport
            , Http.request
                { method = "GET"
                , headers = [ Http.header "Accept" "application/vnd.pgrst.object+json" ]
                , url = "/rest/teams?id=eq." ++ teamId ++ "&select=*,members(id,name,headline,photo,user_id)"
                , expect = Http.expectString GotTeam
                , body = Http.emptyBody
                , timeout = Nothing
                , tracker = Nothing
                }
            ]
        )


main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
