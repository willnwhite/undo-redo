module Main exposing (..)

import Legacy.ElmTest as ElmTest
import Check exposing (Claim, Evidence, suite, claim, that, is, for, quickCheck)
import Check.Test
import UndoListSuite
import StateMachineSuite


main : Program Never () msg
main =
    ElmTest.runSuite
        <| Check.Test.evidenceToTest evidence


evidence : Evidence
evidence =
    quickCheck suite_package


suite_package : Claim
suite_package =
    suite "Test Suite for elm-undo-redo"
        [ UndoListSuite.tests
        , StateMachineSuite.tests
        ]
