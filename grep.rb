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
    new_grepper = new(flags, pattern, files.count > 1)

    files.map { |file| new_grepper.grep(file) }.reject(&:empty?).join("\n")
  end

  private

  attr_reader :file_name_needed

  attr_writer :pattern,
              :case_insensitive,
              :line_number_needed,
              :file_name_only,
              :invert_match,
              :complete_line_match

  def initialize(flags, raw_pattern, multiple_files)
    @file_name_needed = multiple_files
    self.pattern = raw_pattern

    # Toggle flags, update pattern if needed
    update_flag_attributes(flags)
    update_pattern if case_insensitive || complete_line_match
  end

  def update_flag_attributes(flags)
    FLAGS.each do |flag, attribute|
      send("#{attribute}=", flags.include?(flag))
    end
  end

  def update_pattern
    self.pattern = if case_insensitive
                     /#{pattern}/i
                   elsif complete_line_match
                     /\A#{pattern}\z/
                   end
  end

  def file_lines(file)
    File.open(file).readlines(chomp: true)
  end

  def match_pattern?(line)
    invert_match ? !line.match?(pattern) : line.match?(pattern)
  end

  def format_line(file, number, line)
    file_name = file_name_needed ? "#{file}:" : ''
    line_number = line_number_needed ? "#{number}:" : ''
    file_name + line_number + line
  end

  public

  attr_reader :pattern,
              :case_insensitive,
              :line_number_needed,
              :file_name_only,
              :invert_match,
              :complete_line_match

  attr_accessor :file

  def grep(file_name)
    file_lines(file_name).each_with_object([]).with_index do |(line, lines), i|
      next unless match_pattern?(line)

      lines << if file_name_only
                 next if lines.include?(file_name)

                 file_name
               else
                 format_line(file_name, i + 1, line)
               end
    end.join("\n")
  end

end
