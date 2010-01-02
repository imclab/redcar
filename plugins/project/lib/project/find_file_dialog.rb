module Redcar
  class Project
  
    class FindFileDialog < FilterListDialog
      MAX_ENTRIES = 20
      
      def update_list(filter)
        paths = find_files(filter, Redcar.app.focussed_window.treebook.trees.last.tree_mirror.path)
        @last_list = paths
        paths.map {|path| display_path(path) }
      end
      
      def selected(text, ix)
        close
        FileOpenCommand.new(@last_list[ix]).run
      end
      
      private
      
      def display_path(path)
        path.split("/").last + 
          " (" + 
          path.split("/")[-3..-2].join("/") + 
          ")"
      end
      
      def find_files(text, directories)
        files = []
        s = Time.now
        directories.each do |dir|
          files += Dir[File.expand_path(dir + "/**/*")]
        end
        took = Time.now - s
       
        re = make_regex(text)

        score_match_pairs = []
        cutoff = 10000000

        results = files.each do |fn| 
          unless File.directory?(fn)
            bit = fn.split("/")
            if m = bit.last.match(re)
              cs = []
              diffs = 0
              m.captures.each_with_index do |_, i|
                cs << m.begin(i + 1)
                if i > 0
                  diffs += cs[i] - cs[i-1]
                end
              end
              # lower score is better
              score = (cs[0] + diffs)*100 + bit.last.length
              if score < cutoff
                score_match_pairs << [score, fn]
                score_match_pairs.sort!
                if score_match_pairs.length == MAX_ENTRIES
                  cutoff = score_match_pairs.last.first
                  score_match_pairs.pop
                end
              end
            end
          end
        end
        score_match_pairs.map {|a| a.last }
      end

      def make_regex(text)
        re_src = "(" + text.split(//).map{|l| Regexp.escape(l) }.join(").*?(") + ")"
        Regexp.new(re_src)
      end
    end
  end
end