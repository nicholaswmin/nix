require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'optparse', '~> 0.4.0', require: true
  gem 'webrick', '~> 1.8.2', require: true
  gem 'kramdown', '~> 2.4.0', require: true
  gem 'kramdown-parser-gfm', '~> 1.1.0', require: true
  gem 'rouge', '~> 4.4.0', require: true
  gem 'logger', '~> 1.6.0', require: false
end

GREEN = ENV['NO_COLORS'] ? "" : "\e[0;32m"; RESET = "\u001b[0m";

class MarkdownPage < HTMLPage
  def initialize path, markdown, title = nil
    super(path:, title: title ? title : to_title(markdown))
    @markdown = markdown
  end
  
  def render ctx
    super(ctx) + Kramdown::Document.new(@markdown, {
      input: 'GFM', auto_ids: true,
      syntax_highlighter: 'rouge'
    }).to_html
  end
  
  private def to_title markdown
    markdown.lines.first&.start_with?('# ') ? 
      markdown.lines.first[2..-1].strip : 
      'Untitled'
  end
end

class Page < MarkdownPage 
  def initialize path, markdown
    super "/#{path.basename(path.extname)}/index.html", markdown
  end
end

class Post < MarkdownPage
  attr_reader :date, :link
  
  def initialize path, markdown
    @date = Date.parse(markdown.lines[2]&.strip || '') rescue Date.today
    @link = "/posts/#{path.basename(path.extname)}"
    super "/posts/#{path.basename(path.extname)}/index.html", markdown
  end
  
  def render ctx
    super(ctx) + '<link rel="stylesheet" href="/public/highlight.css"><link>'
  end
end

class Index < MarkdownPage 
  def initialize path, markdown
    super path + '/index.html', markdown, 'Home'
  end

  def render ctx
    ispost = -> item do item.class.to_s == 'Post' end

    super(ctx) + to_list(ctx[:pages].filter(&ispost), -> list, post { 
      list << post = <<~BODY
      <li>
        <a href="#{post.link}">
          <h3>#{post.title}</h3> 
          <small>
            <time datetime="#{post.date}">
                #{post.date.strftime('%b, %Y')}
            </time> 
         </small>
        </a>
      </li>
      BODY
    })
  end

  private def to_list items, to_list_item
    list = <<~BODY.squeeze("\n")
      <ul class="list">
        #{items.reduce('',&to_list_item)}
      </ul>
    BODY
  end
end

# --- Builder ---- 

def build config
  base = config['base']
  dest = config['dest']

  to_type = -> type do -> path do type.new(path, File.read(path)) end end
  to_file = -> dest do -> page do
      path = Pathname File.join dest, page.path
      FileUtils.mkdir_p path.dirname
      File.write(path, page.data); puts "- wrote: #{path}"   
    end
  end
    
  site = Site
    .new(Pathname.glob('_layouts/*.html', base:).map(&to_type[Layout]))
    .add(Pathname.glob('posts/*[^index]*.md', base:).map(&to_type[Post]))
    .add(Pathname.glob('pages/*[^index].md', base:).map(&to_type[Page]))
    .add(Pathname.glob('posts/index.md', base:).map(&to_type[PostIndex]))
    .add(Pathname.glob('pages/index.md', base:).map(&to_type[Index]))
    .compile(variables: config) 
  
  FileUtils.rm_rf(Dir[dest])   
  site.pages.map(&to_file[dest])
  FileUtils.cp_r(File.join(base, 'public/'), File.join(dest, 'public'))

  puts "#{GREEN} init:ok, output: #{dest} #{RESET}"
end

# --- Program Main -----

build YAML.load_file './_config.yml'
