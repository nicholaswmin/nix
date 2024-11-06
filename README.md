# blog

> generated by [nix][nix]

### build

add your posts as [markdown][gfm] files in `posts/` then:

> output `html` in `/build`

```bash
ruby nix.rb --build
```

## publish

Just push to your repository. 

The custom action will get triggered & publish via [Github Pages][gh-pages].  

Assuming your Github username is: `foo` and the repository name is `bar`,  
you'd visit: [https://foo.github.io/bar](https://foo.github.io/bar)

## usage 

It's like [Jekyll][jekyll]. You write [Github-flavored Markdown][gfm].

> inc. syntax highlighting for 150 languages via [`pygments`][pygments]

- Add posts in `posts/`
- Add pages in `pages/`

... each Post *must* have a:

- `# <post-title>` on the 1st line
- `empty line` on the 2nd
- `<date>` on the 3rd, ie. `2024-10-18`

... for example:

```markdown
# Lorem Ipsum


2024-12-20

> A sentence should contain no unnecessary words, a paragraph no unnecessary 
> sentences, for the same reason that a drawing should have no unnecessary lines 
> and a machine no unnecessary parts. This requires not that the writer make all 
> his sentences short, or that he avoid all detail and treat his subjects only 
> in outline, but that every word tell

The Elements of Style by William Strunk Jr (1918) ...
```

  additionally:

- images go in `public/`, 
- css are in `public/style.css`
- configuration is in `_config.rb`

> **note:** you must use the `{{root_url}}` token
> when referencing assets, like so:
> 
> good: `<img src="{{root_url}}felix.svg"></img>`
> bad : `<img src="/public/felix.svg"></img>`
> bad : `<img src="/felix.svg"></img>`

this is because of the known Github quirk of not being  
actually hosted on the root itself unless the repository   
is named exactly as your `<username>`. 
Jekyll does this with a rewrite-url plugin, nix does it by default.  

The same can work in code using the `root_url` attribute,   
in case you're extending `nix`:
  
```ruby
class CustomPage < HTMLPage
  # omitted for brevity ..

  def render(ctx)
    "#{super}<link rel=\"stylesheet\" href=\"#{root_url}highlight.css\"><link>"
  end
end
```

## serve locally

```bash
ruby --serve 8081
```

[nix]: https://github/com/nicholaswmin/nix
[club]: https://1kb.club/
[ruby]: https://ruby-doc.org/3.3.4/
[jekyll]: https://jekyllrb.com/
[gh-pages]: https://pages.github.com/
[gfm]: https://github.github.com/gfm/
[pygments]: https://pygments.org/
[file-rb]: https://github.com/nicholaswmin/nix/blob/main/nix.rb




  <!---d
---
# This file contains the necessary data 
# for creating a sample blog site.
# 
# When the `--init` flag is passed, it: 
#
# - searches for file: `init.yml` locally, in the current working directory.
# - if not found, it attempts to download it from the repo. (raw)
# - It then iterates through the keys and creates a file for each.
# - each key is a filename. The file contents are listed under each key.

- .gitignore: |
    _config.yml
    _layouts
    posts
    pages
    public
    build

    .DS_Store
    scratch

- _config.yml: |
    # Site configuration
    # note: these key/values can also be used as substitutions.
    # i.e: {{author_name}} in a Post will be replaced with "John Doe"

    # required
    name: 'John Does blog'
    description: 'a blog about rabbits'
    favicon: 🐇
    # must match static.yml workflow value:
    dest: './build'

    # optional

    author_name: 'John Doe'
    author_user: 'nicholaswmin'
    author_city: 'London, W2'


- .github/workflows/static.yml: |
    name: Deploy static HTML to Pages
    
    on:
      push:
        branches: [$default-branch, 'refactor-b']
    
      # allow manual runs from the Actions tab
      workflow_dispatch:
    
    permissions:
      contents: read
      pages: write
      id-token: write
    
    concurrency:
      group: "pages"
      cancel-in-progress: false
    
    jobs:
      deploy:
        environment:
          name: github-pages
          url: ${{ steps.deployment.outputs.page_url }}
        runs-on: ubuntu-latest
        steps:
          - name: Checkout
            uses: actions/checkout@v4
    
          - name: Setup Ruby 3.3.5
            uses: ruby/setup-ruby@v1
            with:
              ruby-version: '3.3.5'

          - name: Setup Pages
            uses: actions/configure-pages@v5
    
          - name: Fetch init site assets
            run: ruby nix.rb -i https://raw.githubusercontent.com/nicholaswmin/nix/8e50218e5a219c260b4d4e3e43c97ef91682227c/init.yml
            
          - name: Compile Pages
            run: ruby nix.rb
    
          - name: Upload artifact
            uses: actions/upload-pages-artifact@v3
            with:
              # must match value of `_config.yml`:`dest`
              path: './build'
          - name: Deploy to GitHub Pages
            id: deployment
            uses: actions/deploy-pages@v4
