{-# LANGUAGE OverloadedLists #-}

module Cmt.Parser.ArgumentsTest where

import Test.Tasty
import Test.Tasty.HUnit

import Cmt.Parser.Arguments (parse)
import Cmt.Types.Next       (Next (..))

test_config :: TestTree
test_config =
    testGroup
        "Cmt.Parser.Arguments"
        [ testGroup
              "single arguments"
              [ testCase "help" (assertEqual "Gives back Help" Help (parse "-h"))
              , testCase "version" (assertEqual "Gives back Version" Version (parse "-v"))
              , testCase
                    "config location"
                    (assertEqual "Gives back ConfigLocation" ConfigLocation (parse "-c"))
              , testCase "previous" (assertEqual "Gives back Previous" Previous (parse "--prev"))
              ]
        , testGroup
              "PreDefined"
              [ testCase
                    "predefined message"
                    (assertEqual
                         "Gives back PreDefined and name"
                         (PreDefined "test" [])
                         (parse "-p test"))
              , testCase
                    "predefined message plus message"
                    (assertEqual
                         "Gives back PreDefined, name and message"
                         (PreDefined "test" [("*", "a message")])
                         (parse "-p test a message"))
              ]
        , testGroup
              "Continue"
              [ testCase
                    "continue"
                    (assertEqual "Gives back empty Continue" (Continue []) (parse ""))
              , testCase
                    "continue"
                    (assertEqual
                         "Gives back Continue with message"
                         (Continue [("*", "a message")])
                         (parse "a message"))
              ]
        , testGroup
              "Dry Run"
              [ testCase
                    "previous dryn run"
                    (assertEqual "Gives back Previous" (DryRun Previous) (parse "--dry-run --prev"))
              , testCase
                    "predefined message plus message"
                    (assertEqual
                         "Gives back PreDefined, name and message"
                         (DryRun (PreDefined "test" [("*", "a message")]))
                         (parse "--dry-run -p test a message"))
              , testCase
                    "continue"
                    (assertEqual
                         "Gives back Continue with message"
                         (DryRun (Continue [("*", "a message")]))
                         (parse "--dry-run a message"))
              ]
        ]