module Graphviz
  module Hooks
    class ViewsLayoutsHook < Redmine::Hook::ViewListener
      def view_layouts_base_html_head(_context)
        stylesheet_link_tag(:graphviz, plugin: 'graphviz')
      end

      def view_layouts_base_body_bottom(_context)
        javascript_include_tag(:graphviz, plugin: 'graphviz')
      end
    end
  end
end