- README.md: |
    # blog

    > generated by [nix][nix]

    ### build

    add your posts as [markdown][gfm] files in `posts/` then:

    > output `html` in `/build`

    ```bash
    ruby nix.rb --build
    ```

    ## publish

    Just push to your repository. 

    The custom action will get triggered & publish via [Github Pages][gh-pages].  

    Assuming your Github username is: `foo` and the repository name is `bar`,  
    you'd visit: [https://foo.github.io/bar](https://foo.github.io/bar)

    ## usage 

    It's like [Jekyll][jekyll]. You write [Github-flavored Markdown][gfm].

    > inc. syntax highlighting for 150 languages via [`pygments`][pygments]

    - Add posts in `posts/`
    - Add pages in `pages/`

    ... each Post *must* have a:

    - `# <post-title>` on the 1st line
    - `empty line` on the 2nd
    - `<date>` on the 3rd, ie. `2024-10-18`

    ... for example:

    ```markdown
    # Lorem Ipsum


    2024-12-20

    > A sentence should contain no unnecessary words, a paragraph no unnecessary 
    > sentences, for the same reason that a drawing should have no unnecessary lines 
    > and a machine no unnecessary parts. This requires not that the writer make all 
    > his sentences short, or that he avoid all detail and treat his subjects only 
    > in outline, but that every word tell

    The Elements of Style by William Strunk Jr (1918) ...
    ```

      additionally:

    - images go in `public/`, 
    - css are in `public/style.css`
    - configuration is in `_config.rb`

    > **note:** you must use the `{{root_url}}` token
    > when referencing assets, like so:
    > 
    > good: `<img src="{{root_url}}felix.svg"></img>`
    > bad : `<img src="/public/felix.svg"></img>`
    > bad : `<img src="/felix.svg"></img>`

    this is because of the known Github quirk of not being  
    actually hosted on the root itself unless the repository   
    is named exactly as your `<username>`. 
    Jekyll does this with a rewrite-url plugin, nix does it by default.  
  
    The same can work in code using the `root_url` attribute,   
    in case you're extending `nix`:
      
    ```ruby
    class CustomPage < HTMLPage
      # omitted for brevity ..

      def render(ctx)
        "#{super}<link rel=\"stylesheet\" href=\"#{root_url}highlight.css\"><link>"
      end
    end
    ```
    
    ## serve locally

    ```bash
    ruby --serve 8081
    ```

    [nix]: https://github/com/nicholaswmin/nix
    [club]: https://1kb.club/
    [ruby]: https://ruby-doc.org/3.3.4/
    [jekyll]: https://jekyllrb.com/
    [gh-pages]: https://pages.github.com/
    [gfm]: https://github.github.com/gfm/
    [pygments]: https://pygments.org/
    [file-rb]: https://github.com/nicholaswmin/nix/blob/main/nix.rb

- _layouts/header.html: |
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="{{description}}">
        <link rel="icon" href="data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'><text x='0' y='14'>{{favicon}}</text></svg>">
        <link rel="stylesheet" href="{{root_url}}style.css">
        <title>{{title}}</title>
    </head> 

    <nav>
        <ul>
        <li><a href="{{root_url}}">posts</a></li>
        <li><a href="{{root_url}}about">CV</a></li>
        </ul>
    </nav>

- _layouts/footer.html: |
    <footer>
        <small> > <a href="https://1kb.club/">{{bytes}} bytes</a> </small>
    </footer>

- pages/index.md: |
    hello world

