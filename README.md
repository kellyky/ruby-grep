# `grep` | About
Global Regular Expression Print. Given a pattern (string) to search, optional flags (array), and 1+ files (array), return lines that match that criteria.

Ruby `grep` code by me; tests by Exercism. [Exercism's Grep exercise](https://exercism.org/tracks/ruby/exercises/grep).

Note: This code is a solution to a coding exercise. I have not attempted to make it usable as a tool beyond that. (Yet! Never say never.)

### Approach
Exercism provided the test file--i.e. a starting point for how to structure my solution.

In `grep_test.rb`, `Grep.grep(pattern, flags, files)` is called for every test. The three arguments are always a string, array, and an array, respectively. In other words, lots of freedom to choose how to structure my solution. 💪

My focus in this exercise is the internal vs external state. To that end, what should the class level know? What should the instance know right after initialization, before we get to any pattern matching?

#### Iteration 1
The pattern and flags apply to all files checked. I created attributes corresponding to each falg. 

So first step: ininitialize with `flags` and `pattern`. Loop through flags-related-attributes, setting each to `true` or `false` depending on flags passed. Then, the `pattern` is updated if flag passed for case insensitive (`'-i'`) or complete line match (`'-x'`).  

Next step: files. Loop through each file, passing the file and number of files to the instance method `grep`. This is where the matching for each file takes place. If file count is more than 1, `self.file_name_needed` is set to `true`.

Files with matches get joined with newline.


## Flags | Expected behavior
- `-n`  Line number and colon preceding each matched line. Follows filename (if present).
- `-l`  Output filename only--and once only--if file contains at lesaet 1 matching line.
- `-i`  Case-insensitive match.
- `-v`  Lines without a match. Like an invert.
- `-x`  Complete match: pattern must match entire line.

When multiple files have matching lines, lines begin with filename and colon. 

## Testing
You'll need Ruby and minitest. Exercise written with `ruby 3.3.0`. Instructions assume you have Ruby. 

1. Download or clone repository `git clone git@github.com:kellyky/ruby-grep.git`
2. Navigate to repository
4. `gem install minitest`
5. Run `ruby grep_test.rb`
