{ mkDerivation, attoparsec, base, checkers, directory, filepath
, fmt, lib, optparse-applicative, QuickCheck, quickcheck-instances
, raw-strings-qq, subtitleParser, tasty, tasty-golden, tasty-hunit
, tasty-quickcheck, text, time, trifecta, turtle
}:
mkDerivation {
  pname = "sorta";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    attoparsec base checkers directory filepath fmt
    optparse-applicative QuickCheck quickcheck-instances subtitleParser
    tasty-golden text time trifecta turtle
  ];
  executableHaskellDepends = [
    attoparsec base checkers directory filepath fmt
    optparse-applicative QuickCheck quickcheck-instances subtitleParser
    tasty-golden text time trifecta turtle
  ];
  testHaskellDepends = [
    attoparsec base checkers directory filepath fmt
    optparse-applicative QuickCheck quickcheck-instances raw-strings-qq
    subtitleParser tasty tasty-golden tasty-hunit tasty-quickcheck text
    time trifecta turtle
  ];
  license = lib.licenses.mit;
  mainProgram = "sorta";
}
