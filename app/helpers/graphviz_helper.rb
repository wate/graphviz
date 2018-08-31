require 'digest/sha2'

module GraphvizHelper
  ALLOWED_FORMATS = {
    'png' => { type: 'png', ext: '.png', content_type: 'image/png', inline: true },
    'svg' => { type: 'svg', ext: '.svg', content_type: 'image/svg+xml', inline: true }
  }.freeze

  def self.construct_cache_key(key)
    ['graphviz', Digest::SHA256.hexdigest(key.to_s)].join('_')
  end

  def self.check_format(frmt)
    ALLOWED_FORMATS.fetch(frmt, ALLOWED_FORMATS['png'])
  end

  def self.graphviz_file(name, extension)
    File.join(Rails.root, 'files', "#{name}#{extension}")
  end

  def self.graphviz(text, args)
    frmt = check_format(args)
    name = construct_cache_key(text)
    settings_binary = Setting.plugin_graphviz['graphviz_binary_default']
    if File.file?(graphviz_file(name, '.dot'))
      unless File.file?(graphviz_file(name, frmt[:ext]))
        `"#{settings_binary}" -T "#{frmt[:type]}" "#{graphviz_file(name, '.dot')}" -o "#{graphviz_file(name, frmt[:ext])}"`
      end
    else
      File.open(graphviz_file(name, '.dot'), 'w') do |file|
        file.write sanitize_graphviz(text) + "\n"
      end
      `"#{settings_binary}" -T "#{frmt[:type]}" #{graphviz_file(name, '.dot')} -o "#{graphviz_file(name, frmt[:ext])}"`
    end
    name
  end

  def self.sanitize_graphviz(text)
    return text if Setting.plugin_graphviz['allow_includes']
    text.gsub!(/!include.*$/, '')
    text
  end
end
