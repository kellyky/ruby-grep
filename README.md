# `grep` — Ruby Implementation

A test-driven Ruby implementation of the classic `grep` command-line tool.

This project was completed as part of the Exercism Ruby track.

## Overview

Given a pattern (string), optional flags (array), and one or more files (array), return matching lines according to `grep` behavior.

The focus of this solution was internal state design — specifically how to structure class responsibilities, manage flags, and separate external input from internal matching logic.

## Design Notes

The exercise provided a comprehensive test suite (`grep_test.rb`), defining expected behavior and allowing flexibility in implementation.

Key design considerations included:

- Separation of input parsing and matching logic
- Encapsulation of flag behavior within instance state
- Clear distinction between external input and internal representation
- Evaluation of whether metaprogramming would improve flexibility

Flags are processed during initialization, and matching is performed per file. When multiple files are provided, output includes filenames as specified by standard `grep` behavior.

## Supported Flags

- `-n` — Prefix matching lines with line number
- `-l` — Output filename only (once per file if matches exist)
- `-i` — Case-insensitive matching
- `-v` — Invert match (non-matching lines)
- `-x` — Match entire line

## Testing

This solution was written in Ruby 3.3.0 and uses Minitest.

To run tests:

```sh
git clone git@github.com:kellyky/ruby-grep.git
cd ruby-grep
gem install minitest
ruby grep_test.rb
```

