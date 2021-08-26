Redmine::Plugin.register :graphviz do
  name 'Graphviz plugin for Redmine'
  author 'Yoshiaki Tanaka'
  description 'This is a plugin for Redmine which renders Graphviz diagrams.'
  version '0.2.4'
  url 'https://github.com/wate/redmine_graphviz'

  settings(partial: 'settings/graphviz',
           default: { 'graphviz_binary' => '/usr/bin/dot', 'allow_includes' => false })

  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render Graphviz image.

      {{graphviz(png)
      digraph G {
        未対応 -> 対応中 -> 対応済み -> 完了;
        未対応 -> 破棄;
        対応済み -> フィードバック;
        フィードバック -> 対応中;
        フィードバック -> 対応済み;
      }
      }}

      Available options are:
      ** (png|svg)
EOF

    macro :graphviz do |obj, args, text|
      raise 'No or bad arguments.' if args.size != 1
      frmt = GraphvizHelper.check_format(args.first)
      image = GraphvizHelper.graphviz(text, args.first)
      image_tag "/graphviz/#{frmt[:type]}/#{image}#{frmt[:ext]}"
    end
  end
  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render attached dot file.

      {{graphviz_attach(diagram.dot)}}
      {{graphviz_attach(diagram.dot, format=png)}} -- with image format
      ** Available formt options are "png" or "svg"
EOF
    macro :graphviz_attach do |obj, args|
      args, options = extract_macro_options(args, :format)
      filename = args.first
      raise 'Filename required' unless filename.present?
      frmt = GraphvizHelper.check_format(options[:format])
      if obj && obj.respond_to?(:attachments) && attachment = Attachment.latest_attach(obj.attachments, filename)
        image = GraphvizHelper.graphviz(File.read(attachment.diskfile), frmt[:type])
        image_tag "/graphviz/#{frmt[:type]}/#{image}#{frmt[:ext]}"
      else
        raise "Attachment #{filename} not found"
      end
    end
  end
end

Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks
  unless Redmine::WikiFormatting::Markdown::Helper.included_modules.include? GraphvizHelperPatch
    Redmine::WikiFormatting::Markdown::Helper.send(:include, GraphvizHelperPatch)
  end
end
