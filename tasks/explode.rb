
#p "Loaded ~/.buildr.explode.rb"

# Buildr.application.options.trace
SYMLINK_TRACE = false

# Symbolic link tree
module Symlink #:nodoc:

  class Tree
    def initialize
      @root = Symlink::Node.new :root
    end

    # link paths to a target files or directories
    # e.g. { 'path/to/file' => '/actual/path/to/file' }
    # or   { ['path', 'to', 'file'] => '/actual/path/to/file' }
    def link(hash)
      hash.each do |path, target|
        path = path.split('/') if path.is_a?(String)
        @root.add path, target
      end
    end

    def print
      @root.print
    end

    def symlink!(base)
      print
      @root.symlink! base
    end
  end

  class Node
    attr_accessor :name, :target

    def initialize(name, target=nil)
      @name = name
      @target = target
    end

    def is_file?
      @target && File.file?(@target)
    end

    def is_dir?
      @target && File.directory?(@target)
    end

    def has_children?
      @children && @children.size > 0
    end

    def children
      @children ? @children.values : []
    end

    def clear
      @children = nil
    end

    # add a symlink at "path" to "target"
    # e.g. path = ['WEB-INF', 'classes'], target = 'myproject/target/classes'
    def add(path, target)
      puts "add [#{@name}]: #{path.inspect} -> #{target}" if SYMLINK_TRACE
      fail "not an array" unless path.is_a?(Array)
      @children = {} unless @children
      name = path[0]
      existing = @children[name]
      if existing
        if path.size == 1 # terminal node
          if File.file? target
            # replace existing file or directory with file
            existing.clear if existing.has_children?
            existing.target = target
          else
            # target is a directory
            if existing.is_file?
              # overwrite existing file
              existing.target = nil
            elsif existing.is_dir?
              # merge with existing directory
              existing.expand!
            end
            for child in Dir["#{target}/*"]
              existing.add [File.basename child], child
            end
          end
        else
          # ensure path exists
          if existing.is_file?
            # existing file is discarded since it conflicts with path
            existing.target = nil
          elsif existing.is_dir?
            # merge with existing directory
            existing.expand!
          end
          existing.add path[1..-1], target
        end
      else
        if path.size == 1
          # create a new file link
          @children[name] = Symlink::Node.new name, target
        else
          # create a new dir link
          node = Symlink::Node.new name, nil
          @children[name] = node
          node.add path[1..-1], target
        end
      end
    end

    # recursively create symlinks starting from base
    def symlink!(base)
      puts "symlink! #{base.inspect}" if SYMLINK_TRACE
      if is_file? or is_dir?
        File.symlink @target, base
      else
        mkdir base
        for node in children
          node.symlink! "#{base}/#{node.name}"
        end
      end
    end

    # recursively print symlink tree
    def print(depth=0)
      if SYMLINK_TRACE
        if is_file?
          puts "#{' '*(depth*2)} #{@name} => #{@target}"
        elsif is_dir?
          puts "#{' '*(depth*2)} [#{@name}] => #{@target}"
        elsif @target
          puts "#{' '*(depth*2)} [#{@name}] => #{@target} [missing?]"
        else
          puts "#{' '*(depth*2)} [#{@name}]" if @target
        end
      end
      for node in children
        node.print depth+1
      end
    end

  protected

    # expand a directory link into multiple links to its children
    def expand!
      @children = {}
      for child in Dir["#{@target}/*"]
        name = File.basename child
        @children[name] = Symlink::Node.new name, child
      end
      @target = nil
    end

  end

end

# Monkey-patch WarTask to add an explode method
module Buildr
  module Packaging
    module Java

      class WarTask
        def explode(options) #:nodoc:
          target = options[:target]
          copy = options[:copy] or false
          fail ":target option required for explode" unless target
          symlink = file(target) do |task|
            mkdir_p target
            tree = Symlink::Tree.new
            @classes.to_a.flatten.each   { |c| tree.link "WEB-INF/classes" => c.to_s }
            @resources.to_a.flatten.each { |r| tree.link "WEB-INF/classes" => r.to_s }
            file_map = {}

            # process all includes/excludes
            @paths.each do |name, object|
              file_map[name] = nil unless name.empty?
              #puts "paths #{name} object #{object}"
              object.add_files(file_map)
            end
            # note: using "target2" because of Ruby 1.8.6 name collision fail
            file_map.each { |path, target2|
              #puts "path #{path} target #{target2}"
              tree.link(path => target2)
            }

            unless @libs.nil? || @libs.empty?
              # Make sure artifacts are downloaded
              Buildr.artifacts(@libs).each { |a| a.invoke }

              # Symlink library dependencies
              Buildr.artifacts(@libs).map(&:to_s).uniq.each do |a|
                tree.link ["WEB-INF", "lib", File.basename(a)] => a.to_s
              end
            end

            rm_rf target
            if copy
              tree.copy! target
            else
              tree.symlink! target
            end
          end
          t = task "explode" => [@prerequisites, symlink].flatten
          puts "explode task #{t.inspect}" if SYMLINK_TRACE
          t
        end

      end
    end
  end
end

