module Jekyll
  class CameraPage < Page
    def initialize(site, base, camera, photos)
      @site  = site
      @base  = base
      @dir   = File.join('camaras', Jekyll::Utils.slugify(camera, mode: 'latin'))
      @name  = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'camera_page.html')
      self.data['camera']        = camera
      self.data['title']         = camera
      self.data['camera_photos'] = photos.sort_by { |p| -p.data['date'].to_i }
    end
  end

  class CameraPageGenerator < Generator
    safe true

    def generate(site)
      cameras = Hash.new { |h, k| h[k] = [] }
      site.collections['photos'].docs.each do |photo|
        camera = photo.data['camera']
        next if camera.nil? || camera.strip.empty?
        cameras[camera] << photo
      end

      cameras.each do |camera, photos|
        site.pages << CameraPage.new(site, site.source, camera, photos)
      end
    end
  end
end
