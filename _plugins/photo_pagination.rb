module Jekyll
  PHOTO_ITEMS_PER_PAGE = 24
  WALL_ITEMS_PER_PAGE = 10

  # Archivo pagination (/fotos/archivo/page/N/)
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
      @dir = "fotos/archivo/page/#{page_num}"
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'photo_page.html')
      self.data['title'] = "Archivo - Página #{page_num}"
      self.data['page_num'] = page_num
      self.data['total_pages'] = total_pages
      self.data['per_page'] = PHOTO_ITEMS_PER_PAGE
    end
  end

  # Muro pagination (/fotos/page/N/)
  class WallPaginationGenerator < Generator
    safe true
    priority :low

    def generate(site)
      photos = site.collections['photos'].docs.sort_by { |p| p.data['date'] }.reverse
      total_pages = (photos.length.to_f / WALL_ITEMS_PER_PAGE).ceil

      return if total_pages <= 1

      (2..total_pages).each do |page_num|
        site.pages << WallPage.new(site, page_num, total_pages)
      end
    end
  end

  class WallPage < Page
    def initialize(site, page_num, total_pages)
      @site = site
      @base = site.source
      @dir = "fotos/page/#{page_num}"
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'photo_wall.html')
      self.data['title'] = "Fotos - Página #{page_num}"
      self.data['page_num'] = page_num
      self.data['total_pages'] = total_pages
      self.data['per_page'] = WALL_ITEMS_PER_PAGE
    end
  end
end
