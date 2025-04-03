# clean subtitles

## purpose
need to go from a transcript of a video file to plain text

## state: state description
stdout populated by the cleaned transcript file

## actions:
- parsefile(filename):
    file exists
    is the right type
    parsed and put to stdout

## operating principles:
- after actionname(params): idempotent

# split subtitles

## purpose
get subset of subtitles by time range. allows reading just a chapter, or getting
any time range for further use, like feeding to a llm

## state: state description

## actions:
- filter(start, end):
    start <= end

## operating principles:
