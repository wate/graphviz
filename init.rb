Redmine::Plugin.register :graphviz do
  name 'Graphviz plugin for Redmine'
  author 'Yoshiaki Tanaka'
  description 'This is a plugin for Redmine which renders Graphviz diagrams.'
  version '0.0.1'
  url 'https://github.com/wate/redmine_graphviz'

  requires_redmine version: '2.6'..'3.4'

  settings(partial: 'settings/graphviz',
           default: { 'graphviz_binary' => {}, 'cache_seconds' => '0', 'allow_includes' => false })

  Redmine::WikiFormatting::Macros.register do
    desc <<EOF
      Render Graphviz image.
      <pre>
      {{graphviz(png)
      digraph g {
        graph [
          charset = "UTF-8";
          label = "sample graph",
          labelloc = "t",
          labeljust = "c",
          bgcolor = "#343434",
          fontcolor = white,
          fontsize = 18,
          style = "filled",
          rankdir = TB,
          margin = 0.2,
          splines = spline,
          ranksep = 1.0,
          nodesep = 0.9
        ];

        node [
          colorscheme = "rdylgn11"
          style = "solid,filled",
          fontsize = 16,
          fontcolor = 6,
          fontname = "Migu 1M",
          color = 7,
          fillcolor = 11,
          fixedsize = true,
          height = 0.6,
          width = 1.2
        ];

        edge [
          style = solid,
          fontsize = 14,
          fontcolor = white,
          fontname = "Migu 1M",
          color = white,
          labelfloat = true,
          labeldistance = 2.5,
          labelangle = 70
        ];

        // node define
        alpha [shape = box];
        beta [shape = box];
        gamma [shape = Msquare];
        delta [shape = box];
        epsilon [shape = trapezium];
        zeta [shape = Msquare];
        eta;
        theta [shape = doublecircle];

        // edge define
        alpha -> beta [label = "a-b", arrowhead = normal];
        alpha -> gamma [label = "a-g"];
        beta -> delta [label = "b-d"];
        beta -> epsilon [label = "b-e", arrowhead = tee];
        gamma -> zeta [label = "g-z"];
        gamma -> eta [label = "g-e", style = dotted];
        delta -> theta [arrowhead = crow];
        zeta -> theta [arrowhead = crow];
      }
      }}
      </pre>

      Available options are:
      ** (png|svg)
EOF
    macro :graphviz do |obj, args, text|
      raise 'No Graphviz binary set.' if Setting.plugin_graphviz['graphviz_binary_default'].blank?
      raise 'No or bad arguments.' if args.size != 1
      frmt = PlantumlHelper.check_format(args.first)
      image = PlantumlHelper.graphviz(text, args.first)
      image_tag "/graphviz/#{frmt[:type]}/#{image}#{frmt[:ext]}"
    end
  end
end

Rails.configuration.to_prepare do
  # Guards against including the module multiple time (like in tests)
  # and registering multiple callbacks

  unless Redmine::WikiFormatting::Textile::Helper.included_modules.include? GraphvizHelperPatch
    Redmine::WikiFormatting::Textile::Helper.send(:include, GraphvizHelperPatch)
  end
end
