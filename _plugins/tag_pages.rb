module Jekyll
  class TagPage < Page
    def initialize(site, base, tag, posts)
      @site  = site
      @base  = base
      @dir   = File.join('tagged', Jekyll::Utils.slugify(tag, mode: 'latin'))
      @name  = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag_page.html')
      self.data['tag']       = tag
      self.data['title']     = tag
      self.data['tag_posts'] = posts.sort_by { |p| -p.date.to_i }
    end
  end

  class TagPageGenerator < Generator
    safe true

    def generate(site)
      site.tags.each do |tag, posts|
        site.pages << TagPage.new(site, site.source, tag, posts)
      end
    end
  end
end
