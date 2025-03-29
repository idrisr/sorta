module Params where

import Options.Applicative

newtype Params = Params {input :: FilePath}
    deriving (Show)

cmdLineParser :: IO Params
cmdLineParser = execParser opts
  where
    opts =
        info
            (parseParams <**> helper)
            (fullDesc <> progDesc "parse srt file and print text to stdout")

parseParams :: Options.Applicative.Parser Params
parseParams =
    Params
        <$> strOption
            ( metavar "<FILENAME>"
                <> short 'i'
                <> long "input"
                <> help "input file"
            )
