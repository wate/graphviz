require File.expand_path('../../test_helper', __FILE__)

class GraphvizMacroTest < ActionController::TestCase
  include ApplicationHelper
  include ActionView::Helpers::AssetTagHelper
  include ERB::Util

  def setup
    Setting.plugin_graphviz['graphviz_binary_default'] = '/usr/bin/graphviz'
  end

  def test_graphviz_macro_with_png
    text = <<-RAW
{{graphviz(png)
Bob -> Alice : hello
}}
RAW
    assert_include '/graphviz/png/graphviz_88358e9331985a8ad4ec566b38dfd68a2875ead47b187542e2bea02c670d50ff.png', textilizable(text)
  end

  def test_graphviz_macro_with_svg
    text = <<-RAW
{{graphviz(svg)
Bob -> Alice : hello
}}
RAW
    assert_include '/graphviz/svg/graphviz_88358e9331985a8ad4ec566b38dfd68a2875ead47b187542e2bea02c670d50ff.svg', textilizable(text)
  end

end