- pages/about.md: |
    CV

    {{author_name}}
    [{{author_user}}][author-url]
    {{author_city}}

    - ### ACME Industries
        #### 2015 - now  
        #### London, United Kingdom

    - ### Foo/Bar GmbH
        #### Dec 22' - May 23'
        #### Munich, Germany

    - ### Ski Instructor
        #### Dec 22' - May 23'
        #### Rhône-Alpes, France

    - ### Looney Tunes LLC
        #### Dec 16' - Nov 20'
        #### Madrid, Spain

    - ### The Animaniacs LLC
        #### Jun 14' - Apr 15'
        #### New York, USA  

    ## Schools

    - ### University of Westminster
        #### BSc Information Systems
        #### London, UK  
        #### 2009 - 2013

    [author-url]: https://github.com/{{author_user}}

- pages/sample.md: |
    ## sample

    This is a sample `Page`; i.e: not a `Post`.   

    It's is written in `Markdown` but doesn't support    
    code syntax highlighting nor is it included in any Post lists.   

    You can add as many as you want within this folder.    
    Just like a `Post`, it requires an `h2` header at the top.

- posts/whats-this.md: |
    # whats this?

    21-10-2021

    This is a sample post, written in [github-flavored markdown][gfm].

    It's generated using a minimal static-site generator, 
    called [nix][nix], which itself is ~150 lines of [ruby][ruby] code.

    Here's how it renders:

    This is a footnote[^1]

    A horizontal ruler follows:

    ---

    ## This is an h2 header

    ### This is an h3 header

    #### This is an h4 header

    ... and this is a blockquote:

    > A sentence should contain no unnecessary words, a paragraph no unnecessary 
    > sentences, for the same reason that a drawing should have no unnecessary 
    > lines and a machine no unnecessary parts. This requires not that the writer 
    > make all his sentences short, or that he avoid all detail and treat his 
    > subjects only in outline, but that every word tell.

    From [The Elements of Style][eos], [William Strunk][ws]


    ## Syntax highlighting

    posts include syntax highlighting, via [pygments][pyg]:

    Javascript

    ```js
    let fact = 1

    for (i = 1; i <= number; i++)
      fact *= i

    console.log(`The factorial of ${number} is ${fact}.`)
    ```

    Ruby


    ```ruby
    a = [:foo, 'bar', 2]

    a.reverse_each do |element| 
    puts "#{element.class} #{element}" 
    end
    ```

    Bash

    ```bash
    #!/bin/bash

    i=1
    while [[ $i -le 10 ]] ; do
    echo "$i"
    (( i += 1 ))
    done
    ```

    ## More

    this is a list:

    - Oranges
    - Apples
    - Peaches

    ... and this is an SVG image of **Felix The Housecat**:


    ![Felix the Housecat, the cartoon]({{root_url}}felix.svg "Felix the Housecat")

    This project was inspired by: The [1kb club][1kb].


    ### Footnotes


    [^1]: Garner, Bryan A. (2009). Garner on Language and Writing: Selected Essays z
        and Speeches of Bryan A. Garner. Chicago: American Bar Association. p. 295. 
        ISBN 978-1-60442-445-4.


    [1kb]: https://1kb.club/
    [bp]: https://en.wikipedia.org/wiki/Blaise_Pascal
    [eos]: https://en.wikipedia.org/wiki/The_Elements_of_Style
    [ws]: https://en.wikipedia.org/wiki/William_Strunk_Jr.
    [ruby]: https://www.ruby-lang.org/en/
    [nix]: https://github.com/nicholaswmin/nix
    [pyg]: https://pygments.org/
    [gfm]: https://github.github.com/gfm/

- posts/another-post.md: |
    # just another post

    21-11-2020

    This is another sample post, written in **Markdown**.

    You can add as many as you want in this folder but ensure each post:

    - has an `h1` heading at the very top
    - has an empty line following it
    - and a date on the 3rd line

    ... just like this post.

