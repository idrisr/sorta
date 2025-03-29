# Name: name [Type]

## Purpose
Need to go from a transcript of a video file to a llm prompt, so that the llm
can summarize the video

## State: state description
stdout populated by the cleaned transcript file, plus optional system prompt.

## Actions:
- parseFile(filename):
    file exists
    is the right type
    parsed and put to stdout

## Operating Principles:
- After actionName(params): idempotent
