module Jekyll
  class AlbumPage < Page
    def initialize(site, base, tag, photos)
      @site  = site
      @base  = base
      @dir   = File.join('fotos', 'album', Jekyll::Utils.slugify(tag, mode: 'latin'))
      @name  = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'album_page.html')
      self.data['album']        = tag
      self.data['album_photos'] = photos.sort_by { |p| -p.data['date'].to_i }
    end
  end

  class AlbumPageGenerator < Generator
    safe true
    priority :low

    def generate(site)
      albums = Hash.new { |h, k| h[k] = [] }
      site.collections['photos'].docs.each do |photo|
        tags = photo.data['tags']
        next if tags.nil? || tags.empty?
        tags.each do |tag|
          next if tag.nil? || tag.to_s.strip.empty?
          albums[tag] << photo
        end
      end

      album_list = []
      albums.each do |tag, photos|
        sorted = photos.sort_by { |p| -p.data['date'].to_i }
        cover = sorted.first
        cover_src = cover.data['file'].to_s
        cover_src = "/assets/photos/#{cover_src}" unless cover_src.include?('/')
        cover_filename = cover_src.split('/').last
        cover_thumb_src = "/assets/photos/thumb/#{cover_filename}"
        slug = Jekyll::Utils.slugify(tag, mode: 'latin')

        album_list << {
          'name'            => tag,
          'slug'            => slug,
          'count'           => photos.size,
          'cover_url'       => cover_src,
          'cover_thumb_url' => cover_thumb_src,
          'cover_alt'       => cover.data['title'] || tag,
          'url'             => "/fotos/album/#{slug}/"
        }

        site.pages << AlbumPage.new(site, site.source, tag, photos)
      end

      site.data['albums'] = album_list.sort_by { |a| a['name'].downcase }
    end
  end
end