- public/style.css: |
    /* tweak this to your preference. */ 
    
    /* theme */
    
    :root {
      --bg-color: #fafafa; 
      --bg-color-full: #fff;
      --primary-color: #00695C;
      --secondary-color: #3700B3;
      --font-color: #555; 
      --font-color-lighter: #777;
      --font-color-lightest: #ccc;
      --font-size: 14px; 
    }
    
    /* layout */
    
    * { 
      font-family: monospace; font-size: var(--font-size);
      font-weight:normal; text-decoration: none;
    }
    
    body { 
      /* must fit exactly 80-chars in code snippets */
      max-width: 110ex; margin: 1em auto; padding: 0 1em;
      background: var(--bg-color); color: var(--font-color); 
      overflow-y: scroll;
    }
    body::selection { background: var(--font-color-lightest); }
    main { padding: 1.5em 0; }
    img { margin: 2em 0; max-width: 100%; }
    
    /* typography */
    
    p { padding: 1em 0; }
    a { color: var(--primary-color); font-size: inherit; }
    a:hover { color: var(--link-color-hover);  }
    blockquote { font-style: italic; }
    blockquote > p { display:inline; }
    
    h1, h2, h3, h4, h5, p, blockquote, pre { line-height: 1.5; padding: 0.5em 0; }
    h1 { font-size: 1.75em; } h2 { font-size: 1.5em; } h3 { font-size: 1.25em;  }
    h4, h4 *, small, small * { font-size: 0.9em; color: var(--font-color-lighter); }
    h1, h2, h3 { margin: 1.5em 0 1em 0; }
    h1, h2 { border-bottom: 1px solid var(--font-color-lightest); }
    
    /* lists */
    
    ul { 
      display: block; padding-left: 1em; margin: 2em 0; list-style-type: '- ';
      h1, h2, h3, h4, h5, h6 { margin: 0; padding: 0.25em 0; } 
      h3 { color: var(--primary-color); }
      li { margin: 1em 0; }
    }
    
    /* navigation */
    
    nav, footer {
      padding: 1em 0;s
      ul { display: block; margin: 0; padding-left: 0; }
      li { display: inline-block; margin-right: 2em;  }
      li a { color: var(--font-color); }
      small { display: inline-block; margin-top: 2em; }
    }
    
    /* printer */
    
    @media print { 
      body { width: auto; } 
      nav, footer { display: none; }
    }
    
    /* post page */
    
    .post { 
      h1:first-of-type, 
      h2:first-of-type { margin-bottom: 0; }
      code { 
        padding: 2px 6px; border-radius: 0; font-size: 1em; 
        background: var(--font-color-lightest); 
      }
      
      pre {
        font-size: 1.1em; padding: 2em; border-radius: 6px;
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.24); word-wrap: break-word;
        background: var(--bg-color-full);
        code { 
          display: block; background: var(--bg-color-full);
          white-space: break-spaces; 
        }
      }
          
      blockquote { 
        background: none;
        border-left: 2px solid var(--font-color-lightest);
        border-radius: 0; margin: 2em 0; padding: 1em; font-style: normal;
        p { color: var(--font-color-lighter); }
      }
      
      hr { 
        margin: 2.5em 0 2.5em 0; border: 0.5px solid;
        border-color: var(--font-color-lightest);
      }
    
      .footnotes { margin-top: 2em; }
    }

