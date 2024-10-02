# Given a pattern (string), flags (array) and files (array), return the specififed match.
# What each flag means:
#   -n  Prepend line number and colon `:` to each line in the output, placing the number AFTER the filename (if present)
#   -l  Output only names of files that contain at least one matching line
#   -i  Match line using case-insensitive comparison
#   -v  Return all lines that *fail* to match. Like an invert
#   -x  Search only for lines where search string ('pattern') matches the entire line

class Grep

  FLAGS = {
    '-n' => :line_number_needed,
    '-l' => :file_name_only,
    '-i' => :case_insensitive,
    '-v' => :invert_match,
    '-x' => :complete_line_match,
  }

  private_constant :FLAGS

  def self.grep(pattern, flags, files)
    instance = new(flags, pattern, files.count > 1)

    files.map { |file| instance.grep(file) }.reject(&:empty?).join("\n")
  end

  private

  attr_reader :file_name_needed

  attr_accessor :pattern,
              :case_insensitive,
              :line_number_needed,
              :file_name_only,
              :invert_match,
              :complete_line_match

  alias case_insensitive? case_insensitive
  alias line_number_needed? line_number_needed
  alias file_name_only? file_name_only
  alias invert_match? invert_match
  alias complete_line_match? complete_line_match
  alias file_name_needed? file_name_needed

  def initialize(flags, raw_pattern, multiple_files)
    @file_name_needed = multiple_files
    self.pattern = raw_pattern

    # Set attributes corresponding to flags passed to true
    update_flag_attributes(flags)
    # Update pattern if needed (e.g. flag -i, -v)
    update_pattern if case_insensitive? || complete_line_match?
  end

  def update_flag_attributes(flags)
    flags.each { |flag| send("#{FLAGS[flag]}=", true) }
  end

  def update_pattern
    self.pattern = case_insensitive? ? /#{pattern}/i : /^#{pattern}$/
  end

  def file_lines(file)
    File.open(file).readlines(chomp: true)
  end

  def matches_pattern?(line)
    invert_match? ? !line.match?(pattern) : line.match?(pattern)
  end

  def format_line(file, number, line)
    file_name = file_name_needed? ? "#{file}:" : ''
    line_number = line_number_needed? ? "#{number}:" : ''
    file_name + line_number + line
  end

  public

  def grep(file_name)
    file_lines(file_name).each_with_object([]).with_index do |(line, lines), i|
      next unless matches_pattern?(line)

      lines << if file_name_only?
                 next if lines.include?(file_name)

                 file_name
               else
                 format_line(file_name, i + 1, line)
               end
    end.join("\n")
  end

end
