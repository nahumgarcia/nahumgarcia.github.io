module Jekyll
  ITEMS_PER_PAGE = 6
  PHOTO_ITEMS_PER_PAGE = 24

  # Photo feed pagination (/photos/page/N/)
  class PhotoPaginationGenerator < Generator
    safe true
    priority :low

    def generate(site)
      photos = site.collections['photos'].docs.sort_by { |p| p.data['date'] }.reverse
      total_pages = (photos.length.to_f / PHOTO_ITEMS_PER_PAGE).ceil

      return if total_pages <= 1

      (2..total_pages).each do |page_num|
        site.pages << PhotoPage.new(site, page_num, total_pages)
      end
    end
  end

  class PhotoPage < Page
    def initialize(site, page_num, total_pages)
      @site = site
      @base = site.source
      @dir = "fotos/page/#{page_num}"
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'photo_page.html')
      self.data['title'] = "Fotos - Página #{page_num}"
      self.data['page_num'] = page_num
      self.data['total_pages'] = total_pages
      self.data['per_page'] = PHOTO_ITEMS_PER_PAGE
    end
  end

  # Home feed pagination (/page/N/)
  class HomePaginationGenerator < Generator
    safe true
    priority :low

    def generate(site)
      total = site.posts.docs.length
      total_pages = (total.to_f / ITEMS_PER_PAGE).ceil

      return if total_pages <= 1

      (2..total_pages).each do |page_num|
        site.pages << HomePage.new(site, page_num, total_pages)
      end
    end
  end

  class HomePage < Page
    def initialize(site, page_num, total_pages)
      @site = site
      @base = site.source
      @dir = "page/#{page_num}"
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'home_feed.html')
      self.data['title'] = "Página #{page_num}"
      self.data['page_num'] = page_num
      self.data['total_pages'] = total_pages
      self.data['per_page'] = ITEMS_PER_PAGE
    end
  end
end
