module XLog
  class Log
    def self.parse(file, opt)
      array = []
      File.foreach(file) do |line|
        if line =~ /\b(successfully|failed)\b/
          hash = {}
          hash[:status] = line =~ /\bsuccessfully\b/ ? "success" : "fail"
          hash[:client] = line[/^\w+\b/]
          hash[:time] = line[/\d\d:\d\d:\d\d/]
          match_result = line.match(/\b\w+(\.\w+)?\s(was|failed)\b/)
          hash[:file] = match_result.to_s[/^\w+\b/]
          hash[:detail] = match_result.to_s + match_result.post_match
          array << hash
        end
      end
# REVIEW
      if opt[:status] != "all"
        array = array.select {|log| log[:status] == opt[:status]}
      end
      if opt[:client] != "all"
        array = array.select {|log| log[:client] == opt[:client]}
      end
      array
    end
  end
end
