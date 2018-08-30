require_dependency 'redmine/wiki_formatting/textile/helper'

module GraphvizHelperPatch
  def self.included(base) # :nodoc:
    base.send(:include, HelperMethodsWikiExtensions)

    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :heads_for_wiki_formatter, :graphviz
    end
  end
end

module HelperMethodsWikiExtensions
  # extend the editor Toolbar for adding a graphviz button
  # overwrite this helper method to have full control about the load order
  def heads_for_wiki_formatter_with_graphviz
    return if @heads_for_wiki_graphviz_included
    content_for :header_tags do
      javascript_include_tag('jstoolbar/jstoolbar-textile.min') +
        javascript_include_tag("jstoolbar/lang/jstoolbar-#{current_language.to_s.downcase}") +
        stylesheet_link_tag('jstoolbar') +
        javascript_include_tag('graphviz.js', plugin: 'graphviz') +
        stylesheet_link_tag('graphviz.css', plugin: 'graphviz')
    end
    @heads_for_wiki_graphviz_included = true
  end
end