- public/felix.svg: |
    <svg xmlns="http://www.w3.org/2000/svg" xml:space="preserve" viewBox="0 0 595 654"><style>.st1{fill:#fff}</style><path id="Warstwa_2" d="M493 481c-7-3-19-4-36 3l-35-17c99 4 208-177 128-202 0 0-23-7-40 7-26 21 4 123-89 144 0 0 8-24-15-48l55-31s1-37-2-47l-98-9s24-18 33-49c0 0 20-21 35-28 0 0-13-10-21-9l27-34c-30-27-56-75-66-145 0 0-4-5-9-1-5 3-36 44-53 48s-30-5-72 4c0 0-33-25-37-40-9-9-12 3-12 3s-3 52-8 57l-21 21-8-18s7-16 19-18l-17-33s-16 5-29 22c-13-19-26-32-36-34-2-1-7-2-12 0s-8 7-9 9c0 0-10-9-16-4-6 4-13 22-5 34 0 0-30-10-5 66 7 17 21 48 59 51l107 149 7-10c4-5 10-7 13-9 2 1 6 3 10 3h10l4 1 4 3-2 3s-9-6-17-5c-8 0-21 2-27 21 0 0-16 0-28 18-13 17-34 48-17 61s33-4 33-4 6 39 45 33c0 0-9 2 0 17l-19 16s-11-52-59-34-44 160 36 171c62 1 57-41 57-41l60-52s24 3 35-1l62 37s-33 84 56 84c5 0 21-1 33-10 42-28 33-136-8-153zM354 340l-5-14 18 1-13 13z"/>  <g id="Warstwa_3">    <path d="M158 224c2 11 7 36 26 57 11 12 23 19 33 25 9 5 14 6 18 7 8 2 15 0 27-2 6-1 98-17 113-74 0-6-1-15-7-21-10-10-32-10-51 6-7 4-18 9-31 10-7 1-27 2-39-11l-4-6-3-2-49 9-8-1s-8 9-25 3zm28-116c-7 5-17 22-24 41-8 25-10 63 4 69 4 2 11 1 20-5 10-4 12-6 20-8 7-2 8-8 8-8s15-56 13-70c-1-15-4-21-9-24-12-8-24-1-32 5z" class="st1"/><path d="m221 196 8-41 5-24c4-9 8-21 19-30 9-8 18-11 23-12 4-1 20-4 38 3 26 9 36 40 35 64-2 28-20 46-25 50-4 5-22 21-46 20-10-1-29-4-31-14-3-11-14-1-14-1l-14-5 2-10z" class="st1"/>  </g>  <g id="Warstwa_4"><path d="M188 236c-7-8-6-21-1-29 8-11 23-11 30-11 7 1 15 1 20 7 6 8 4 19 0 26-8 14-26 15-28 15-4 0-14 0-21-8z"/><path d="M177 242c6 7 25 26 55 31 51 8 79-22 88-37l-5-1c-6-1-11 1-14 2-2-2 24-14 38 7 0 0-9-7-12-6 0 0-37 50-76 50s-68-32-74-38l5 11c0 1-4 7-5 3s-6-21-2-26c2-1 2 4 2 4z"/> </g> <g id="Warstwa_5"><path d="M212 249s-2 1 1 6 4 8 6 7-5-14-7-13z"/><path fill="none" stroke="#000" stroke-linecap="round" stroke-miterlimit="10" stroke-width="3" d="M344 220 478 82M353 221l139-115M134 227l-49-15m61 32-58-3"/></g><g id="Warstwa_6"><ellipse cx="336" cy="149.3" rx="12" ry="25.4" transform="rotate(12 336 149)"/><ellipse cx="213.3" cy="154.7" rx="12" ry="25.4" transform="rotate(12 213 155)"/></g></svg>

- public/highlight.css: |
    /*
     * Syntax Highlighting CSS (Pygments)  
     * Autogenerated by Rouge Gem using: 
     *
     * puts Rouge::Themes::Github.mode(:light).render(scope: '.highlight') 
     */

    .highlight table td{padding:5px}.highlight table pre{margin:0}.highlight,.highlight .w{color:#24292f;background-color:#f6f8fa}.highlight .k,.highlight .kd,.highlight .kn,.highlight .kp,.highlight .kr,.highlight .kt,.highlight .kv{color:#cf222e}.highlight .gr{color:#f6f8fa}.highlight .gd{color:#82071e;background-color:#ffebe9}.highlight .nb,.highlight .nc,.highlight .nn,.highlight .no{color:#953800}.highlight .na,.highlight .nt,.highlight .sr{color:#116329}.highlight .gi{color:#116329;background-color:#dafbe1}.highlight .ges{font-weight:700;font-style:italic}.highlight .bp,.highlight .il,.highlight .kc,.highlight .l,.highlight .ld,.highlight .m,.highlight .mb,.highlight .mf,.highlight .mh,.highlight .mi,.highlight .mo,.highlight .mx,.highlight .ne,.highlight .nl,.highlight .nv,.highlight .o,.highlight .ow,.highlight .py,.highlight .sb,.highlight .vc,.highlight .vg,.highlight .vi,.highlight .vm{color:#0550ae}.highlight .gh,.highlight .gu{color:#0550ae;font-weight:700}.highlight .dl,.highlight .s,.highlight .s1,.highlight .s2,.highlight .sa,.highlight .sc,.highlight .sd,.highlight .se,.highlight .sh,.highlight .ss,.highlight .sx{color:#0a3069}.highlight .fm,.highlight .nd,.highlight .nf{color:#8250df}.highlight .err{color:#f6f8fa;background-color:#82071e}.highlight .c,.highlight .c1,.highlight .cd,.highlight .ch,.highlight .cm,.highlight .cp,.highlight .cpf,.highlight .cs,.highlight .gl,.highlight .gt{color:#6e7781}.highlight .ni,.highlight .si{color:#24292f}.highlight .ge{color:#24292f;font-style:italic}.highlight .gs{color:#24292f;font-weight:700}
-->
