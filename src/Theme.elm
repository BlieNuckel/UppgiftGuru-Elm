module Theme exposing (..)

import Css exposing (hex)
import Tailwind.Color as Tw
import Tailwind.Theme as Theme


lightTheme =
    { background = Tw.arbitraryRgb 250 250 250
    , onBackground = Theme.black
    , accent = Theme.blue_100
    }


darkTheme =
    { background = Tw.arbitraryRgb 5 2 1
    , onBackground = Tw.arbitraryRgb 250 250 250
    , accent = Theme.blue_100
    }
