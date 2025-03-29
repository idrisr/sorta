{ mkDerivation, attoparsec, base, checkers, directory, fmt, lib
, optparse-applicative, QuickCheck, quickcheck-instances
, subtitleParser, tasty, tasty-hunit, text, time, turtle
}:
mkDerivation {
  pname = "sorta";
  version = "0.1.0.0";
  src = ./sorta;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    attoparsec base checkers directory fmt optparse-applicative
    QuickCheck quickcheck-instances subtitleParser text time turtle
  ];
  executableHaskellDepends = [
    attoparsec base checkers directory fmt optparse-applicative
    QuickCheck quickcheck-instances subtitleParser text time turtle
  ];
  testHaskellDepends = [
    attoparsec base checkers directory fmt optparse-applicative
    QuickCheck quickcheck-instances subtitleParser tasty tasty-hunit
    text time turtle
  ];
  license = lib.licenses.mit;
  mainProgram = "exe";
}
